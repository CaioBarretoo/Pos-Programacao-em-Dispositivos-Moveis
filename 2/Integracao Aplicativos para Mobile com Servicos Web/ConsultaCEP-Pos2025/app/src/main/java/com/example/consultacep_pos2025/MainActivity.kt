package com.example.consultacep_pos2025

import android.os.Bundle
import android.view.View
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.example.consultacep_pos2025.api.RetrofitClient
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : AppCompatActivity() {

    private lateinit var etCEP: EditText
    private lateinit var tvResposta: TextView



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        etCEP = findViewById(R.id.etCEP)
        tvResposta = findViewById(R.id.tvResposta)
    }

    fun btConsultarCEPOnClik(view: View) {

        lifecycleScope.launch(Dispatchers.IO ) {
            val cep = etCEP.text.toString()

            val endereco = RetrofitClient.viaCEPService.buscarCEP(cep)

            withContext(Dispatchers.Main ) {
                tvResposta.text = "${endereco.logradouro}  ${endereco.bairro}"
            }

        }

    }
}
