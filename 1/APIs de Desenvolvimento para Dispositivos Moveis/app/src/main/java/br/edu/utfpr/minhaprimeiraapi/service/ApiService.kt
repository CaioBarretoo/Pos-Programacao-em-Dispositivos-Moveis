package br.edu.utfpr.minhaprimeiraapi.service

import br.edu.utfpr.minhaprimeiraapi.model.Item
import retrofit2.http.GET

interface ApiService {
    @GET("/items")
    suspend fun getItems(): List<Item>
}