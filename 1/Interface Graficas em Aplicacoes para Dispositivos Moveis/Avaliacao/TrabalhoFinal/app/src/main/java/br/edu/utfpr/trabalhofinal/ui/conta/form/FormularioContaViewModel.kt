package br.edu.utfpr.trabalhofinal.ui.conta.form
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import br.edu.utfpr.trabalhofinal.R
import br.edu.utfpr.trabalhofinal.data.ContaDatasource
import br.edu.utfpr.trabalhofinal.data.TipoContaEnum
import br.edu.utfpr.trabalhofinal.ui.Arguments
import java.math.BigDecimal
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.time.format.DateTimeParseException

class FormularioContaViewModel(
    savedStateHandle: SavedStateHandle
) : ViewModel() {
    private val idConta: Int = savedStateHandle
        .get<String>(Arguments.ID_CONTA)
        ?.toIntOrNull() ?: 0
    var state: FormularioContaState by mutableStateOf(FormularioContaState(idConta = idConta))
        private set
    init {
        if (state.idConta > 0) {
            carregarConta()
        }
    }
    fun carregarConta() {
        state = state.copy(
            carregando = true,
            erroAoCarregar = false
        )
        val conta = ContaDatasource.instance.findOne(state.idConta)
        state = if (conta == null) {
            state.copy(
                carregando = false,
                erroAoCarregar = true
            )
        } else {
            state.copy(
                carregando = false,
                conta = conta,
                descricao = state.descricao.copy(valor = conta.descricao),
                data = state.data.copy(valor = conta.data.toString()),
                valor = state.valor.copy(valor = conta.valor.toString()),
                paga = state.paga.copy(valor = conta.paga.toString()),
                tipo = state.tipo.copy(valor = conta.tipo.name)
            )
        }
    }
    fun onDescricaoAlterada(novaDescricao: String) {
        if (state.descricao.valor != novaDescricao) {
            state = state.copy(
                descricao = state.descricao.copy(
                    valor = novaDescricao,
                    codigoMensagemErro = validarDescricao(novaDescricao)
                )
            )
        }
    }

    fun onValorAlterado(novoValor: String) {
        if (state.valor.valor != novoValor) {
            var novoValorRep = novoValor.replace(",", ".")
            novoValorRep = novoValorRep.replace("-", "")
            novoValorRep = novoValorRep.replace(" ", "")
            state = state.copy(
                valor = state.valor.copy(
                    valor = novoValorRep,
                    codigoMensagemErro = validarValor(novoValorRep)
                )
            )
        }
    }

    fun onDataAlterada(novaData: String) {
        if (state.data.valor != novaData) {
            var novaDataRep: String = novaData.replace(",", "")
            novaDataRep = novaDataRep.replace(".", "")
            novaDataRep = novaDataRep.replace("-", "")
            novaDataRep = novaDataRep.replace(" ", "")
            state = state.copy(
                data = state.data.copy(
                    valor = novaDataRep,
                    codigoMensagemErro = validarData(novaDataRep)
                )
            )
        }
    }

    fun onStatusPagamentoAlterado(novoStatusPagamento: String) {
        if (state.paga.valor != novoStatusPagamento) {
            state = state.copy(
                paga = state.paga.copy(
                    valor = novoStatusPagamento
                )
            )
        }
    }
    fun onTipoAlterado(novoTipo: String) {
        if (state.tipo.valor != novoTipo) {
            state = state.copy(
                tipo = state.tipo.copy(
                    valor = novoTipo
                )
            )
        }
    }


    private fun validarDescricao(descricao: String): Int = if (descricao.isBlank()) {
        R.string.descricao_obrigatoria
    } else {
        0
    }

    private fun validarValor(valor: String): Int = if (valor.isBlank() || valor.toDouble() == 0.00){
        R.string.valor_obrigatoria
    } else {
        0
    }

    private fun validarData(data: String): Int {
        if (data.isBlank()) {
            return R.string.data_obrigatoria
        }

        return try {
            val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd")
            LocalDate.parse(data, formatter)
            0
        } catch (e: DateTimeParseException) {
            R.string.data_invalida
        }
    }


    fun salvarConta() {
        if (formularioValido()) {
            state = state.copy(
                salvando = true
            )
            val conta = state.conta.copy(
                descricao = state.descricao.valor,
                data = LocalDate.parse(state.data.valor),
                valor = BigDecimal(state.valor.valor),
                paga = state.paga.valor == "true",
                tipo = TipoContaEnum.valueOf(state.tipo.valor)
            )
            ContaDatasource.instance.salvar(conta)
            state = state.copy(
                salvando = false,
                contaPersistidaOuRemovida = true
            )
        }
    }
    private fun formularioValido(): Boolean {
        state = state.copy(
            descricao = state.descricao.copy(
                codigoMensagemErro = validarDescricao(state.descricao.valor)
            ),
            valor = state.valor.copy(
                codigoMensagemErro = validarValor(state.valor.valor)
            ),
            data = state.data.copy(
                codigoMensagemErro = validarData(state.data.valor)
            )


        )
        return state.formularioValido
    }
    fun mostrarDialogConfirmacao() {
        state = state.copy(mostrarDialogConfirmacao = true)
    }
    fun ocultarDialogConfirmacao() {
        state = state.copy(mostrarDialogConfirmacao = false)
    }
    fun removerConta() {
        state = state.copy(
            excluindo = true,
        )
        ContaDatasource.instance.remover(state.conta)
        state = state.copy(
            excluindo = false,
            contaPersistidaOuRemovida = true
        )
    }
    fun onMensagemExibida() {
        state = state.copy(codigoMensagem = 0)
    }
}