package br.edu.utfpr.consbustivel

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.view.inputmethod.InputMethodManager
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import br.edu.utfpr.consbustivel.databinding.ActivityMainBinding
import java.text.DecimalFormat


class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)

        setContentView(binding.root)


        binding.btBuscar1.setOnClickListener {
            btBuscarOnClick(binding.btBuscar1)

        }

        binding.btBuscar2.setOnClickListener {
            btBuscarOnClick(binding.btBuscar2)

        }

        binding.btCalcular.setOnClickListener {
            btCalcularOnClick()
        }

        binding.btLimpar.setOnClickListener {
            btLimparOnClick()
        }

    }

    private fun btLimparOnClick() {
        binding.etFuel1.setText("")
        binding.etFuel2.setText("")
        binding.etMoney1.setText("")
        binding.etMoney2.setText("")
        binding.etResult.setText("")
        binding.tmCalculation.setText(getString(R.string.resultado))
        binding.layoutFuel1.hint  = getString(R.string.insira_km_l)
        binding.layoutFuel2.hint  = getString(R.string.insira_km_l)
        binding.layoutMoney1.hint = getString(R.string.insira_um_valor_em_r)
        binding.layoutMoney2.hint = getString(R.string.insira_um_valor_em_r)
        val imm = getSystemService(INPUT_METHOD_SERVICE) as InputMethodManager
        imm.hideSoftInputFromWindow(binding.root.windowToken, 0)
        binding.etFuel1.requestFocus()
        return
    }

    @SuppressLint("SetTextI18n")
    private fun btCalcularOnClick() {
        if (binding.etFuel1.text.toString().isEmpty()) {
            binding.etFuel1.error = getString(R.string.erro)
            binding.etFuel1.requestFocus()
            return
        }
        if (binding.etFuel2.text.toString().isEmpty()) {
            binding.etFuel2.error = getString(R.string.erro)
            binding.etFuel2.requestFocus()
            return
        }
        if (binding.etMoney1.text.toString().isEmpty()) {
            binding.etMoney1.error = getString(R.string.erro)
            binding.etMoney1.requestFocus()
            return
        }
        if (binding.etMoney2.text.toString().isEmpty()) {
            binding.etMoney2.error = getString(R.string.erro)
            binding.etMoney2.requestFocus()
            return
        }

        val imm = getSystemService(INPUT_METHOD_SERVICE) as InputMethodManager
        imm.hideSoftInputFromWindow(binding.root.windowToken, 0)


        var value1 = formatDoubleToTwoDecimalPlaces((binding.etMoney1.text.toString().toDouble() /
                binding.etFuel1.text.toString().toDouble()))

        var value2 = formatDoubleToTwoDecimalPlaces((binding.etMoney2.text.toString().toDouble() /
                binding.etFuel2.text.toString().toDouble()))


        binding.tmCalculation.setText(
            ("Resultado\n\n1° -> [R$${binding.etMoney1.text}L / ${binding.etFuel1.text}Km/L]\n= R$ $value1 p/L\n" +
                    "2° -> [R$${binding.etMoney2.text}L / ${binding.etFuel2.text}Km/L]\n= R$ $value2 p/L"))


        if (value1 < value2) {
            binding.etResult.setText("Abasteça com o 1°")
        } else if (value1 > value2) {
           binding.etResult.setText("Abasteça com o 2°")
        } else if (value1 == value2) {
           binding.etResult.setText("Abasteça com ambos")
        }
    }

    private fun btBuscarOnClick(view: View) {
        val intent = Intent(this, ListarActivity::class.java)
        when (view.id) {
            binding.btBuscar1.id -> {
                getResult.launch(intent)
            }

            binding.btBuscar2.id -> {
                getResult2.launch(intent)
            }
        }
    }

    private val getResult =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
            if (it.resultCode == RESULT_OK) {
                if (it.data != null) {
                    val nomeProduto = it.data?.getStringExtra("Name") ?: ""
                    val valorProduto = it.data?.getDoubleExtra("Value", 0.0) ?: 0.0
                    binding.layoutFuel1.hint = nomeProduto
                    binding.etFuel1.setText(valorProduto.toString())
                    binding.layoutMoney1.hint = "Valor do Litro em R$ - $nomeProduto"
                    binding.etFuel1.requestFocus(1)
                }
            }
        }


    private val getResult2 =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) {
            if (it.resultCode == RESULT_OK) {
                if (it.data != null) {
                    val nomeProduto = it.data?.getStringExtra("Name") ?: ""
                    val valorProduto = it.data?.getDoubleExtra("Value", 0.0) ?: 0.0
                    binding.layoutFuel2.hint = nomeProduto
                    binding.etFuel2.setText(valorProduto.toString())
                    binding.layoutMoney2.hint = "Valor do Litro em R$ - $nomeProduto"
                    binding.etFuel2.requestFocus(1)
                }
            }
        }

    fun formatDoubleToTwoDecimalPlaces(number: Double): String {
        val decimalFormat = DecimalFormat("0.00")
        return decimalFormat.format(number)
    }

}
