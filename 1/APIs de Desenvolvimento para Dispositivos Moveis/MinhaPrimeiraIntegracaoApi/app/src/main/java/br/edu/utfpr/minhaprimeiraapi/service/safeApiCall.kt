package br.edu.utfpr.minhaprimeiraapi.service

import retrofit2.HttpException

sealed class Result<out T> {
    data class Success<out T>(val data: T) : br.edu.utfpr.minhaprimeiraapi.service.Result<T>()
    data class Error(val code: Int, val message: String) : br.edu.utfpr.minhaprimeiraapi.service.Result<Nothing>()
}

suspend fun <T> safeApiCall(apiCall: suspend () -> T): br.edu.utfpr.minhaprimeiraapi.service.Result<T> {
    return try {
        br.edu.utfpr.minhaprimeiraapi.service.Result.Success(apiCall())
    } catch (e: Exception) {
        when (e) {
            is HttpException -> {
                br.edu.utfpr.minhaprimeiraapi.service.Result.Error(e.code(), e.message())
            }
            else -> {
                br.edu.utfpr.minhaprimeiraapi.service.Result.Error(-1, "Unknown error")
            }
        }
    }
}