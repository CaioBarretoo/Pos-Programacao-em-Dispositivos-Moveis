package br.edu.utfpr.minhaprimeiraapi

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import br.edu.utfpr.minhaprimeiraapi.databinding.ActivityMainBinding
import br.edu.utfpr.minhaprimeiraapi.service.RetrofitClient
import br.edu.utfpr.minhaprimeiraapi.service.safeApiCall
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import br.edu.utfpr.minhaprimeiraapi.service.Result.Error
import br.edu.utfpr.minhaprimeiraapi.service.Result.Success

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setupView()
    }

    override fun onResume() {
        super.onResume()
        fetchItems()
    }

    private fun fetchItems(){
        // Alterando execução para IO thread
        CoroutineScope(Dispatchers.IO).launch{
            val result = safeApiCall {RetrofitClient.apiService.getItems()}

            // Alterando execução para Main thread
            withContext(Dispatchers.Main){
                when(result){
                    is Error -> {}
                    is Success -> {}
                }
            }
        }
    }

    private fun setupView(){
        binding.recyclerView.layoutManager = LinearLayoutManager(this)
    }
}