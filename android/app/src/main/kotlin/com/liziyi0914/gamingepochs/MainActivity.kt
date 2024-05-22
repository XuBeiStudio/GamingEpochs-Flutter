package com.liziyi0914.gamingepochs

import com.liziyi0914.gamingepochs.pigeons.CalendarApi
import com.liziyi0914.gamingepochs.utils.Calendar
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        CalendarApi.setUp(flutterEngine.dartExecutor.binaryMessenger, Calendar(context))
    }
}
