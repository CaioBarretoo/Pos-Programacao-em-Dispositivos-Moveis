package br.edu.utfpr.cadastrocategoria

import android.os.Bundle
import android.view.View
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import br.edu.utfpr.cadastrocategoria.api.ApiCategoria
import br.edu.utfpr.cadastrocategoria.model.Categoria
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import retrofit2.HttpException

class MainActivity : AppCompatActivity() {

    private lateinit var etId: EditText
    private lateinit var etNome: EditText

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        etId = findViewById(R.id.etId)
        etNome = findViewById(R.id.etNome)

    }

    fun btIncluirOnClick(view: View) {


        lifecycleScope.launch(Dispatchers.IO) {
            try {
                val id = etId.text.toString().toInt()
                val nome = etNome.text.toString()

                val categoria = Categoria(id, nome)

                ApiCategoria.retrofitService.save(categoria)

                lifecycleScope.launch(Dispatchers.Main) {
                    Toast.makeText(
                        this@MainActivity,
                        "Categoria salva com sucesso",
                        Toast.LENGTH_SHORT
                    ).show()
                }

            } catch (ex: Exception) {
                lifecycleScope.launch(Dispatchers.Main) {
                    Toast.makeText(
                        this@MainActivity,
                        "Erro ao salvar categoria",
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
        }
    }

    fun btAlterarOnClick(view: View) {

        lifecycleScope.launch(Dispatchers.IO) {
            try {
                val id = etId.text.toString().toInt()
                val nome = etNome.text.toString()

                val categoria = Categoria(id, nome)

                ApiCategoria.retrofitService.save(categoria)

                lifecycleScope.launch(Dispatchers.Main) {
                    Toast.makeText(
                        this@MainActivity,
                        "Categoria salva com sucesso",
                        Toast.LENGTH_SHORT
                    ).show()
                }

            } catch (ex: Exception) {
                lifecycleScope.launch(Dispatchers.Main) {
                    Toast.makeText(
                        this@MainActivity,
                        "Erro ao salvar categoria",
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
        }
    }

    fun btExcluirOnClick(view: View) {

        lifecycleScope.launch(Dispatchers.IO) {
            try {
                val id = etId.text.toString().toInt()

                ApiCategoria.retrofitService.delete(id)

                lifecycleScope.launch(Dispatchers.Main) {
                    Toast.makeText(
                        this@MainActivity,
                        "Categoria excluida com sucesso",
                        Toast.LENGTH_SHORT
                    ).show()
                }

            } catch (ex: Exception) {
                lifecycleScope.launch(Dispatchers.Main) {
                    Toast.makeText(
                        this@MainActivity,
                        "Erro ao excluir categoria",
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }
        }
    }

    fun btPesquisarOnClick(view: View) {

        lifecycleScope.launch(Dispatchers.IO) {
            try {
                val id = etId.text.toString().toInt()

                val categoria = ApiCategoria.retrofitService.findById(id)

                lifecycleScope.launch(Dispatchers.Main) {
                    etNome.setText(categoria.nome)
                    Toast.makeText(
                        this@MainActivity,
                        "Categoria recuperada com sucesso",
                        Toast.LENGTH_SHORT
                    ).show()
                }

            } catch (ex: HttpException) {

                if (ex.code() == 404) {
                    lifecycleScope.launch(Dispatchers.Main) {
                        Toast.makeText(
                            this@MainActivity,
                            "Categoria não existe",
                            Toast.LENGTH_SHORT
                        ).show()
                    }
                }


            } catch (ex: Exception) {
                lifecycleScope.launch(Dispatchers.Main) {
                    Toast.makeText(
                        this@MainActivity,
                        "Erro ao excluir categoria",
                        Toast.LENGTH_SHORT
                    ).show()
                }

            }
        }
    }

    fun btListarOnClick(view: View) {


        lifecycleScope.launch(Dispatchers.IO) {
            try {
                val categorias = ApiCategoria.retrofitService.findAll()

                lifecycleScope.launch(Dispatchers.Main) {

                    for (categoria in categorias) {
                        Toast.makeText(
                            this@MainActivity,
                            "${categoria.id} - ${categoria.nome}",
                            Toast.LENGTH_SHORT
                        ).show()
                    }
                }
            } catch (ex: Exception) {
                lifecycleScope.launch(Dispatchers.Main) {
                    Toast.makeText(
                        this@MainActivity,
                        "Erro ao excluir categoria",
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }

        }
    }
}