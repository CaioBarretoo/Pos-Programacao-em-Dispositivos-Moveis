package br.edu.utfpr.bankingcontrol.manager

import android.text.Editable
import android.text.TextWatcher
import android.widget.EditText
import kotlin.text.indices


class DateTextWatcher(private val editText: EditText) : TextWatcher {

    private var isRunning = false
    private var isDeleting = false

    override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {
        isDeleting = count > after
    }

    override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}

    override fun afterTextChanged(s: Editable?) {
        if (isRunning || isDeleting) {
            return
        }
        isRunning = true

        val text = s.toString()
        val formattedText = StringBuilder()
        var barCount = 0

        for (i in text.indices) {
            if (text[i] == '/') {
                barCount++
            } else if (barCount < 2 && (formattedText.length == 2 || formattedText.length == 5)) {
                formattedText.append('/')
                barCount++
            }
            formattedText.append(text[i])
        }

        editText.removeTextChangedListener(this)
        editText.setText(formattedText.toString())
        editText.setSelection(formattedText.length)
        editText.addTextChangedListener(this)

        isRunning = false
    }
}