package com.example.clientesocket_pos2025

import android.app.Service
import android.content.Intent
import android.os.IBinder
import java.net.Socket

class MyService : Service() {

    override fun onBind(intent: Intent): IBinder? {
       return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        Thread {

            val clientSocket = Socket("192.168.1.10", 12345)
            val input = clientSocket.getInputStream().bufferedReader()
            val output = clientSocket.getOutputStream().bufferedWriter()

            while (true) {
                output.write("hora\n")
                output.flush()

                val retorno: String = input.readLine()
                println(retorno)
                Thread.sleep(1000)
            }
        }.start()

        return START_NOT_STICKY
    }
}