package com.medistock.activities;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * MedicineActivity - Browse, search, and inspect pharmacy medicine inventory.
 */
public class MedicineActivity extends Activity {

    private static final String DEFAULT_BASE_URL = "http://10.0.2.2:8080/api";

    private EditText editSearch;
    private ListView listViewMedicines;
    private ProgressBar progressBar;

    private final List<String> medicineDisplayList = new ArrayList<>();
    private final List<JSONObject> fullMedicineList = new ArrayList<>();
    private ArrayAdapter<String> adapter;

    private final ExecutorService executor = Executors.newSingleThreadExecutor();
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initViews();
        fetchMedicines();
    }

    private void initViews() {
        int layoutId = getResources().getIdentifier("activity_medicine", "layout", getPackageName());
        if (layoutId != 0) {
            setContentView(layoutId);
            editSearch = findViewById(getResources().getIdentifier("edit_search_medicine", "id", getPackageName()));
            listViewMedicines = findViewById(getResources().getIdentifier("list_medicines", "id", getPackageName()));
            progressBar = findViewById(getResources().getIdentifier("progress_bar_medicines", "id", getPackageName()));
        }

        if (listViewMedicines != null) {
            adapter = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, medicineDisplayList);
            listViewMedicines.setAdapter(adapter);
            listViewMedicines.setOnItemClickListener((parent, view, position, id) -> {
                if (position < fullMedicineList.size()) {
                    JSONObject med = fullMedicineList.get(position);
                    String name = med.optString("medicineName", "Medicine");
                    String price = med.optString("sellingPrice", "0");
                    String rack = med.optString("rackId", "N/A");
                    int qty = med.optInt("quantity", 0);
                    Toast.makeText(this, name + "\nPrice: ₹" + price + " | Stock: " + qty + " | Rack: " + rack, Toast.LENGTH_LONG).show();
                }
            });
        }

        if (editSearch != null) {
            editSearch.addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    filterMedicines(s.toString());
                }

                @Override
                public void afterTextChanged(Editable s) {}
            });
        }
    }

    private void fetchMedicines() {
        if (progressBar != null) progressBar.setVisibility(View.VISIBLE);

        executor.execute(() -> {
            List<JSONObject> fetched = new ArrayList<>();
            try {
                URL url = new URL(DEFAULT_BASE_URL + "/medicines");
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");
                conn.setRequestProperty("Accept", "application/json");
                conn.setConnectTimeout(6000);
                conn.setReadTimeout(6000);

                if (conn.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
                    StringBuilder sb = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        sb.append(line);
                    }
                    JSONArray arr = new JSONArray(sb.toString());
                    for (int i = 0; i < arr.length(); i++) {
                        JSONObject obj = arr.getJSONObject(i);
                        if (obj.optBoolean("active", true)) {
                            fetched.add(obj);
                        }
                    }
                }
                conn.disconnect();
            } catch (Exception e) {
                // Mock fallback items if offline
                try {
                    JSONObject m1 = new JSONObject();
                    m1.put("medicineName", "Paracetamol 500mg");
                    m1.put("medicineCode", "MED-001");
                    m1.put("sellingPrice", 2.00);
                    m1.put("quantity", 950);
                    m1.put("rackId", "Rack A-2");
                    fetched.add(m1);

                    JSONObject m2 = new JSONObject();
                    m2.put("medicineName", "Amoxicillin 250mg");
                    m2.put("medicineCode", "MED-002");
                    m2.put("sellingPrice", 6.50);
                    m2.put("quantity", 480);
                    m2.put("rackId", "Rack B-1");
                    fetched.add(m2);
                } catch (Exception ignored) {}
            }

            mainHandler.post(() -> {
                if (progressBar != null) progressBar.setVisibility(View.GONE);
                fullMedicineList.clear();
                fullMedicineList.addAll(fetched);
                refreshListView(fullMedicineList);
            });
        });
    }

    private void filterMedicines(String query) {
        String lowerQuery = query.toLowerCase().trim();
        List<JSONObject> filtered = new ArrayList<>();
        for (JSONObject med : fullMedicineList) {
            String name = med.optString("medicineName", "").toLowerCase();
            String code = med.optString("medicineCode", "").toLowerCase();
            if (name.contains(lowerQuery) || code.contains(lowerQuery)) {
                filtered.add(med);
            }
        }
        refreshListView(filtered);
    }

    private void refreshListView(List<JSONObject> list) {
        medicineDisplayList.clear();
        for (JSONObject m : list) {
            String name = m.optString("medicineName", "");
            String code = m.optString("medicineCode", "");
            double price = m.optDouble("sellingPrice", 0.0);
            int qty = m.optInt("quantity", 0);
            medicineDisplayList.add(name + " (" + code + ")\n₹" + String.format("%.2f", price) + " | In Stock: " + qty);
        }
        if (adapter != null) {
            adapter.notifyDataSetChanged();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        executor.shutdown();
    }
}
