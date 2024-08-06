package br.edu.utfpr.usandosqlite_pos2024


import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import br.edu.utfpr.usandosqlite_pos2024.database.DatabaseHandler
import br.edu.utfpr.usandosqlite_pos2024.databinding.ActivityMainBinding
import br.edu.utfpr.usandosqlite_pos2024.entity.Cadastro


class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private lateinit var banco : DatabaseHandler

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setButtonListener()

        banco = DatabaseHandler(this)

    }

    private fun setButtonListener() {
        binding.btIncluir.setOnClickListener{
            btIncluirOnClick()
        }

        binding.btAlterar.setOnClickListener{
            btAlterarOnClick()
        }

        binding.btPesquisar.setOnClickListener{
            btPesquisarOnClick()
        }

        binding.btListar.setOnClickListener{
            btListarOnClick()
        }

        binding.btExcluir.setOnClickListener{
            btExcluirOnClick()
        }
    }

    private fun btIncluirOnClick() {

        banco.insert(Cadastro(0, binding.etNome.text.toString(), binding.etTelefone.text.toString()))
        Toast.makeText(this, "Sucesso Gravar!!!", Toast.LENGTH_LONG).show()
    }

    private fun btAlterarOnClick() {

        banco.update(Cadastro(binding.etCod.text.toString().toInt(), binding.etNome.text.toString(), binding.etTelefone.text.toString()))
        Toast.makeText(this, "Sucesso Alterar!!!", Toast.LENGTH_LONG).show()
    }

    private fun btExcluirOnClick() {

        banco.delete(binding.etCod.text.toString().toInt())
        Toast.makeText(this, "Sucesso Excluir!!!", Toast.LENGTH_LONG).show()
    }

    private fun btPesquisarOnClick() {

        val registro = banco.find(binding.etCod.text.toString().toInt())

        if(registro != null) {
            binding.etNome.setText(registro.nome)
            binding.etTelefone.setText(registro.telefone)
        }else {
            Toast.makeText(this, "Registro não Encontrado", Toast.LENGTH_LONG).show()
        }
    }

    private fun btListarOnClick() {

//        val registro = banco.list()
//
//        var saida = StringBuilder()
//
//        registro.forEach {
//            saida.append(it._id)
//            saida.append("-")
//            saida.append(it.nome)
//            saida.append("-")
//            saida.append(it.telefone)
//            saida.append("\n")
//        }
//        Toast.makeText(this, saida.toString(), Toast.LENGTH_LONG).show()
//    }
        val intent = Intent(this, ListarActivity::class.java)
        startActivity(intent)
}