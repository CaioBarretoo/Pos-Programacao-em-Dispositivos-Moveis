package br.edu.utfpr.cadastrocategoria.api

import br.edu.utfpr.cadastrocategoria.model.Categoria
import com.jakewharton.retrofit2.converter.kotlinx.serialization.asConverterFactory
import kotlinx.serialization.json.Json
import okhttp3.MediaType.Companion.toMediaType
import retrofit2.Retrofit
import retrofit2.http.Body
import retrofit2.http.DELETE
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.Path

private const val BASE_URL = "http://10.0.2.2:8080"

private val retrofit = Retrofit.Builder()
    .addConverterFactory(Json.asConverterFactory("application/json".toMediaType()))
    .baseUrl(BASE_URL)
    .build()

interface CategoriaService {

    @GET("categorias")
    suspend fun findAll() : List<Categoria>

    @GET("categorias/{id}")
    suspend fun findById(@Path("id") id: Int) : Categoria

    @DELETE("categorias/{id}")
    suspend fun delete(@Path("id") id: Int)

    @POST("categorias")
    suspend fun save(@Body categoria : Categoria) : Categoria

}

object ApiCategoria {
    val retrofitService : CategoriaService by lazy {
        retrofit.create(CategoriaService::class.java)
    }
}