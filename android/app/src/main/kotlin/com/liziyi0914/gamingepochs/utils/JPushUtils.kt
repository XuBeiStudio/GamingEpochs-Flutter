package com.liziyi0914.gamingepochs.utils

import android.content.Context
import cn.jiguang.api.utils.JCollectionAuth
import cn.jpush.android.api.JPushInterface
import com.liziyi0914.gamingepochs.pigeons.jpush.JPushApi

class JPushUtils(private var context: Context): JPushApi {
    override fun setAuth(auth: Boolean) {
        JCollectionAuth.setAuth(context, auth)
    }

    override fun setDebug(debug: Boolean) {
        JPushInterface.setDebugMode(debug)
    }

    override fun init() {
        JPushInterface.init(context)
    }

    override fun getRegistrationID(): String? {
        return JPushInterface.getRegistrationID(context)
    }
}