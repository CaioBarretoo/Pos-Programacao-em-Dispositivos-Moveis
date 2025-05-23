package com.example.clientesocket_pos2025

import android.os.AsyncTask
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.ProgressBar
import android.widget.RadioButton
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
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

        ConexaoTask().execute(msg)
    }

    override fun onStop(){
        super.onStop()
        clienteSocket.close()
    }

    inner class ConexaoTask : AsyncTask<String, Int, String>() {

        override fun onPreExecute() {
            progressBar.visibility = View.VISIBLE
        }

        override fun doInBackground(vararg msg: String?): String {

            Thread.sleep(100)
            publishProgress(1)

            if(!::clienteSocket.isInitialized){
                clienteSocket = Socket(ip, port) //linha bloqueante
                Thread.sleep(100)
                publishProgress(2)

                input = clienteSocket.getInputStream().bufferedReader()
                output = clienteSocket.getOutputStream().bufferedWriter()
                Thread.sleep(100)
                publishProgress(3)
            }

            output.write(msg[0])
            output.flush()
            Thread.sleep(100)
            publishProgress(4)

            val resposta = input.readLine() //linha bloqueante
            Thread.sleep(100)
            publishProgress(5)

            Thread.sleep(100)
            publishProgress(6)

            Thread.sleep(100)
            publishProgress(7)

            Thread.sleep(100)
            publishProgress(8)

            Thread.sleep(100)
            publishProgress(9)

            Thread.sleep(100)
            publishProgress(10)

            return resposta
        }

        override fun onPostExecute(result: String?) {
            //Thread.sleep(1000)
            tvResposta.text = result
            progressBar.visibility = View.GONE
        }

        override fun onProgressUpdate(vararg values: Int?) {
            progressBar.progress = values[0]!!
        }
    }
}