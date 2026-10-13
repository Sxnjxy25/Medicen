package com.medistock.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

/**
 * QRScannerActivity - Barcode and QR code scanner interface.
 * Scans QR codes / barcodes to quickly find medicine details and rack locations.
 */
public class QRScannerActivity extends Activity {

    public static final String EXTRA_SCANNED_CODE = "scanned_code";

    private TextView txtStatus;
    private EditText editManualCode;
    private Button btnSimulateScan;
    private Button btnConfirmManual;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initViews();
    }

    private void initViews() {
        int layoutId = getResources().getIdentifier("activity_qr_scanner", "layout", getPackageName());
        if (layoutId != 0) {
            setContentView(layoutId);
            txtStatus = findViewById(getResources().getIdentifier("txt_scanner_status", "id", getPackageName()));
            editManualCode = findViewById(getResources().getIdentifier("edit_manual_barcode", "id", getPackageName()));
            btnSimulateScan = findViewById(getResources().getIdentifier("btn_simulate_scan", "id", getPackageName()));
            btnConfirmManual = findViewById(getResources().getIdentifier("btn_confirm_manual", "id", getPackageName()));
        }

        if (btnSimulateScan != null) {
            btnSimulateScan.setOnClickListener(v -> returnScanResult("QR_PARA_500"));
        }

        if (btnConfirmManual != null) {
            btnConfirmManual.setOnClickListener(v -> {
                String code = editManualCode != null ? editManualCode.getText().toString().trim() : "";
                if (code.isEmpty()) {
                    Toast.makeText(this, "Please enter a barcode or QR code", Toast.LENGTH_SHORT).show();
                    return;
                }
                returnScanResult(code);
            });
        }
    }

    private void returnScanResult(String scannedCode) {
        Toast.makeText(this, "Scanned: " + scannedCode, Toast.LENGTH_SHORT).show();
        Intent data = new Intent();
        data.putExtra(EXTRA_SCANNED_CODE, scannedCode);
        setResult(RESULT_OK, data);
        finish();
    }
}
