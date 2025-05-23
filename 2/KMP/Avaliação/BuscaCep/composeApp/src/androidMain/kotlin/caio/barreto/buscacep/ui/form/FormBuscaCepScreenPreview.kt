package caio.barreto.buscacep.ui.form

import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.tooling.preview.Preview

@Preview(showBackground = true)
@Composable
private fun FormTextFieldPreview(){
    MaterialTheme {
        FormEditTextField(
            value = "87302150",
            onValueChanged = {},
            label = "Digite o CEP",
        )
    }
}


@Preview(showBackground = true)
@Composable
private fun FormPessoaScreenPreview(){
    MaterialTheme {
        FormPessoaScreen()
    }
}
