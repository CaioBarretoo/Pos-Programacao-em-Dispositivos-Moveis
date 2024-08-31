package br.edu.utfpr.usandosqlite_pos2024.adapter

import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.ImageButton
import android.widget.TextView
import br.edu.utfpr.usandosqlite_pos2024.MainActivity
import br.edu.utfpr.usandosqlite_pos2024.R
import br.edu.utfpr.usandosqlite_pos2024.database.DatabaseHandler.Companion.COD
import br.edu.utfpr.usandosqlite_pos2024.database.DatabaseHandler.Companion.NOME
import br.edu.utfpr.usandosqlite_pos2024.database.DatabaseHandler.Companion.TELEFONE
import br.edu.utfpr.usandosqlite_pos2024.entity.Cadastro

class MeuAdapter(val context: Context, val registros: MutableList<Cadastro>): BaseAdapter(){
    override fun getCount(): Int {
        return registros.size
    }

    override fun getItem(position: Int): Any {
        return registros.get(position)
    }

    override fun getItemId(position: Int): Long {
        val cadastro =  registros.get(position)
        return cadastro._id.toLong()
    }

    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val inflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val v = inflater.inflate(R.layout.elemento_lista, null)

        val tvNomeElementoLista = v.findViewById<TextView>(R.id.tvNomeElementoLista)
        val tvTelefoneElementoLista = v.findViewById<TextView>(R.id.tvTelefoneElementoLista)
        val btEditarElementoLista = v.findViewById<ImageButton>(R.id.btEditarElementoLista)

        val cadastro = registros.get(position)

        tvNomeElementoLista.setText(cadastro.nome)
        tvTelefoneElementoLista.setText(cadastro.telefone)

        btEditarElementoLista.setOnClickListener {
            val cadastro = registros.get(position)


            val intent = Intent(context, MainActivity::class.java)

            intent.putExtra("cod", cadastro._id)
            intent.putExtra("nome", cadastro.nome)
            intent.putExtra("telefone", cadastro.telefone)

            context.startActivity(intent)
        }

        return v
    }
}