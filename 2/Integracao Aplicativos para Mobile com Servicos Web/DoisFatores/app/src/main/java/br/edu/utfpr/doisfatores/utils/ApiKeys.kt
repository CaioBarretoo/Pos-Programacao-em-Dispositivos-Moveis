package br.edu.utfpr.doisfatores.utils

import android.content.Context
import android.util.Log
import br.edu.utfpr.doisfatores.R
import java.io.IOException
import java.util.Properties

object ApiKeys {

    private val properties = Properties()
    private const val TAG = "SecretLoader"

    fun loadSecrets(context: Context) {
        try {
            context.resources.openRawResource(R.raw.secrets).use { inputStream ->
                properties.load(inputStream)
            }
            Log.d(TAG, "Secrets loaded successfully.")
        } catch (e: IOException) {
            Log.e(TAG, "Error loading secrets: ${e.message}", e)
        }
    }

    fun getTwilioAccountSid(): String {
        return properties.getProperty("TWILIO_ACCOUNT_SID", "DEFAULT_SID")
    }

    fun getTwilioAuthToken(): String {
        return properties.getProperty("TWILIO_AUTH_TOKEN", "DEFAULT_AUTH_TOKEN")
    }

    fun getTwilioVerifyServiceSid(): String {
        return properties.getProperty("TWILIO_VERIFY_SERVICE_SID", "DEFAULT_VERIFY_SID")
    }
}