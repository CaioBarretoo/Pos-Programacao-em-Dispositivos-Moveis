package br.edu.utfpr.doisfatores

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import br.edu.utfpr.doisfatores.data.DatabaseHandler
import br.edu.utfpr.doisfatores.databinding.LoginActivityBinding
import br.edu.utfpr.doisfatores.utils.Validators
import com.google.firebase.auth.FirebaseAuth

class LoginActivity : AppCompatActivity() {

    private lateinit var binding: LoginActivityBinding
    private lateinit var auth: FirebaseAuth
    private lateinit var banco : DatabaseHandler
    private lateinit var otpVerificationLauncher: ActivityResultLauncher<Intent>
    private lateinit var validators : Validators


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = LoginActivityBinding.inflate(layoutInflater)
        setContentView(binding.root)

        auth = FirebaseAuth.getInstance()
        banco = DatabaseHandler(this)
        validators = Validators()



        if (auth.currentUser != null) {
            startActivity(Intent(this, MainActivity::class.java))
            finish()
        }

        otpVerificationLauncher = registerForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result ->

            if (result.resultCode == RESULT_OK) {

                val data: Intent? = result.data
                val isSuccessful = data?.getBooleanExtra(OtpVerificationActivity.EXTRA_IS_VERIFICATION_SUCCESSFUL, false) ?: false
                val email = data?.getStringExtra(OtpVerificationActivity.EXTRA_EMAIL) ?: ""
                val password = data?.getStringExtra(OtpVerificationActivity.EXTRA_PASSWORD) ?: ""

                if (isSuccessful) {
                    auth.signInWithEmailAndPassword(email, password)
                        .addOnCompleteListener(this) { task ->
                            if (task.isSuccessful) {
                                Log.d(TAG, "signInWithEmail:success")
                                Toast.makeText(this, "Login concluído com sucesso!", Toast.LENGTH_LONG).show()

                                startActivity(Intent(this, MainActivity::class.java))
                                finish()
                            } else {
                                Log.w(TAG, "signInWithEmail:failure", task.exception)
                                Toast.makeText(baseContext, "Falha na autenticação: ${task.exception?.message}",
                                    Toast.LENGTH_LONG).show()
                            }
                        }

                } else {
                    Toast.makeText(this, "Verificação falhou. Tente novamente.", Toast.LENGTH_LONG).show()
                    return@registerForActivityResult

                }
            } else {
                // A Activity foi cancelada (por exemplo, usuário pressionou Voltar)
                Toast.makeText(this, "Verificação de OTP cancelada.", Toast.LENGTH_SHORT).show()
                return@registerForActivityResult
            }
        }




        binding.btnLogin.setOnClickListener {
            val email = binding.etEmailLogin.text.toString().trim()
            val password = binding.etPasswordLogin.text.toString().trim()

            if (email.isEmpty() || password.isEmpty()) {
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

            val user = banco.find(email)

            if(user == null){
                Toast.makeText(this, "Email não cadastrado.", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            startOtpVerificationActivity(user.phoneNumber, email, password)

        }

        binding.btnRegister.setOnClickListener {
            startActivity(Intent(this, RegisterActivity::class.java))
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

    companion object {
        private const val TAG = "LoginActivity"
    }
}