package br.edu.utfpr.appcontatos.data

import java.time.LocalDate
import java.time.LocalDateTime

data class Contact(
    val id: Int = 0,
    val firstName: String = "",
    val lastName: String = "",
    val phoneNumber: String = "",
    val email: String = "",
    val isFavorite: Boolean = false,
    val createdAt: LocalDateTime = LocalDateTime.now(),
    var birthDate: LocalDate = LocalDate.now(),
    val type: ContactTypeEnum = ContactTypeEnum.PERSONAL

){
    val fullName get(): String = "$firstName $lastName".trim()
}

fun List<Contact>.groupByInitial(): Map<String, List<Contact>> = sortedBy { it.fullName }
    .groupBy {it.fullName.take(1)}
