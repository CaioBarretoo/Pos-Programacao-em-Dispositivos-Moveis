package br.edu.utfpr.trocatelas

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity


class MainActivity : AppCompatActivity() {

    private lateinit var btLancamento : Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        btLancamento = findViewById(R.id.btLancamento)

        btLancamento.setOnClickListener {
            btLancamentoOnClick()
        }

    }

    private fun btLancamentoOnClick() {
        val intent = Intent(this, LancamentoActivity::class.java)
        startActivity(intent)
    }


}