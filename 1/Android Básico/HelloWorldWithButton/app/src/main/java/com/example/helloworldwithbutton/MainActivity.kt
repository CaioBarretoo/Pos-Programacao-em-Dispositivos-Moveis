package com.example.helloworldwithbutton

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.TextView

class MainActivity : AppCompatActivity() , View.OnClickListener  {

    lateinit var btnAdd : Button
    lateinit var resultTv : TextView


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        btnAdd              = findViewById(R.id.btn_add)
        resultTv = findViewById(R.id.result_tv)

        btnAdd.setOnClickListener(this)

    }

    override fun onClick(v: View?){
        var result = 0.0
        when(v?.id){
            R.id.btn_add            ->{
                if(resultTv.text == "") {
                    resultTv.text = "Hello World"
                    btnAdd.text   = "End"
                }else{
                    resultTv.text = ""
                    btnAdd.text   = "Start"
                }

            }
        }
    }
}