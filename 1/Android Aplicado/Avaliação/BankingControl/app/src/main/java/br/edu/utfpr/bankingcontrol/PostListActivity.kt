package br.edu.utfpr.bankingcontrol

import android.content.Intent
import android.os.Bundle
import android.util.SparseBooleanArray
import android.view.Menu
import android.view.MenuItem

import android.widget.AbsListView
import android.widget.ListView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import br.edu.utfpr.bankingcontrol.adapter.ElementListAdapter
import br.edu.utfpr.bankingcontrol.database.DataBaseHandler
import br.edu.utfpr.bankingcontrol.databinding.ActivityPostListBinding
import java.text.DecimalFormat

class PostListActivity : AppCompatActivity() {

    private lateinit var binding: ActivityPostListBinding
    private lateinit var banco : DataBaseHandler

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityPostListBinding.inflate(layoutInflater)
        setContentView(binding.root)


        binding.btInclude.setOnClickListener{
            val intent = Intent( this, PostActivity::class.java)
            startActivity(intent)
        }


        banco = DataBaseHandler( this)


    }

    override fun onStart() {
        super.onStart()

        val decimalFormat = DecimalFormat("0.00")
        binding.tvBalanceValue2.text = decimalFormat.format(banco.getBalance("VALUE")).toString()

        val registros = banco.listCursor()
        val adapter = ElementListAdapter(this, registros)
        binding.lvRegistros.adapter = adapter

        binding.lvRegistros.choiceMode = ListView.CHOICE_MODE_MULTIPLE_MODAL
        binding.lvRegistros.setMultiChoiceModeListener(object : AbsListView.MultiChoiceModeListener {
            override fun onItemCheckedStateChanged(
                actionMode: android.view.ActionMode?,
                i: Int,
                l: Long,
                b: Boolean
            ) {
                adapter.toggleSelection(i)
            }

            override fun onCreateActionMode(actionMode: android.view.ActionMode?, menu: Menu?): Boolean {
                actionMode?.menuInflater?.inflate(R.menu.menu_delete, menu)
                return true
            }

            override fun onPrepareActionMode(actionMode: android.view.ActionMode?, menu: Menu?): Boolean {
                return false
            }

            override fun onActionItemClicked(actionMode: android.view.ActionMode?, menuItem: MenuItem?): Boolean {
                if(menuItem?.getItemId() == R.id.mDelete){
                    var post_id: Int?
                    var selected : SparseBooleanArray  = adapter.getSelectedIds()
                    for (i in (selected.size() - 1) downTo 0) {
                        if(selected.valueAt(i)){
                            post_id = null
                            post_id = adapter.getIdDb(selected.keyAt(i))
                            if(post_id != null){
                               banco.delete(post_id)
                            }
                        }
                    }
                    updateView(selected.size())
                    adapter.notifyDataSetChanged()
                    adapter.removeSelection()
                    selected.clear()
                    actionMode?.finish()
                }
                return false
            }

            override fun onDestroyActionMode(actionMode: android.view.ActionMode?) {
                adapter.removeSelection()
            }


        })
    }

    fun updateView(quantitySelect: Int){
        val decimalFormat = DecimalFormat("0.00")
        binding.tvBalanceValue2.text = decimalFormat.format(banco.getBalance("VALUE")).toString()

        val newCursor = banco.listCursor()

        (binding.lvRegistros.adapter as ElementListAdapter).changeCursor(newCursor)
        when(quantitySelect){
            1-> Toast.makeText(this, "Lançamento excluído com sucesso!", Toast.LENGTH_SHORT).show()
            else-> Toast.makeText(this, "Lançamentos excluídos com sucesso!", Toast.LENGTH_SHORT).show()

        }



        return
    }


}