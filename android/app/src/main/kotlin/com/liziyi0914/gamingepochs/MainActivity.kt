package com.liziyi0914.gamingepochs

import com.liziyi0914.gamingepochs.pigeons.calendar.CalendarApi
import com.liziyi0914.gamingepochs.pigeons.jpush.JPushApi
import com.liziyi0914.gamingepochs.utils.CalendarUtils
import com.liziyi0914.gamingepochs.utils.JPushUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        CalendarApi.setUp(flutterEngine.dartExecutor.binaryMessenger, CalendarUtils(context))
        JPushApi.setUp(flutterEngine.dartExecutor.binaryMessenger, JPushUtils(context))
    }
}
