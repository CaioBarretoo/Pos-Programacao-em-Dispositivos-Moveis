package com.example.consultacep_pos2025.api

import com.example.consultacep_pos2025.model.EnderecoViaCEP
import retrofit2.http.GET
import retrofit2.http.Path

interface ViaCEPService {

    @GET("{cep}/json/")
    suspend fun buscarCEP( @Path("cep") cep : String ) : EnderecoViaCEP

}