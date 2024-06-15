package br.edu.utfpr.calculaimc;

import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import java.text.DecimalFormat;

public class MainActivity extends AppCompatActivity {

    private EditText  etPeso;
    private EditText  etAltura;
    private TextView  tvResultado;
    private Button    btCalcular;
    private Button    btLimpar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        etPeso = findViewById( R.id.etPeso );
        etAltura = findViewById( R.id.etAltura );
        tvResultado = findViewById( R.id.tvResultado );
        btCalcular = findViewById( R.id.btCalcular );
        btLimpar = findViewById( R.id.btLimpar );

        btCalcular.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                btCalcularOnClick();
            }
        });

        btLimpar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                btLimparOnClick();
            }
        });

        etAltura.setOnEditorActionListener( new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction( TextView textView , int i , KeyEvent keyEvent ) {
                btCalcularOnClick();
                return false;
            }
        });
    }

    private void btCalcularOnClick() {

        if ( etPeso.getText().toString().isEmpty() ){
            etPeso.setError("Campo Peso deve ser preenchido.");
            etPeso.requestFocus();
            return;
        }
        if ( etAltura.getText().toString().isEmpty() ){
            etAltura.setError("Campo Altura deve ser preenchido.");
            etAltura.requestFocus();
            return;
        }

        double peso = Double.parseDouble(etPeso.getText().toString());
        double altura = Double.parseDouble(etAltura.getText().toString());

        double resultado = peso / Math.pow( altura, 2 );

        DecimalFormat df = new DecimalFormat( "0.00" );
        tvResultado.setText( df.format( resultado) );

        if( resultado < 18.5 ){
            tvResultado.setTextColor(Color.BLUE);
        }else if( resultado > 18.5 && resultado < 24.9 ){
            tvResultado.setTextColor(Color.GREEN);
        }else if( resultado > 25 && resultado < 29.9 ){
            tvResultado.setTextColor(Color.rgb(255,210,0));
        }else if( resultado > 30 && resultado < 34.9 ){
            tvResultado.setTextColor(Color.rgb(255,165,0));
        }else if( resultado >= 35 ){
            tvResultado.setTextColor(Color.RED);
        }


    }

    private void btLimparOnClick(){
        etPeso.setText( "" );
        etAltura.setText( "" );
        tvResultado.setText( "0.0" );
        tvResultado.setTextColor(Color.BLACK);
        etPeso.requestFocus();
    }
}