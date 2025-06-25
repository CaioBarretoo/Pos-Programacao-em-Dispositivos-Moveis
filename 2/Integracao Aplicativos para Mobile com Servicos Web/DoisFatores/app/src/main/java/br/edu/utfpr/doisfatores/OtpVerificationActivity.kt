package br.edu.utfpr.doisfatores

import android.content.Intent
import android.os.Bundle
import android.util.Base64
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import br.edu.utfpr.doisfatores.databinding.OtpVerificationActivityBinding
import br.edu.utfpr.doisfatores.utils.ApiKeys
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.FormBody
import okhttp3.OkHttpClient
import okhttp3.Request
import java.io.IOException


class OtpVerificationActivity : AppCompatActivity() {

    private lateinit var binding: OtpVerificationActivityBinding


    private var receivedPhoneNumber: String? = null

    companion object {
        const val EXTRA_IS_VERIFICATION_SUCCESSFUL = "is_verification_successful"
        const val EXTRA_PHONE_NUMBER = "phone_number"
        const val EXTRA_EMAIL = "email"
        const val EXTRA_PASSWORD = "password"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = OtpVerificationActivityBinding.inflate(layoutInflater)
        setContentView(binding.root)

        ApiKeys.loadSecrets(applicationContext)

        receivedPhoneNumber = intent.getStringExtra(EXTRA_PHONE_NUMBER)

        binding.btnVerifyCode.setOnClickListener {
            val otpCode = binding.etOtpCode.text.toString().trim()
            if (otpCode.isNotEmpty()) {
                verifyOtpWithTwilio(otpCode)
            } else {
                Toast.makeText(this, "Por favor, insira o código OTP.", Toast.LENGTH_SHORT).show()
            }
        }

        binding.btnResendCode.setOnClickListener {
            Toast.makeText(this, "Reenviando código...", Toast.LENGTH_SHORT).show()
            receivedPhoneNumber?.let {
                sendOtp(it)
            } ?: Toast.makeText(this, "Número de telefone não disponível para reenviar.", Toast.LENGTH_SHORT).show()
        }

        if (receivedPhoneNumber != null) {
            sendOtp(receivedPhoneNumber!!)
        } else {
            Toast.makeText(this, "Erro: Número de telefone não recebido. Voltando.", Toast.LENGTH_LONG).show()
            finish()
        }
    }

    private fun sendOtp(phoneNumber: String) {
        showLoading(true)

        val url = "https://verify.twilio.com/v2/Services/" + ApiKeys.getTwilioVerifyServiceSid() + "/Verifications"
        val credentials = ApiKeys.getTwilioAccountSid() + ":" + ApiKeys.getTwilioAuthToken()
        val authHeader = "Basic " + Base64.encodeToString(credentials.toByteArray(), Base64.NO_WRAP)

        val requestBody = FormBody.Builder()
            .add("To", phoneNumber)
            .add("Channel", "sms")
            .build()

        val request = Request.Builder()
            .url(url)
            .header("Authorization", authHeader)
            .post(requestBody)
            .build()

        val client = OkHttpClient()

        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = client.newCall(request).execute()
                val responseBody = response.body?.string()

                if (response.isSuccessful) {
                    Log.d("Twilio", "Verificação iniciada com sucesso: $responseBody")
                    runOnUiThread {
                        showLoading(false)
                        Toast.makeText(this@OtpVerificationActivity, "Código OTP enviado para $phoneNumber", Toast.LENGTH_LONG).show()
                    }
                } else {
                    Log.e("Twilio", "Erro ao iniciar verificação: ${response.code} - $responseBody")
                    runOnUiThread {
                        showLoading(false)
                        Toast.makeText(this@OtpVerificationActivity, "Erro ao enviar OTP. Tente novamente.", Toast.LENGTH_LONG).show()
                    }
                }
            } catch (e: IOException) {
                Log.e("Twilio", "Exceção ao enviar SMS: ${e.message}", e)
                runOnUiThread {
                    showLoading(false)
                    Toast.makeText(this@OtpVerificationActivity, "Erro de rede ao enviar OTP.", Toast.LENGTH_LONG).show()
                }
            }
        }
    }


    private fun verifyOtpWithTwilio(otpCode: String) {
        showLoading(true)

        val url = "https://verify.twilio.com/v2/Services/" + ApiKeys.getTwilioVerifyServiceSid() + "/VerificationCheck"
        val credentials = ApiKeys.getTwilioAccountSid() + ":" + ApiKeys.getTwilioAuthToken()
        val authHeader = "Basic " + Base64.encodeToString(credentials.toByteArray(), Base64.NO_WRAP)

        val requestBody = FormBody.Builder()
            .add("To", receivedPhoneNumber!!)
            .add("Code", otpCode)
            .build()

        val request = Request.Builder()
            .url(url)
            .header("Authorization", authHeader)
            .post(requestBody)
            .build()

        val client = OkHttpClient()

        CoroutineScope(Dispatchers.IO).launch {
            try {
                val response = client.newCall(request).execute()
                val responseBody = response.body?.string()

                Log.d("TwilioVerify", "Resposta de verificação: $responseBody")

                val isApproved = responseBody?.contains("\"status\": \"approved\"") == true && response.isSuccessful

                runOnUiThread {
                    showLoading(false)
                    if (isApproved) {
                        Toast.makeText(this@OtpVerificationActivity, "OTP Verificado com Sucesso!", Toast.LENGTH_SHORT).show()
                        val resultIntent = Intent().apply {
                            putExtra(EXTRA_IS_VERIFICATION_SUCCESSFUL, true)
                            putExtra(EXTRA_EMAIL, intent.getStringExtra(EXTRA_EMAIL))
                            putExtra(EXTRA_PASSWORD, intent.getStringExtra(EXTRA_PASSWORD))
                            putExtra(EXTRA_PHONE_NUMBER, intent.getStringExtra(EXTRA_PHONE_NUMBER))
                        }
                        setResult(RESULT_OK, resultIntent)
                        finish()
                    } else {
                        Toast.makeText(this@OtpVerificationActivity, "Código OTP inválido ou expirado. Tente novamente.", Toast.LENGTH_SHORT).show()
                    }
                }
            } catch (e: IOException) {
                Log.e("TwilioVerify", "Exceção ao verificar OTP: ${e.message}", e)
                runOnUiThread {
                    showLoading(false)
                    Toast.makeText(this@OtpVerificationActivity, "Erro de rede ao verificar OTP.", Toast.LENGTH_LONG).show()
                }
            }
        }
    }

    private fun showLoading(show: Boolean) {
        binding.btnVerifyCode.isEnabled = !show
        binding.btnResendCode.isEnabled = !show
        binding.etOtpCode.isEnabled = !show
    }
}