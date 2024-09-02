package com.lakuemas.app

import android.os.Bundle
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes
import io.flutter.embedding.android.FlutterActivity


class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        AppCenter.start(
            application, "811910df-c687-4951-9e71-cae64bbd31d4",
            Analytics::class.java,
            Crashes::class.java
        )
        AppCenter.setEnabled(true)
        Analytics.setEnabled(true)
        Crashes.setEnabled(true)
        super.onCreate(savedInstanceState)
    }
}
