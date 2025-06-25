package br.edu.utfpr.cadastrocategoria.model

import kotlinx.serialization.Serializable

@Serializable
data class Categoria(
    val id: Int,
    val nome: String
)