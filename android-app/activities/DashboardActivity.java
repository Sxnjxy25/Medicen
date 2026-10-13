package com.medistock.activities;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * DashboardActivity - Primary navigation hub for MediStock.
 * Shows high-level statistics and links to Medicines, Stock, Billing POS, and QR Scanner.
 */
public class DashboardActivity extends Activity {

    private static final String PREFS_NAME = "MediStockPrefs";
    private static final String DEFAULT_BASE_URL = "http://10.0.2.2:8080/api";

    private TextView txtWelcome;
    private TextView txtTotalMedicines;
    private TextView txtLowStock;
    private Button btnMedicines;
    private Button btnStock;
    private Button btnBilling;
    private Button btnQRScanner;
    private Button btnLogout;

    private final ExecutorService executor = Executors.newSingleThreadExecutor();
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initViews();
        loadDashboardStats();
    }

    private void initViews() {
        int layoutId = getResources().getIdentifier("activity_dashboard", "layout", getPackageName());
        if (layoutId != 0) {
            setContentView(layoutId);
            txtWelcome = findViewById(getResources().getIdentifier("txt_welcome", "id", getPackageName()));
            txtTotalMedicines = findViewById(getResources().getIdentifier("txt_total_medicines", "id", getPackageName()));
            txtLowStock = findViewById(getResources().getIdentifier("txt_low_stock", "id", getPackageName()));
            btnMedicines = findViewById(getResources().getIdentifier("btn_medicines", "id", getPackageName()));
            btnStock = findViewById(getResources().getIdentifier("btn_stock", "id", getPackageName()));
            btnBilling = findViewById(getResources().getIdentifier("btn_billing", "id", getPackageName()));
            btnQRScanner = findViewById(getResources().getIdentifier("btn_qr_scanner", "id", getPackageName()));
            btnLogout = findViewById(getResources().getIdentifier("btn_logout", "id", getPackageName()));
        }

        SharedPreferences prefs = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
        String username = prefs.getString("username", "User");
        String role = prefs.getString("role", "STAFF");

        if (txtWelcome != null) {
            txtWelcome.setText("Welcome, " + username + " (" + role + ")");
        }

        if (btnMedicines != null) {
            btnMedicines.setOnClickListener(v -> startActivity(new Intent(this, MedicineActivity.class)));
        }
        if (btnStock != null) {
            btnStock.setOnClickListener(v -> startActivity(new Intent(this, StockActivity.class)));
        }
        if (btnBilling != null) {
            btnBilling.setOnClickListener(v -> startActivity(new Intent(this, BillingActivity.class)));
        }
        if (btnQRScanner != null) {
            btnQRScanner.setOnClickListener(v -> startActivity(new Intent(this, QRScannerActivity.class)));
        }
        if (btnLogout != null) {
            btnLogout.setOnClickListener(v -> handleLogout());
        }
    }

    private void loadDashboardStats() {
        executor.execute(() -> {
            int totalMeds = 10;
            int lowStockCount = 2;

            try {
                URL url = new URL(DEFAULT_BASE_URL + "/medicines");
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setRequestProperty("Accept", "application/json");
                conn.setConnectTimeout(5000);
                conn.setReadTimeout(5000);

                if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        response.append(line);
                    }
                    JSONArray array = new JSONArray(response.toString());
                    totalMeds = array.length();
                    int lowCount = 0;
                    for (int i = 0; i < array.length(); i++) {
                        int qty = array.getJSONObject(i).optInt("quantity", 0);
                        int minStock = array.getJSONObject(i).optInt("minimumStock", 50);
                        if (qty < minStock) {
                            lowCount++;
                        }
                    }
                    lowStockCount = lowCount;
                }
                conn.disconnect();
            } catch (Exception ignored) {
                // Fallback to default estimated figures if offline
            }

            final int finalTotal = totalMeds;
            final int finalLow = lowStockCount;

            mainHandler.post(() -> {
                if (txtTotalMedicines != null) txtTotalMedicines.setText(String.valueOf(finalTotal));
                if (txtLowStock != null) txtLowStock.setText(String.valueOf(finalLow));
            });
        });
    }

    private void handleLogout() {
        SharedPreferences prefs = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
        prefs.edit().clear().apply();
        Toast.makeText(this, "Logged out successfully", Toast.LENGTH_SHORT).show();
        startActivity(new Intent(this, LoginActivity.class));
        finish();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        executor.shutdown();
    }
}
