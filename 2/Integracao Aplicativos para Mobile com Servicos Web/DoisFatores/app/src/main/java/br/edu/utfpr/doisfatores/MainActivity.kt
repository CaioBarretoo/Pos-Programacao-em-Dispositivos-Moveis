package br.edu.utfpr.doisfatores

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth

class MainActivity : AppCompatActivity() {

    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.main_activity)

        auth = FirebaseAuth.getInstance()

        val tvUserInfo: TextView = findViewById(R.id.tvUserInfo)
        val btnLogout: Button = findViewById(R.id.btnLogout)

        val currentUser = auth.currentUser
        if (currentUser != null) {
            tvUserInfo.text = "Bem-vindo,\n${currentUser.email ?: "Usuário desconhecido"}!"
        } else {
            startActivity(Intent(this, LoginActivity::class.java))
            finish()
        }

        btnLogout.setOnClickListener {
            auth.signOut()
            Toast.makeText(this, "Logout realizado.", Toast.LENGTH_SHORT).show()
            startActivity(Intent(this, LoginActivity::class.java))
            finish()
        }
    }
}