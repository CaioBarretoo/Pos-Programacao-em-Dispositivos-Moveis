package com.example.consultacep_pos2025.model

data class EnderecoViaCEP (
    val cep:String,
    val logradouro:String,
    val complemento:String,
    val bairro:String,
    val localidade:String,
    val uf:String,
    val unidade:String,
    val ibge:String,
    val gia:String
)