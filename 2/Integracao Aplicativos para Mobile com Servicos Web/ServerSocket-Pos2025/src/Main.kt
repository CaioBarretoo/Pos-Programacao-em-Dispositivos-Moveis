import java.net.ServerSocket
import java.net.Socket
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
fun main() {
    val port = 12345

    val serverSocket = ServerSocket(port)
    println("Server is running on port $port")

    while (true) {

        val clientSocket = serverSocket.accept()
        println("Client connected: ${clientSocket.inetAddress.hostAddress}")

        Thread {
            tratarCliente(clientSocket)
        }.start()
    }

    //serverSocket.close()
    //println("Connection closed")

}

fun tratarCliente(clientSocket: Socket) {

    try {
        val input = clientSocket.getInputStream().bufferedReader()
        val output = clientSocket.getOutputStream().bufferedWriter()
        println("Creationg I/O streams")

        while (true) {
            val msg = input.readLine() //linha bloqueante
            println("Received: $msg")

            val resultado = processarPedido(msg)

            output.write("$resultado\n")
            output.flush()
            println("Sent: $resultado")
        }
    } catch (e: Exception) {
        println("Error: ${e.message}")
    } finally {
        clientSocket.close()
    }

}

fun processarPedido(protocolo: String): String {

    val dataHoraAtual = LocalDateTime.now()

    var retorno = ""

    when (protocolo) {
        "data" -> {
            val formatador = DateTimeFormatter.ofPattern("dd/MM/yyyy")
            retorno = dataHoraAtual.format(formatador)
        }

        "hora" -> {
            val formatador = DateTimeFormatter.ofPattern("HH:mm:ss")
            retorno = dataHoraAtual.format(formatador)
        }
    }
    return retorno
}
