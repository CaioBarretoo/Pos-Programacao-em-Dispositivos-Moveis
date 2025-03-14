package br.edu.utfpr.minhaprimeiraapi

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager.PERMISSION_GRANTED
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.location.Location
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.view.View
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat.requestPermissions
import androidx.core.content.ContextCompat.checkSelfPermission
import androidx.core.content.FileProvider
import com.example.minhaprimeiraapi.databinding.ActivityNewItemBinding
import com.example.minhaprimeiraapi.model.ItemLocation
import com.example.minhaprimeiraapi.model.ItemValue
import br.edu.utfpr.minhaprimeiraapi.service.Result
import com.example.minhaprimeiraapi.service.RetrofitClient
import br.edu.utfpr.minhaprimeiraapi.service.safeApiCall
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.Marker
import com.google.android.gms.maps.model.MarkerOptions
import com.google.firebase.storage.FirebaseStorage
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.ByteArrayOutputStream
import java.io.File
import java.security.SecureRandom
import java.text.SimpleDateFormat
import java.util.Date
import java.util.UUID

class NewItemActivity : AppCompatActivity(), OnMapReadyCallback {

    private lateinit var binding: ActivityNewItemBinding

    private lateinit var mMap: GoogleMap
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private var selectedMarker: Marker? = null

    private lateinit var imageUri: Uri
    private var imageFile: File? = null

    private val cameraLauncher: ActivityResultLauncher<Intent> = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { result ->
        if (result.resultCode == Activity.RESULT_OK) {
            binding.imageUrl.setText("Imagem Obtida")
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityNewItemBinding.inflate(layoutInflater)
        setContentView(binding.root)
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        setupGoogleMap()
        setupView()
    }

    override fun onMapReady(googleMap: GoogleMap) {
        mMap = googleMap
        binding.mapContent.visibility = View.VISIBLE
        getDeviceLocation()
        mMap.setOnMapClickListener { latLng: LatLng ->
            // Limpar marcador anterior, se existir
            selectedMarker?.remove()

            selectedMarker = mMap.addMarker(
                MarkerOptions()
                    .position(latLng)
                    .draggable(true)
                    .title("Lat: ${latLng.latitude}, Long: ${latLng.longitude}")
            )
        }
    }

    private fun uploadImageToFirebase() {
        // Inicializar o Firebase Storage
        val storageRef = FirebaseStorage.getInstance().reference

        // criar uma referência para o arquivo no Firebase
        val imagesRef = storageRef.child("images/${UUID.randomUUID()}.jpg")

        // converter o Bitmap para ByteArrayOutputStream
        val baos = ByteArrayOutputStream()
        val imageBitmap = BitmapFactory.decodeFile(imageFile!!.path)
        imageBitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos)
        val data = baos.toByteArray()

        // Desabilita botões para evitar duplo click
        binding.loadImageProgress.visibility = View.VISIBLE
        binding.takePictureCta.isEnabled = false
        binding.saveCta.isEnabled = false

        imagesRef.putBytes(data)
            .addOnFailureListener {
                binding.loadImageProgress.visibility = View.GONE
                binding.takePictureCta.isEnabled = true
                binding.saveCta.isEnabled = true
                Toast.makeText(this, "Falha ao realizar o upload", Toast.LENGTH_SHORT).show()
            }
            .addOnSuccessListener {
                binding.loadImageProgress.visibility = View.GONE
                binding.takePictureCta.isEnabled = true
                binding.saveCta.isEnabled = true
                imagesRef.downloadUrl.addOnSuccessListener { uri ->
                saveData(uri.toString())
            }
        }
    }

    private fun setupGoogleMap() {
        val mapFragment = supportFragmentManager.findFragmentById(com.example.minhaprimeiraapi.R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)
    }

    private fun getDeviceLocation() {
        // Verificar permissão de Localização
        if (checkSelfPermission(
                this,
                android.Manifest.permission.ACCESS_FINE_LOCATION
        ) == PERMISSION_GRANTED) {
            // Permissão já concedida
            loadCurrentLocation()
        } else {
            // Usuário ainda não tem permissão, vai pedir a permissão de Localização
            requestPermissions(
                this,
                arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION),
                br.edu.utfpr.minhaprimeiraapi.NewItemActivity.Companion.LOCATION_PERMISSION_REQUEST_CODE
            )
        }
    }

    @SuppressLint("MissingPermission")
    private fun loadCurrentLocation() {
        mMap.isMyLocationEnabled = true
        fusedLocationClient.lastLocation.addOnSuccessListener { location: Location ->
            val currentLocation = LatLng(location.latitude, location.longitude)
            mMap.moveCamera(CameraUpdateFactory.newLatLngZoom(currentLocation, 15f))
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == br.edu.utfpr.minhaprimeiraapi.NewItemActivity.Companion.LOCATION_PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PERMISSION_GRANTED) {
                loadCurrentLocation()
            } else {
                showToast("Permissão de Localização negada")
            }
        } else if(requestCode == br.edu.utfpr.minhaprimeiraapi.NewItemActivity.Companion.CAMERA_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PERMISSION_GRANTED) {
                openCamera()
            } else {
                showToast("Permissão de Câmera Negada")
            }
        }
    }

    private fun showToast(message: String) {
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
    }

    private fun setupView() {
        setSupportActionBar(binding.toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.setDisplayShowHomeEnabled(true)
        binding.toolbar.setNavigationOnClickListener {
            finish()
        }
        binding.saveCta.setOnClickListener {
            save()
        }
        binding.takePictureCta.setOnClickListener {
            takePicture()
        }
    }

    private fun takePicture() {
        if (checkSelfPermission(this, android.Manifest.permission.CAMERA) == PERMISSION_GRANTED) {
            openCamera()
        } else {
            requestCameraPermission()
        }
    }

    private fun openCamera() {
        val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        imageUri = createImageUri()
        intent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri)
        cameraLauncher.launch(intent)
    }

    private fun createImageUri(): Uri {
        val timeStamp: String = SimpleDateFormat("yyyyMMdd_HHmmss").format(Date())
        val imageFileName = "JPEG_${timeStamp}_"

        // Obtém o diretório de armazenamento externo para imagens
        val storageDir: File? = getExternalFilesDir(Environment.DIRECTORY_PICTURES)

        // Cria um arquivo de imagem
        imageFile = File.createTempFile(
            imageFileName,  /* prefix */
            ".jpg",         /* suffix */
            storageDir      /* directory */
        )

        // Retorna o URI para o arquivo
        return FileProvider.getUriForFile(
            this,  // Contexto
            "com.example.minhaprimeiraapi.fileprovider", // Autoridade
            imageFile!! // O arquivo
        )
    }

    private fun requestCameraPermission() {
        requestPermissions(
            this,
            arrayOf(android.Manifest.permission.CAMERA),
            br.edu.utfpr.minhaprimeiraapi.NewItemActivity.Companion.CAMERA_REQUEST_CODE
        )
    }

    private fun save() {
        if (!validateForm()) return

        uploadImageToFirebase()
    }

    private fun saveData(imageUrl: String) {
        val name = binding.name.text.toString()
        val itemPosition = selectedMarker?.position?.let {
            ItemLocation(
                name = name,
                it.latitude,
                it.longitude
            )
        }
        CoroutineScope(Dispatchers.IO).launch {
            val id = SecureRandom().nextInt().toString()
            val itemValue = ItemValue(
                id,
                name,
                binding.surname.text.toString(),
                binding.profession.text.toString(),
                imageUrl,
                binding.age.text.toString().toInt(),
                location = itemPosition,
                Date()
            )
            val result = br.edu.utfpr.minhaprimeiraapi.service.safeApiCall {
                RetrofitClient.apiService.addItem(itemValue)
            }
            withContext(Dispatchers.Main) {
                when (result) {
                    is br.edu.utfpr.minhaprimeiraapi.service.Result.Error -> {
                        Toast.makeText(
                            this@NewItemActivity,
                            com.example.minhaprimeiraapi.R.string.error_create,
                            Toast.LENGTH_SHORT
                        ).show()
                    }
                    is br.edu.utfpr.minhaprimeiraapi.service.Result.Success -> {
                        Toast.makeText(
                            this@NewItemActivity,
                            getString(com.example.minhaprimeiraapi.R.string.success_create, result.data.id),
                            Toast.LENGTH_SHORT
                        ).show()
                        finish()
                    }
                }
            }
        }
    }

    private fun validateForm(): Boolean {
        if (binding.name.text.toString().isBlank()) {
            Toast.makeText(this, getString(com.example.minhaprimeiraapi.R.string.error_validate_form, "Name"), Toast.LENGTH_SHORT).show()
            return false
        }
        if (binding.surname.text.toString().isBlank()) {
            Toast.makeText(this, getString(com.example.minhaprimeiraapi.R.string.error_validate_form, "Surname"), Toast.LENGTH_SHORT).show()
            return false
        }
        if (binding.age.text.toString().isBlank()) {
            Toast.makeText(this, getString(com.example.minhaprimeiraapi.R.string.error_validate_form, "Age"), Toast.LENGTH_SHORT).show()
            return false
        }
        if (imageFile == null) {
            Toast.makeText(this, getString(com.example.minhaprimeiraapi.R.string.error_validate_take_picture), Toast.LENGTH_SHORT).show()
            return false
        }
        if (binding.profession.text.toString().isBlank()) {
            Toast.makeText(this, getString(com.example.minhaprimeiraapi.R.string.error_validate_form, "Profession"), Toast.LENGTH_SHORT).show()
            return false
        }
        return true
    }

    companion object {

        private const val LOCATION_PERMISSION_REQUEST_CODE = 100
        private const val CAMERA_REQUEST_CODE = 101

        fun newIntent(context: Context) =
            Intent(context, br.edu.utfpr.minhaprimeiraapi.NewItemActivity::class.java)
    }
}