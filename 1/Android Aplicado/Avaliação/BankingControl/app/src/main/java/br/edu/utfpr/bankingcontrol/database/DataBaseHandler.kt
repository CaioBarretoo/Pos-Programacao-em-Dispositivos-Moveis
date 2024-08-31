package br.edu.utfpr.bankingcontrol.database

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import br.edu.utfpr.bankingcontrol.entity.Register

class DataBaseHandler (context: Context): SQLiteOpenHelper (context, DATABASE_NAME, null, DATABASE_VERSION) {

    override fun onCreate(db: SQLiteDatabase?) {
        db?.execSQL( "CREATE TABLE IF NOT EXISTS $TABLE_NAME ( _id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                " detail TEXT, value REAL, transaction_date TEXT)")
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        db?.execSQL( "DROP TABLE IF EXISTS $TABLE_NAME" )
        onCreate(db)
    }

    companion object {
        private const val DATABASE_NAME = "dbfile.sqlite"
        private const val DATABASE_VERSION = 1
        private const val TABLE_NAME = "movement"
        const val ID = 0
        const val DETAIL = 1
        const val VALUE = 2
        const val TRANSACTION_DATE = 3
    }

    fun insert(register: Register) {
        val db = this.writableDatabase

        val registro = ContentValues()
        registro.put("detail", register.detail)
        registro.put("value", register.value)
        registro.put("transaction_date",register.transaction_date)

        db.insert(TABLE_NAME, null, registro)
    }


    fun delete(id: Int ) {
        val db = this.writableDatabase

        db.delete(TABLE_NAME, "_id=${id}", null )
    }


    fun listCursor(): Cursor {
        val db = this.writableDatabase

        val registro = db.query(TABLE_NAME,
            null,
            null,
            null,
            null,
            null,
            "transaction_date"
        )

        return registro
    }

    fun getBalance(columnName: String): Double {
        val db = this.writableDatabase
        val query = "SELECT SUM($columnName) FROM $TABLE_NAME"
        val cursor = db.rawQuery(query, null)

        var sumValue = 0.00
        if (cursor.moveToFirst()) {
            sumValue = cursor.getDouble(0)
        }
        cursor.close()

        return sumValue
    }

}