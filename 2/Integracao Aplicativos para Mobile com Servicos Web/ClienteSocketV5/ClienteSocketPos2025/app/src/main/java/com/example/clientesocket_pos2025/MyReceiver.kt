package com.example.clientesocket_pos2025

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import java.net.Socket

class MyReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {

        val isAirplanemodeEnable = intent.getBooleanExtra("state", false)
        if(isAirplanemodeEnable){
            Thread {

                val clientSocket = Socket("192.168.1.10", 12345)
                val input = clientSocket.getInputStream().bufferedReader()
                val output = clientSocket.getOutputStream().bufferedWriter()

                output.write("hora\n")
                output.flush()

                val retorno: String = input.readLine()
                println(retorno)

            }.start()
        }
    }
}