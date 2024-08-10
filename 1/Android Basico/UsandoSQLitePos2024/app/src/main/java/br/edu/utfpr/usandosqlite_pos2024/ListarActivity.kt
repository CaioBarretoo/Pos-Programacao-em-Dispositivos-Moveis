package br.edu.utfpr.usandosqlite_pos2024

import android.content.Intent
import android.os.Bundle
import android.widget.ArrayAdapter
import android.widget.SimpleCursorAdapter
import androidx.appcompat.app.AppCompatActivity
import br.edu.utfpr.usandosqlite_pos2024.adapter.MeuAdapter
import br.edu.utfpr.usandosqlite_pos2024.database.DatabaseHandler
import br.edu.utfpr.usandosqlite_pos2024.databinding.ActivityListarBinding

class ListarActivity : AppCompatActivity() {
    private lateinit var binding: ActivityListarBinding
    private lateinit var banco: DatabaseHandler
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityListarBinding.inflate(layoutInflater)
        setContentView(binding.root)

        banco = DatabaseHandler(this)

        binding.btIncluir.setOnClickListener{
            btIncluirOnClick()
        }

    }

    private fun btIncluirOnClick() {
        val intent = Intent(this, MainActivity::class.java)
        startActivity(intent)
    }

    override fun onStart() {
        super.onStart()

        val registros = banco.cursorList() // fonte

        val adapter = MeuAdapter(this, registros)

        binding.lvPrincipal.adapter = adapter //Destino
    }
}