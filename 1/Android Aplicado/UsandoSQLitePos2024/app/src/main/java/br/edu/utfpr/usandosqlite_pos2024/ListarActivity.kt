package br.edu.utfpr.usandosqlite_pos2024

import android.content.Intent
import android.os.Bundle
import android.widget.ArrayAdapter
import android.widget.SimpleCursorAdapter
import androidx.appcompat.app.AppCompatActivity
import br.edu.utfpr.usandosqlite_pos2024.adapter.MeuAdapter
import br.edu.utfpr.usandosqlite_pos2024.database.DatabaseHandler
import br.edu.utfpr.usandosqlite_pos2024.databinding.ActivityListarBinding
import br.edu.utfpr.usandosqlite_pos2024.entity.Cadastro
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

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

        val banco = Firebase.firestore


        banco.collection("cadastro")
            .get()
            .addOnSuccessListener { result ->
                var listaRegistros = mutableListOf<Cadastro>()
                for(document in result){
                    val cadastro = Cadastro(
                        document.data.get("_id").toString().toInt(),
                        document.data.get("nome").toString(),
                        document.data.get("telefone").toString()
                    )
                    listaRegistros.add(cadastro)
                }

                val adapter = MeuAdapter(this, listaRegistros)

                binding.lvPrincipal.adapter = adapter //Destino
            }
            .addOnFailureListener { e ->
                println("Erro${e.message}")
            }



//        val registros = banco.cursorList() // fonte

    }
}