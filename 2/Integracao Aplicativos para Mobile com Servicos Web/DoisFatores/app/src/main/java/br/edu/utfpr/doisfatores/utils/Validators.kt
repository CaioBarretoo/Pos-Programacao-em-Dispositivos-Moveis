package br.edu.utfpr.doisfatores.utils

import android.util.Patterns
import com.google.i18n.phonenumbers.PhoneNumberUtil

class Validators {

    fun isValidEmail(email: String): Boolean {

        if (!Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            return false
        }
        return true // E-mail é válido
    }

    fun isValidPhoneNumberLib(fullPhoneNumber: String, countryIsoCode: String): Boolean {
        val phoneUtil = PhoneNumberUtil.getInstance()
        try {
            val numberProto = phoneUtil.parse(fullPhoneNumber, countryIsoCode)
            return phoneUtil.isValidNumber(numberProto) && phoneUtil.isPossibleNumber(numberProto)
        } catch (e: Exception) {
            e.printStackTrace()
            return false
        }
    }
}