package br.edu.utfpr.affirmation_pos2024.adapter

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import br.edu.utfpr.affirmation_pos2024.R
import br.edu.utfpr.affirmation_pos2024.model.Affirmation

class ItemAdapter(val context: Context, val dataset: List<Affirmation>): RecyclerView.Adapter<ItemAdapter.ItemViewHolder>(){
    class ItemViewHolder(val view: View): RecyclerView.ViewHolder(view){
        val textView = view.findViewById<TextView>(R.id.item_title)
        val imageView = view.findViewById<ImageView>(R.id.item_image)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ItemViewHolder {
        val adapterLayout = LayoutInflater.from(parent.context).inflate(R.layout.list_item, parent, false)
        return ItemViewHolder(adapterLayout)
    }

    override fun getItemCount(): Int {
        return dataset.size
    }

    override fun onBindViewHolder(holder: ItemViewHolder, position: Int) {
        val item = dataset[position]
        holder.textView.text = context.resources.getString(item.stringResourceId)
        holder.imageView.setImageResource(item.imageResourceId)
    }
}