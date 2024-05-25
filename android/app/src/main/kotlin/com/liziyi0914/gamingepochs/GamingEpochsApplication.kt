package com.liziyi0914.gamingepochs

import android.app.Application

//import com.microsoft.appcenter.AppCenter
//import com.microsoft.appcenter.analytics.Analytics
//import com.microsoft.appcenter.crashes.Crashes

class GamingEpochsApplication: Application() {

    override fun onCreate() {
        super.onCreate()

//        JPushInterface.setDebugMode(true)
//
//        // 调整点一：初始化代码前增加setAuth调用
//        val isPrivacyReady = true // app根据是否已弹窗获取隐私授权来赋值
//        if(!isPrivacyReady){
//            JCollectionAuth.setAuth(this, false) // 后续的初始化与启用推送服务过程将被拦截，即不会开启推送业务
//        }
//        JPushInterface.init(this)
//
//        Log.i("JPush", "reg: ${JPushInterface.getRegistrationID(this)}")

        // 调整点二：App用户同意了隐私政策授权，并且开发者确定要开启推送服务后调用
//        JCollectionAuth.setAuth(context, true) //如初始化被拦截过，将重试初始化过程

//        AppCenter.start(
//            this, "928a10e0-9ba6-4632-b7e2-f6c42bc2187f",
//            Analytics::class.java, Crashes::class.java
//        )
    }

}
