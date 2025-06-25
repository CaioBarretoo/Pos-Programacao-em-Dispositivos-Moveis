package br.edu.utfpr.doisfatores

import android.R
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import br.edu.utfpr.doisfatores.data.DatabaseHandler
import br.edu.utfpr.doisfatores.databinding.RegisterActivityBinding
import br.edu.utfpr.doisfatores.entity.User
import br.edu.utfpr.doisfatores.utils.Validators
import com.google.firebase.auth.FirebaseAuth


data class CountryCode(val name: String, val code: String, val flagEmoji: String?, val isoCode: String)


class RegisterActivity : AppCompatActivity() {

    private lateinit var binding: RegisterActivityBinding
    private lateinit var auth: FirebaseAuth

    private lateinit var otpVerificationLauncher: ActivityResultLauncher<Intent>

    private lateinit var banco : DatabaseHandler
    private lateinit var validators : Validators



    private val countryCodes = listOf(
        CountryCode("Brasil", "+55", "🇧🇷", "BR"),
        CountryCode("Estados Unidos", "+1", "🇺🇸", "US"),
        CountryCode("Portugal", "+351", "🇵🇹", "PT"),
        CountryCode("Argentina", "+54", "🇦🇷", "AR"),
        CountryCode("Alemanha", "+49", "🇩🇪", "DE"),
        CountryCode("Japão", "+81", "🇯🇵", "JP"),
    )


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = RegisterActivityBinding.inflate(layoutInflater)
        setContentView(binding.root)

        auth = FirebaseAuth.getInstance()
        banco = DatabaseHandler(this)
        validators = Validators()

        setupCountryCodeSpinner()
        setDefaultCountryCode()

        otpVerificationLauncher = registerForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result ->

            if (result.resultCode == RESULT_OK) {

                val data: Intent? = result.data
                val isSuccessful = data?.getBooleanExtra(OtpVerificationActivity.EXTRA_IS_VERIFICATION_SUCCESSFUL, false) ?: false
                val email = data?.getStringExtra(OtpVerificationActivity.EXTRA_EMAIL) ?: ""
                val password = data?.getStringExtra(OtpVerificationActivity.EXTRA_PASSWORD) ?: ""
                val phoneNumber = data?.getStringExtra(OtpVerificationActivity.EXTRA_PHONE_NUMBER) ?: ""

                if (isSuccessful) {
                    auth.createUserWithEmailAndPassword(email, password)
                        .addOnCompleteListener(this) { task ->
                            if (task.isSuccessful) {
                                Log.d(TAG, "createUserWithEmail:success")

                                banco.insert(User(0, email, phoneNumber))
                                Toast.makeText(this, "Usuário cadastrado com sucesso!", Toast.LENGTH_LONG).show()

                                startActivity(Intent(this, MainActivity::class.java))

                                finish()
                            } else {
                                Log.w(TAG, "createUserWithEmail:failure", task.exception)
                                Toast.makeText(baseContext, "Falha no registro: ${task.exception?.message}",
                                    Toast.LENGTH_LONG).show()
                            }
                        }

                } else {
                    Toast.makeText(this, "Verificação falhou. Tente novamente.", Toast.LENGTH_LONG).show()
                    return@registerForActivityResult

                }
            } else {
                Toast.makeText(this, "Verificação de OTP cancelada.", Toast.LENGTH_SHORT).show()
                return@registerForActivityResult
            }
        }

        binding.btnSubmitRegister.setOnClickListener {
            val email = binding.etEmailRegister.text.toString().trim()
            val password = binding.etPasswordRegister.text.toString().trim()
            val selectedCountry = countryCodes[binding.spinnerCountryCode.selectedItemPosition]
            val selectedCountryCode = selectedCountry.code
            val phoneNumber = binding.etPhoneNumberRegister.text.toString().trim()
            val fullPhoneNumber = "$selectedCountryCode$phoneNumber"
            val selectedCountryIsoCode = selectedCountry.isoCode


            if (email.isEmpty() || password.isEmpty() || phoneNumber.isEmpty()) {
                Toast.makeText(this, "Preencha todos os campos.", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            if (!validators.isValidEmail(email)) {
                Toast.makeText(this, "O e-mail não possui um formato válido.", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            if (password.length < 6) {
                Toast.makeText(this, "A senha deve ter no mínimo 6 caracteres.", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            if (!validators.isValidPhoneNumberLib(fullPhoneNumber, selectedCountryIsoCode)) {
                binding.etPhoneNumberRegister.error = "Número de telefone inválido (Ex: +5511987654321)"
                return@setOnClickListener
            }

            startOtpVerificationActivity(fullPhoneNumber, email, password)
        }
    }


    private fun startOtpVerificationActivity(phoneNumber: String, email: String, password: String) {
        val intent = Intent(this, OtpVerificationActivity::class.java).apply {
            putExtra(OtpVerificationActivity.EXTRA_PHONE_NUMBER, phoneNumber);
            putExtra(OtpVerificationActivity.EXTRA_EMAIL, email);
            putExtra(OtpVerificationActivity.EXTRA_PASSWORD, password);
        }
        otpVerificationLauncher.launch(intent)
    }

    private fun setupCountryCodeSpinner() {

        val adapter = ArrayAdapter(
            this,
            R.layout.simple_spinner_item,
            countryCodes.map { "${it.flagEmoji ?: ""} (${it.code})" }
        )
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        binding.spinnerCountryCode.adapter = adapter

        binding.spinnerCountryCode.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {
            }
        }
    }

    private fun setDefaultCountryCode() {
        val brasilIndex = countryCodes.indexOfFirst { it.code == "+55" }
        if (brasilIndex != -1) {
            binding.spinnerCountryCode.setSelection(brasilIndex)
        }
    }

    companion object {
        private const val TAG = "RegisterActivity"
    }
}