package com.liziyi0914.gamingepochs.services

import cn.jpush.android.service.JPushMessageService

class JGMessageService : JPushMessageService() {



//    override fun onNewToken(token: String) {
//        super.onNewToken(token)
//        // FCM生成的令牌，可以用于标识用户的身份
//        Log.i("TAG", "onNewToken: $token")
//    }
//
//    override fun onMessageReceived(message: RemoteMessage) {
//        super.onMessageReceived(message)
//        // 接收到推送消息时回调此方法
//
//        val notificationManager = NotificationManagerCompat.from(this)
//
//        val name = "发售日9时"
//        val descriptionText = "游戏发售当天上午9时"
//        val importance = NotificationManager.IMPORTANCE_DEFAULT
//        val channel = NotificationChannel("d9", name, importance)
//        channel.description = descriptionText
//
//        notificationManager.createNotificationChannel(channel)
//
//        if (notificationManager.areNotificationsEnabled()) {
//            val intent = Intent(this, GameActivity::class.java)
//            intent.putExtra("id", "3e74af89-c371-4491-be2c-70b52f578979")
//
//            val notification = NotificationCompat.Builder(this, "d9")
//                //设置小图标
//                .setSmallIcon(R.drawable.ic_notification)
//                // 设置通知标题
//                .setContentTitle("title")
//                // 设置通知内容
//                .setContentText("content")
//                // 设置是否自动取消
//                .setAutoCancel(true)
//                // 设置通知声音
//                .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))
//                // 设置点击的事件
//                .setContentIntent(
//                    PendingIntent.getActivity(
//                        this,
//                        0,
//                        intent,
//                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
//                    )
//                )
//                .build()
//            // notificationId可以记录下来
//            // 可以通过notificationId对通知进行相应的操作
//            if (ActivityCompat.checkSelfPermission(
//                    this,
//                    Manifest.permission.POST_NOTIFICATIONS
//                ) != PackageManager.PERMISSION_GRANTED
//            ) {
//                return
//            }
//            notificationManager.notify(0, notification)
//        }
//    }

}