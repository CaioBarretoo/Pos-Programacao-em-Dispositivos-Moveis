package caio.barreto.buscacep.ui.form

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import caio.barreto.buscacep.data.model.Cep
import caio.barreto.buscacep.data.repository.CepRepository
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlin.random.Random

class FormBuscaCepViewModel() : ViewModel() {
    private val tag: String = "FormBuscaCepViewModel"
    private val cepRepository: CepRepository = CepRepository()

    var uiState: FormBuscaCepUiState by mutableStateOf(FormBuscaCepUiState())
        private set

    fun onCepChanged(valor: String) {
        val newCep = valor.replace("\\D".toRegex(), "")
        if(newCep.length <= 8) {
            uiState = uiState.copy(
                formState = uiState.formState.copy(
                    cepForm = FormField(
                        value = newCep,
                    )
                )
            )
        }
    }

    fun onBuscarCepClicked() {
        val cep = uiState.formState.cepForm.value
        if (cep.length <= 8) {
            val mensagemValidacao = validateCep(cep)
            val podeBuscar = mensagemValidacao == null && cep.length == 8
            if (podeBuscar) {
                buscarCep(cep)
            } else {
                uiState = uiState.copy(
                    formState = uiState.formState.copy(
                        cep = FormField(
                            value = cep,
                            errorMessage = mensagemValidacao
                        )
                    )
                )
            }
        }
    }

    private fun validateCep(cep: String): String? = if (cep.isBlank()) {
        "O CEP é obrigatório"
    } else if (cep.length != 8) {
        "Informe um CEP válido"
    } else {
        null
    }

    private fun buscarCep(cep: String) {
        if (uiState.formState.buscandoCep) return

        uiState = uiState.copy(
            formState = uiState.formState.copy(
                buscandoCep = true,
                cepForm = FormField(
                    value = cep,
                    errorMessage = null
                ),
                cep = FormField(""),
                logradouro = FormField(""),
                bairro = FormField(""),
                cidade = FormField(""),
                uf = FormField("")
            )
        )
        viewModelScope.launch {
            delay(1500)
            uiState = try {
                val hasError = false //Random.nextBoolean()
                if (hasError) {
                    throw Exception("Não foi possível consultar o CEP." +
                            " Aguarde um momento e tente novamente.")
                }
                val cepRetornado: Cep = cepRepository.buscarCep(cep)
                if(cepRetornado.cidade.isBlank()) {
                    throw Exception("CEP não encontrado, por gentileza verifique o CEP informado.")
                }
                uiState.copy(
                    formState = uiState.formState.copy(
                        cep = FormField(value = cepRetornado.cep),
                        logradouro = FormField(cepRetornado.logradouro),
                        bairro = FormField(cepRetornado.bairro),
                        cidade = FormField(cepRetornado.cidade),
                        uf = FormField(cepRetornado.uf),

                        buscandoCep = false
                    )
                )
            } catch (ex: Exception) {
                val message = ex.message ?: "Erro desconhecido"
                val exceptionMessage = message.substringAfterLast(": ")
                println("[$tag]: Erro ao consultar o CEP $cep")
                ex.printStackTrace()
                uiState.copy(
                    formState = uiState.formState.copy(
                        buscandoCep = false,
                        cepForm = uiState.formState.cepForm.copy(
                            errorMessage = exceptionMessage
                        )
                    )
                )
            }
        }
    }
}