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
import java.util.Timer
import java.util.TimerTask


class MainActivity : AppCompatActivity() {

    private lateinit var rbHora: RadioButton
    private lateinit var rbData: RadioButton
    private lateinit var tvResposta: TextView

    //private val ip = "10.0.2.2" // Usando Emulador

    private val ip = "192.168.1.10" //Usando Mobile
    private val port = 12345

    private lateinit var clienteSocket: Socket
    private lateinit var input: BufferedReader
    private lateinit var output: BufferedWriter

    var ultimoAcesso: Long = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        rbHora = findViewById(R.id.rbHora)
        rbData = findViewById(R.id.rbData)
        tvResposta = findViewById(R.id.tvResposta)

    }

    override fun onStart(){
        super.onStart()

        val timer = Timer()
        timer.schedule(ConexaoTask(), 0, 1000)
    }


    override fun onStop(){
        super.onStop()
        clienteSocket.close()
    }

    
    private fun comunicacaoServidor(msg: String){

        val acessoAtual: Long = System.currentTimeMillis()

        if(ultimoAcesso > 0){
            val tempoEntreExecucao = acessoAtual - ultimoAcesso
            println("Tempo entre execuções: $tempoEntreExecucao")
        }

        ultimoAcesso = acessoAtual

        var resposta = ""

        if(!::clienteSocket.isInitialized){
            clienteSocket = Socket(ip, port) //linha bloqueante

            input = clienteSocket.getInputStream().bufferedReader()
            output = clienteSocket.getOutputStream().bufferedWriter()
        }

        output.write(msg)
        output.flush()

        resposta = input.readLine() //linha bloqueante


        runOnUiThread{
            tvResposta.text = resposta
        }
    }

    inner class ConexaoTask: TimerTask(){
        override fun run() {
            comunicacaoServidor("hora")
        }
    }
}