package br.edu.utfpr.bankingcontrol.adapter

import android.annotation.SuppressLint
import android.content.Context
import android.database.Cursor
import android.util.SparseBooleanArray
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.ImageView
import android.widget.TextView
import br.edu.utfpr.bankingcontrol.R
import br.edu.utfpr.bankingcontrol.database.DataBaseHandler.Companion.ID
import br.edu.utfpr.bankingcontrol.database.DataBaseHandler.Companion.DETAIL
import br.edu.utfpr.bankingcontrol.database.DataBaseHandler.Companion.VALUE
import br.edu.utfpr.bankingcontrol.database.DataBaseHandler.Companion.TRANSACTION_DATE

import br.edu.utfpr.bankingcontrol.entity.Register
import java.text.DecimalFormat


class ElementListAdapter (val context: Context, var cursor: Cursor): BaseAdapter() {
    private var mSelectedItemsIds = SparseBooleanArray()

    override fun getCount(): Int {
        return cursor.count
    }

    override fun getItem(position: Int): Any {
        cursor.moveToPosition(position)

        return Register(
            cursor.getInt(ID),
            cursor.getString(DETAIL),
            cursor.getDouble(VALUE),
            cursor.getString(TRANSACTION_DATE)
        )
    }

    override fun getItemId(position: Int): Long {
        cursor.moveToPosition(position)

        return cursor.getInt(ID).toLong()
    }

    @SuppressLint("ViewHolder")
    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val inflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val v = inflater.inflate( R.layout.activity_element_list, null )

        val tvDetailElementList = v.findViewById<TextView>(R.id.tvDetail)
        val tvValueElementList = v.findViewById<TextView>(R.id.tvValue)
        val tvDateElementList = v.findViewById<TextView>(R.id.tvDate)
        val ivTypeElementList = v.findViewById<ImageView>(R.id.ivType)

        cursor.moveToPosition(position)

        val value = cursor.getDouble(VALUE)
        if(value < 0){
            ivTypeElementList.setImageResource(R.drawable.baseline_horizontal_rule_72)
        }
        val decimalFormat = DecimalFormat("0.00")

        tvDetailElementList.setText(cursor.getString(DETAIL))
        tvValueElementList.text = decimalFormat.format(value)
        tvDateElementList.setText(cursor.getString(TRANSACTION_DATE))


        return v
    }

    fun getIdDb(position: Int): Int{
        val _id : Int
        cursor.moveToPosition(position)
        _id = cursor.getString(ID).toInt()
        return _id
    }

    fun toggleSelection(position: Int) {
        selectView(position, !mSelectedItemsIds.get(position))
        notifyDataSetChanged()
    }

    fun removeSelection() {
        mSelectedItemsIds = SparseBooleanArray()
        notifyDataSetChanged()
    }

    fun selectView(position: Int, value: Boolean) {
        when(value){
            true -> {
                mSelectedItemsIds.put(position, value)
            }
            false ->{
                mSelectedItemsIds.delete(position)
            }
        }
    }
    fun getSelectedIds(): SparseBooleanArray{
        return mSelectedItemsIds
    }


    fun changeCursor(newCursor: Cursor) {
        if (cursor != null && !cursor.isClosed) {
            cursor.close()
        }

        cursor = newCursor
        notifyDataSetChanged()
    }

}