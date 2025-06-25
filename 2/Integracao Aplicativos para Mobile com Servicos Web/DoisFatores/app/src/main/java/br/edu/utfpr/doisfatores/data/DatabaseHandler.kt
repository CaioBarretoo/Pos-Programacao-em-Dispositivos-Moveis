package br.edu.utfpr.doisfatores.data

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import br.edu.utfpr.doisfatores.entity.User

class DatabaseHandler (context : Context) : SQLiteOpenHelper ( context, DATABASE_NAME, null, DATABASE_VERSION ) {

    override fun onCreate(db: SQLiteDatabase?) {
        db?.execSQL("CREATE TABLE IF NOT EXISTS ${TABLE_NAME} ( _id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                " email TEXT, phoneNumber TEXT)")
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        db?.execSQL("DROP TABLE IF EXISTS ${TABLE_NAME}")
        onCreate(db)
    }

    companion object {
        private const val DATABASE_NAME = "dbfile.sqlite"
        private const val DATABASE_VERSION = 1
        private const val TABLE_NAME = "User"
        public const val ID = 0
        public const val EMAIL = 1
        public const val PHONENUMBER = 2
    }

    fun insert(User: User) {
        val db = this.writableDatabase

        val registro = ContentValues()
        registro.put("email", User.email)
        registro.put("phoneNumber", User.phoneNumber)

        db.insert( TABLE_NAME, null, registro )
    }

    fun update(User: User) {
        val db = this.writableDatabase

        val registro = ContentValues()
        registro.put("email", User.email)
        registro.put("phoneNumber", User.phoneNumber)

        db.update( TABLE_NAME, registro, "_id=${User._id}", null )
    }

    fun delete( id : Int ) {
        val db = this.writableDatabase

        db.delete( TABLE_NAME, "_id=${id}", null )
    }

    fun find(email : String) : User? {
        val db = this.writableDatabase

        val selection = "email = ?"
        val selectionArgs = arrayOf(email)

        val registro : Cursor = db.query( TABLE_NAME,
            null,
            selection,
            selectionArgs,
            null,
            null,
            null
        )

        if (registro.moveToNext()) {
            val User = User(
                registro.getInt(ID),
                email,
                registro.getString(PHONENUMBER),

            )
            return User
        } else {
            return null
        }
    }

    fun list() : MutableList<User> {
        val db = this.writableDatabase

        val registro = db.query( TABLE_NAME,
            null,
            null,
            null,
            null,
            null,
            null
        )

        var registros = mutableListOf<User>()

        while (registro.moveToNext()) {

            val User = User(
                registro.getInt( ID ),
                registro.getString(EMAIL),
                registro.getString(PHONENUMBER),
            )
            registros.add(User)
        }

        return registros

    }

    fun listCursor() : Cursor {
        val db = this.writableDatabase

        val registro = db.query( TABLE_NAME,
            null,
            null,
            null,
            null,
            null,
            null
        )

        return registro
    }

}