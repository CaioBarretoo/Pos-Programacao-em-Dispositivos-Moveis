package com.example.clientesocket_pos2025

import android.os.AsyncTask
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.ProgressBar
import android.widget.RadioButton
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.BufferedReader
import java.io.BufferedWriter
import java.net.Socket


class MainActivity : AppCompatActivity() {

    private lateinit var rbHora: RadioButton
    private lateinit var rbData: RadioButton
    private lateinit var btEnviar: Button
    private lateinit var tvResposta: TextView
    private lateinit var progressBar: ProgressBar

    //private val ip = "10.0.2.2" // Usando Emulador

    private val ip = "192.168.1.10" //Usando Mobile
    private val port = 12345

    private lateinit var clienteSocket: Socket
    private lateinit var input: BufferedReader
    private lateinit var output: BufferedWriter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        rbHora = findViewById(R.id.rbHora)
        rbData = findViewById(R.id.rbData)
        btEnviar = findViewById(R.id.btEnviar)
        tvResposta = findViewById(R.id.tvResposta)
        progressBar = findViewById(R.id.progressBar)

        btEnviar.setOnClickListener {
            btEnviarOnClick()
        }
    }

    private fun btEnviarOnClick() {

        var msg = ""
        when (rbHora.isChecked) {
            true -> msg = "hora\n"
            false -> msg = "data\n"
        }

        lifecycleScope.launch {
            conexaoTask(msg)
        }
    }

    override fun onStop(){
        super.onStop()
        clienteSocket.close()
    }

    
    private suspend fun conexaoTask(msg: String){

        val resposta = ""

        withContext(Dispatchers.IO){
            if(!::clienteSocket.isInitialized){
                clienteSocket = Socket(ip, port) //linha bloqueante

                input = clienteSocket.getInputStream().bufferedReader()
                output = clienteSocket.getOutputStream().bufferedWriter()
            }

            output.write(msg)
            output.flush()

            val resposta = input.readLine() //linha bloqueante
        }

        withContext(Dispatchers.Main){
            tvResposta.text = resposta
        }
    }
}