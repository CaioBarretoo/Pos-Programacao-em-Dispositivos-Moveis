package br.edu.utfpr.consbustivel

import android.content.Intent
import android.os.Bundle
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.ListView
import androidx.appcompat.app.AppCompatActivity

class ListarActivity : AppCompatActivity() {

    private val produtos = listOf(
        "Gasolina" to 15.00,
        "Etanol" to 9.00,
        "Diesel" to 6.00,
        "Gás" to 3.00
    ).toMap()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_listar)

        val listView: ListView = findViewById(R.id.lvProdutos)
        val adapter = ArrayAdapter(this, android.R.layout.simple_list_item_1, produtos.keys.toList())
        listView.adapter = adapter

        listView.onItemClickListener = AdapterView.OnItemClickListener { _, _, position, _ ->
            val produtoSelecionado = produtos.keys.elementAt(position)
            val valorSelecionado = produtos[produtoSelecionado]

            val intent = Intent()
            intent.putExtra("Name", produtoSelecionado)
            intent.putExtra("Value", valorSelecionado)
            setResult(RESULT_OK, intent)
            finish()
        }
    }
}