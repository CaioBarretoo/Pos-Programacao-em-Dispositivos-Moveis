package br.edu.utfpr.usandosqlite_pos2024


import android.content.DialogInterface
import android.content.Intent
import android.os.Bundle
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
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

        binding.etCod.setEnabled(false)

        if(intent.getIntExtra("cod", 0) != 0){
            binding.etCod.setText(intent.getIntExtra("cod", 0).toString())
            binding.etNome.setText(intent.getStringExtra("nome"))
            binding.etTelefone.setText(intent.getStringExtra("telefone"))
        }

        banco = DatabaseHandler(this)

    }

    private fun setButtonListener() {
        binding.btSalvar.setOnClickListener{
            btSalvarOnClick()
        }

        binding.btPesquisar.setOnClickListener{
            btPesquisarOnClick()
        }

        binding.btExcluir.setOnClickListener{
            btExcluirOnClick()
        }
    }

    private fun btIncluirOnClick() {

        banco.insert(Cadastro(0, binding.etNome.text.toString(), binding.etTelefone.text.toString()))
        Toast.makeText(this, "Sucesso Gravar!!!", Toast.LENGTH_LONG).show()
    }

    private fun btSalvarOnClick() {
        if(binding.etCod.text.isEmpty()){
            banco.insert(Cadastro(0, binding.etNome.text.toString(), binding.etTelefone.text.toString()))
            Toast.makeText(this, "Sucesso Gravar!!!", Toast.LENGTH_LONG).show()
        }else {
            banco.update(Cadastro(binding.etCod.text.toString().toInt(), binding.etNome.text.toString(), binding.etTelefone.text.toString()))
            Toast.makeText(this, "Sucesso Alterar!!!", Toast.LENGTH_LONG).show()
        }

        finish()
    }

    private fun btExcluirOnClick() {

        banco.delete(binding.etCod.text.toString().toInt())
        Toast.makeText(this, "Sucesso Excluir!!!", Toast.LENGTH_LONG).show()

        finish()
    }

    private fun btPesquisarOnClick() {

        val builder = AlertDialog.Builder(this)

        val etCodPesquisar = EditText(this)

        builder.setTitle("Digite o código da pesquisa")
        builder.setView(etCodPesquisar)
        builder.setCancelable(false)
        builder.setNegativeButton("Fechar", null)
        builder.setPositiveButton("Pesquisar", DialogInterface.OnClickListener{dialogInterface, i ->
            val registro = banco.find(etCodPesquisar.text.toString().toInt())

            if(registro != null) {
                binding.etCod.setText(etCodPesquisar.text.toString())
                binding.etNome.setText(registro.nome)
                binding.etTelefone.setText(registro.telefone)
           }else {
                Toast.makeText(this, "Registro não Encontrado", Toast.LENGTH_LONG).show()
            }
        })

        builder.show()

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
        val intent = Intent(this, ListarActivity::class.java)
        startActivity(intent)
    }

    override fun onStart() {
        super.onStart()
        System.out.println("onStart() executado")
    }
    override fun onResume() {
        super.onResume()
        System.out.println("onResume() executado")
    }

    override fun onPause() {
        super.onPause()
        System.out.println("onPause() executado")
    }

    override fun onDestroy() {
        super.onDestroy()
        System.out.println("onDestroy() executado")
    }

    override fun onRestart() {
        super.onRestart()
        System.out.println("onRestart() executado")
    }
}