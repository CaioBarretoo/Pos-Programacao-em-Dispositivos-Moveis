package br.edu.utfpr.bankingcontrol

import android.annotation.SuppressLint
import android.app.Activity
import android.app.DatePickerDialog
import android.content.Context
import android.os.Bundle
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.ArrayAdapter
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import br.edu.utfpr.bankingcontrol.database.DataBaseHandler
import br.edu.utfpr.bankingcontrol.databinding.ActivityPostBinding
import br.edu.utfpr.bankingcontrol.entity.Register
import br.edu.utfpr.bankingcontrol.manager.DateTextWatcher
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale


class PostActivity : AppCompatActivity() {

    private lateinit var binding: ActivityPostBinding
    private lateinit var banco: DataBaseHandler
    private val calendar = Calendar.getInstance()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityPostBinding.inflate(layoutInflater)
        setContentView(binding.root)

        banco = DataBaseHandler( this)

    }

    @SuppressLint("SetTextI18n")
    override fun onStart() {
        super.onStart()

        binding.tvType.setText("Crédito")
        updateDetailOptions("Crédito")


        val type = arrayOf("Crédito", "Débito")

        val adapter = ArrayAdapter(
            this,
            R.layout.dropdown_menu_popup_item,
            type
        )
        binding.tvType.setAdapter(adapter)

        binding.tvType.setOnItemClickListener { _, _, position, _ ->
            val selectedType = adapter.getItem(position)
            updateDetailOptions(selectedType)
        }
        binding.tvType.setOnClickListener(CustomClickListener())

        binding.ibCalendar.setOnClickListener{
            showDatePicker()
        }

        binding.etDate.addTextChangedListener(DateTextWatcher(binding.etDate))

        binding.btPay.setOnClickListener{
            onClickListenerBtPay()
        }

        val decimalFormat = DecimalFormat("0.00")
        binding.tvBalanceValue.text = decimalFormat.format(banco.getBalance("VALUE")).toString()

        binding.etValue.setOnFocusChangeListener { _, hasFocus ->
            if (!hasFocus) { // Campo perdeu o foco
                val valor = binding.etValue.text.toString().toDoubleOrNull() ?: 0.0
                val formatoMoeda = DecimalFormat("0.00")
                binding.etValue.setText(formatoMoeda.format(valor))
            }
        }

    }

    @SuppressLint("SetTextI18n")
    private fun updateDetailOptions(selectedType: String?) {
        binding.tvDetail.setText("")

        val detailOptions = when (selectedType) {
            "Crédito" -> {
                binding.btPay.setText(R.string.receber)
                listOf("Salário", "Extra")
            }
            "Débito" -> {
                binding.btPay.setText(R.string.pagar)
                listOf("Alimentação", "Transporte", "Saúde", "Moradia", "Outros")
            }

            else -> listOf()
        }

        val detailAdapter = ArrayAdapter(
            this,
            R.layout.dropdown_menu_popup_item,
            detailOptions
        )
        binding.tvDetail.setAdapter(detailAdapter)


    }

    private fun showDatePicker() {
        val datePickerDialog = DatePickerDialog(this, { _, year: Int, monthOfYear: Int, dayOfMonth: Int ->
            val selectedDate = Calendar.getInstance()
            selectedDate.set(year, monthOfYear, dayOfMonth)
            val dateFormat = SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())
            val formattedDate = dateFormat.format(selectedDate.time)
            binding.etDate.setText(formattedDate.toString())
            hideKeyboard()
        },
            calendar.get(Calendar.YEAR),
            calendar.get(Calendar.MONTH),
            calendar.get(Calendar.DAY_OF_MONTH)
        )

        datePickerDialog.show()
    }


    private fun onClickListenerBtPay() {
        if(binding.tvType.text.toString().isEmpty()){
            binding.tvType.error = "Selecione o tipo de pagamento"
            binding.tvType.requestFocus()
            return
        }
        if(binding.tvDetail.text.toString().isEmpty()){
            binding.tvDetail.error = "Selecione a decrição do pagamento"
            binding.tvDetail.requestFocus()
            return
        }
        if(binding.etValue.text.toString().isEmpty()){
            binding.etValue.error = "Valor é obrigatório"
            binding.etValue.requestFocus()
            return
        }

        if(binding.etDate.text.toString().isEmpty()){
            binding.etDate.error = "Data é obrigatório"
            binding.etDate.requestFocus()
            return
        }

        if(!validarData(binding.etDate.text.toString())){
            binding.etDate.error = "Digite uma data correta"
            binding.etDate.requestFocus()
            return
        }

        val value = binding.etValue.text.toString().replace(",", ".").toDouble()
        binding.etValue.setText(value.toString())

        if(binding.etValue.text.toString().toDouble() == 0.toDouble()){
            binding.etValue.error = "Valor não pode ser zero"
            binding.etValue.requestFocus()
            return
        }


        if (binding.tvType.text.toString() == "Débito") {
            val newValue = binding.etValue.text.toString().toDouble() * -1
            binding.etValue.setText(newValue.toString())

        }


        val cadastro = Register(
            0,
            binding.tvDetail.text.toString(),
            binding.etValue.text.toString().toDouble(),
            binding.etDate.text.toString()
        )
        banco.insert(cadastro)
        Toast.makeText(this, "${binding.tvType.text} efetuado com sucesso!", Toast.LENGTH_SHORT).show()

        finish()
    }

    fun Activity.hideKeyboard() {
        val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        imm.hideSoftInputFromWindow(currentFocus?.windowToken, 0)
    }


    fun validarData(texto: String, formato: String = "dd/MM/yyyy"): Boolean {
        return try {
            val formatoData = SimpleDateFormat(formato)
            formatoData.isLenient = false
            formatoData.parse(texto)
            true
        } catch (e: ParseException) {
            false
        }
    }

    class CustomClickListener : View.OnClickListener {
        override fun onClick(v: View?) {
        }
    }
}