package br.edu.utfpr.usandocomponentesvisuais

import android.annotation.SuppressLint
import android.graphics.Color
import android.os.Bundle
import android.view.View
import android.widget.LinearLayout
import android.widget.RadioButton
import android.widget.RadioGroup
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.google.android.material.snackbar.Snackbar

class MainActivity : AppCompatActivity() {

    private lateinit var rgSexo: RadioGroup

    private lateinit var rbMasculino: RadioButton
    private lateinit var rbFeminino: RadioButton
    private lateinit var main : LinearLayout

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        rgSexo = findViewById(R.id.rgSexo)
        rbMasculino = findViewById(R.id.rbMasculino)
        rbFeminino = findViewById(R.id.rbFeminino)

        main = findViewById(R.id.main)

        rgSexo.setOnCheckedChangeListener{ _, checkedId ->
            Snackbar.make(main , "Componente Selecionado", Snackbar.LENGTH_SHORT).show()
        }
    }

    fun btTestarComponentesOnClick(view: View) {
        if(rbMasculino.isChecked){
            val snackbar = Snackbar.make(main, "Masculino Selecionado", Snackbar.LENGTH_INDEFINITE)
            snackbar.setBackgroundTint(Color.RED)
            snackbar.setAction("Cancelar"){
                snackbar.dismiss()
            }

            snackbar.show()
        }
    }
}