package caio.barreto.buscacep

import androidx.compose.material.MaterialTheme
import androidx.compose.runtime.Composable
import caio.barreto.buscacep.ui.form.FormPessoaScreen
import org.jetbrains.compose.ui.tooling.preview.Preview

@Composable
@Preview
fun App() {
    MaterialTheme {
        FormPessoaScreen()
    }
}
