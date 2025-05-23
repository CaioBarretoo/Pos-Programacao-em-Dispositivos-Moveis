package caio.barreto.buscacep.ui.form

data class FormField(
    val value: String = "",
    val errorMessage: String? = null
)

data class FormState(
    val cepForm: FormField = FormField(),
    val cep: FormField = FormField(),
    val logradouro: FormField = FormField(),
    val bairro: FormField = FormField(),
    val cidade: FormField = FormField(),
    val uf: FormField = FormField(),
    val buscandoCep: Boolean = false
) {
    val isValid get(): Boolean = cep.errorMessage == null &&
            logradouro.errorMessage == null &&
            bairro.errorMessage == null &&
            cidade.errorMessage == null &&
            uf.errorMessage == null
}

data class FormBuscaCepUiState(
    val carregando: Boolean = false,
    val ocorreuErroAoCarregar: Boolean = false,
    val formState: FormState = FormState(),
) {
    val sucessoAoCarregar get(): Boolean = !carregando && !ocorreuErroAoCarregar
}