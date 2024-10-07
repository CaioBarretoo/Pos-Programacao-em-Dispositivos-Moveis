package br.edu.utfpr.trabalhofinal.utils

import android.graphics.drawable.Icon
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ThumbDownOffAlt
import androidx.compose.material.icons.filled.ThumbUp
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import br.edu.utfpr.trabalhofinal.data.Conta
import br.edu.utfpr.trabalhofinal.data.TipoContaEnum
import java.math.BigDecimal
import java.text.DecimalFormat
import java.time.LocalDate
import java.time.format.DateTimeFormatter

fun List<Conta>.calcularSaldo(): BigDecimal = map {
    if (it.paga) {
        if (it.tipo == TipoContaEnum.DESPESA) {
            it.valor.negate()
        } else {
            it.valor
        }
    } else {
        BigDecimal.ZERO
    }
}.sumOf { it }

fun List<Conta>.calcularProjecao(): BigDecimal = map {
    if (it.tipo == TipoContaEnum.DESPESA) it.valor.negate() else it.valor
}.sumOf { it }

fun BigDecimal.formatar(): String {
    val formatter = DecimalFormat("R$#,##0.00;R$-#,##0.00")
    return formatter.format(this)
}

fun BigDecimal.formatar(tipo: TipoContaEnum): String {
    val formatter = when(tipo){
        TipoContaEnum.RECEITA -> DecimalFormat("R$#,##0.00")
        TipoContaEnum.DESPESA -> DecimalFormat("R$-#,##0.00")
    }
    return formatter.format(this)
}

fun LocalDate.formatar(): String {
    val formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy")
    return format(formatter)
}

fun Color.formatar(valor: BigDecimal): Color {
    return when {
        valor > BigDecimal.ZERO -> Color(0xFF00984E)
        valor < BigDecimal.ZERO -> Color(0xFFCF5355)
        else -> Color.Black
    }
}

fun Color.formatar(tipo: TipoContaEnum): Color {
    return when (tipo) {
        TipoContaEnum.DESPESA -> Color(0xFFCF5355)
        TipoContaEnum.RECEITA -> Color(0xFF00984E)
    }
}

fun Icons.formatar(conta: Conta): ImageVector {

    var icon = when (conta.paga) {
        true -> Icons.Filled.ThumbUp
        false -> Icons.Filled.ThumbDownOffAlt
    }
    return icon
}