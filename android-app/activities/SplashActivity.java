package com.medistock.activities;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

/**
 * SplashActivity - Initial launch screen for MediStock Android Application.
 * Checks for existing user credentials and navigates accordingly.
 */
public class SplashActivity extends Activity {

    private static final int SPLASH_DELAY_MS = 1500;
    private static final String PREFS_NAME = "MediStockPrefs";
    private static final String KEY_TOKEN = "auth_token";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        new Handler(Looper.getMainLooper()).postDelayed(() -> {
            SharedPreferences prefs = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
            String token = prefs.getString(KEY_TOKEN, null);

            Intent nextIntent;
            if (token != null && !token.trim().isEmpty()) {
                nextIntent = new Intent(SplashActivity.this, DashboardActivity.class);
            } else {
                nextIntent = new Intent(SplashActivity.this, LoginActivity.class);
            }

            startActivity(nextIntent);
            finish();
        }, SPLASH_DELAY_MS);
    }
}
