package caio.barreto.buscacep.ui.form

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.OutlinedTextField
import androidx.compose.material.Text
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ElevatedButton
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardCapitalization
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.lifecycle.viewmodel.initializer
import androidx.lifecycle.viewmodel.viewModelFactory
import caio.barreto.buscacep.form.visualtransformation.CepVisualTransformation
import caio.barreto.buscacep.ui.composables.AppBarDefault


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FormPessoaScreen(
    modifier: Modifier = Modifier,
) {
    val viewModel: FormBuscaCepViewModel = viewModel(
        factory = viewModelFactory {
            initializer {
                FormBuscaCepViewModel()
            }
        }
    )
    Scaffold(
        modifier = modifier.fillMaxSize(),
        topBar = {
            FormBuscaCepTopBar()
        }
    ) { innerPadding ->

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
        ) {
            FormResponse(
                modifier = modifier,
                formState = viewModel.uiState.formState,
                onCepChanged = viewModel::onCepChanged,
                onButtonClick = viewModel::onBuscarCepClicked
            )
        }
    }
}



@Composable
fun FormBuscaCepTopBar(
    modifier: Modifier = Modifier,
) {
    AppBarDefault(
        modifier = modifier,
        titulo = "Busca CEP",
    )
}

@Composable
fun FormResponse(
    modifier: Modifier = Modifier,
    onCepChanged: (String) -> Unit = {},
    onButtonClick: () -> Unit = {},
    formState: FormState
) {
   Column(
       modifier = modifier
           .fillMaxWidth()
           .padding(16.dp)
           .verticalScroll(rememberScrollState())
   ) {

       FormEditTextField(
           modifier = modifier.fillMaxWidth(),
           label = "Digite o CEP",
           onValueChanged = onCepChanged,
           keyboardType = KeyboardType.Number,
           visualTransformation = CepVisualTransformation(),
           enabled = !formState.buscandoCep,
           errorMessage = formState.cepForm.errorMessage,
           value = formState.cepForm.value,
       )

       Spacer(modifier = Modifier.height(8.dp))

       ElevatedButton(
           modifier = modifier.fillMaxWidth(),
           onClick = onButtonClick,
           enabled = !formState.buscandoCep && formState.cepForm.value.length == 8,
       ){
           if (formState.buscandoCep) {
               CircularProgressIndicator(
                   modifier = Modifier
                       .fillMaxHeight()
               )
           } else {
               Text(
                   text = "Buscar",
                   color = MaterialTheme.colorScheme.primary,
               )
           }
       }

       Text(
           modifier = modifier,
           text = "CEP: ${formState.cep.value}",
       )
       Text(
           modifier = modifier,
           text = "Logradouro: ${formState.logradouro.value}",
       )
       Text(
           modifier = modifier,
           text = "Bairro: ${formState.bairro.value}",
       )
       Text(
           modifier = modifier,
           text = "Localidade: ${formState.cidade.value}",
       )
       Text(
           modifier = modifier,
           text = "UF: ${formState.uf.value}",
       )
   }
}

@Composable
fun FormEditTextField(
    modifier: Modifier = Modifier,
    label: String,
    value: String,
    onValueChanged: (String) -> Unit,
    enabled: Boolean = true,
    errorMessage: String? = null,
    keyboardCapitalization: KeyboardCapitalization = KeyboardCapitalization.Sentences,
    keyboardImeAction: ImeAction = ImeAction.Done,
    keyboardType: KeyboardType = KeyboardType.Text,
    visualTransformation: VisualTransformation = VisualTransformation.None,
    trailingIcon: @Composable (() -> Unit)? = null,
) {
    OutlinedTextField(
        value = value,
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 8.dp),
        onValueChange = onValueChanged,
        label = { Text(label) },
        maxLines = 1,
        enabled = enabled,
        isError = errorMessage?.isNotEmpty() == true,
        trailingIcon = trailingIcon,
        keyboardOptions = KeyboardOptions(
            capitalization = keyboardCapitalization,
            imeAction = keyboardImeAction,
            keyboardType = keyboardType
        ),
        visualTransformation = visualTransformation,
        )
    errorMessage?.let {
        Text(
            text = errorMessage,
            color = MaterialTheme.colorScheme.error,
            style = MaterialTheme.typography.labelSmall,
            modifier = Modifier.padding(horizontal = 16.dp)
        )
    }
}