package br.edu.utfpr.bankingcontrol

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import br.edu.utfpr.bankingcontrol.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.btEnter.setOnClickListener {
            onClickListenerBtEnter()
        }

        binding.pbBar.visibility = View.GONE

    }

    private fun onClickListenerBtEnter() {
        binding.pbBar.visibility = View.VISIBLE
        binding.btEnter.visibility = View.GONE

        Handler(Looper.getMainLooper()).postDelayed({
            val intent = Intent(this, PostListActivity::class.java)
            startActivity(intent)
            finish()
        }, 500)

        @Suppress("DEPRECATION")
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out)
    }

}