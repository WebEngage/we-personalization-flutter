package com.example.flutter_personalization_sdk_example


import io.flutter.app.FlutterApplication;
import com.webengage.webengage_plugin.WebengageInitializer;
import com.webengage.sdk.android.WebEngageConfig;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.LocationTrackingStrategy;

class MainApplication : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        val webEngageConfig = WebEngageConfig.Builder()
            .setWebEngageKey("~2024b713")
            .setAutoGCMRegistrationFlag(false)
            .setLocationTrackingStrategy(LocationTrackingStrategy.ACCURACY_BEST)
            .setDebugMode(true) // only in development mode
            .build()
        WebengageInitializer.initialize(this, webEngageConfig)

    }
}