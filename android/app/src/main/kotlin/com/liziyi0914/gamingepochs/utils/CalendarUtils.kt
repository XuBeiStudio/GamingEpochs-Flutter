package com.liziyi0914.gamingepochs.utils

import android.content.ContentUris
import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.icu.util.TimeZone
import android.os.Build
import android.provider.CalendarContract
import android.util.Log
import cn.hutool.core.date.DateUtil
import com.liziyi0914.gamingepochs.pigeons.CalendarApi
import com.liziyi0914.gamingepochs.pigeons.GameCalendarInfo

private val EVENT_PROJECTION: Array<String> = arrayOf(
    CalendarContract.Calendars._ID,                     // 0
    CalendarContract.Calendars.ACCOUNT_NAME,            // 1
    CalendarContract.Calendars.CALENDAR_DISPLAY_NAME,   // 2
    CalendarContract.Calendars.OWNER_ACCOUNT            // 3
)

// The indices for the projection array above.
private const val PROJECTION_ID_INDEX: Int = 0
private const val PROJECTION_ACCOUNT_NAME_INDEX: Int = 1
private const val PROJECTION_DISPLAY_NAME_INDEX: Int = 2
private const val PROJECTION_OWNER_ACCOUNT_INDEX: Int = 3

private const val ACCOUNT_NAME = "游历年轴"
private const val OWNER_ACCOUNT = "cn.xu-bei.gaming_epochs.calendar"


class Calendar(private var context: Context) : CalendarApi {
    override fun createAccount(callback: (Result<Long>) -> Unit) {
        callback(Result.success(createAccount(context)))
    }

    override fun removeAccount(calendarId: Long, callback: (Result<Unit>) -> Unit) {
        callback(Result.success(removeAccount(context, calendarId)))
    }

    override fun getAccount(callback: (Result<Long?>) -> Unit) {
        callback(Result.success(getAccount(context)))
    }

    override fun getOrCreateAccount(callback: (Result<Long>) -> Unit) {
        callback(Result.success(getOrCreateAccount(context)))
    }

    override fun getEvent(calId: Long, info: GameCalendarInfo, callback: (Result<Long?>) -> Unit) {
        callback(Result.success(getEvent(context, calId, info)))
    }

    override fun addEvent(calId: Long, info: GameCalendarInfo, callback: (Result<Unit>) -> Unit) {
        callback(Result.success(addEvent(context, calId, info)))
    }
}

fun createAccount(context: Context): Long {
    val value = ContentValues()

    value.put(CalendarContract.Calendars.NAME, "游历年轴")
    value.put(CalendarContract.Calendars.ACCOUNT_NAME, ACCOUNT_NAME)
    value.put(CalendarContract.Calendars.ACCOUNT_TYPE, CalendarContract.ACCOUNT_TYPE_LOCAL)
    value.put(CalendarContract.Calendars.CALENDAR_DISPLAY_NAME, "游历年轴")
    value.put(CalendarContract.Calendars.VISIBLE, 1)
    value.put(
        CalendarContract.Calendars.CALENDAR_ACCESS_LEVEL,
        CalendarContract.Calendars.CAL_ACCESS_OWNER
    )
    value.put(CalendarContract.Calendars.SYNC_EVENTS, 1)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
        value.put(
            CalendarContract.Calendars.CALENDAR_TIME_ZONE,
            TimeZone.getTimeZone("Asia/Shanghai").id
        )
    }
    value.put(CalendarContract.Calendars.OWNER_ACCOUNT, OWNER_ACCOUNT)
    value.put(CalendarContract.Calendars.CAN_ORGANIZER_RESPOND, 0)

    val calendarUri = CalendarContract.Calendars.CONTENT_URI.buildUpon()
        .appendQueryParameter(CalendarContract.CALLER_IS_SYNCADAPTER, "true")
        .appendQueryParameter(CalendarContract.Calendars.ACCOUNT_NAME, ACCOUNT_NAME)
        .appendQueryParameter(
            CalendarContract.Calendars.ACCOUNT_TYPE,
            CalendarContract.ACCOUNT_TYPE_LOCAL
        )
        .build()

    val result = context.contentResolver.insert(calendarUri, value)
    return if (result == null) {
        -1
    } else {
        ContentUris.parseId(result)
    }
}

fun removeAccount(context: Context, calendarId: Long) {
    val calendarUri = ContentUris.withAppendedId(CalendarContract.Calendars.CONTENT_URI, calendarId)

    context.contentResolver.delete(calendarUri, null, null)
}

fun getAccount(context: Context): Long? {
    val selection: String = "((${CalendarContract.Calendars.ACCOUNT_NAME} = ?) AND (" +
            "${CalendarContract.Calendars.ACCOUNT_TYPE} = ?) AND (" +
            "${CalendarContract.Calendars.OWNER_ACCOUNT} = ?))"
    val selectionArgs: Array<String> =
        arrayOf(ACCOUNT_NAME, CalendarContract.ACCOUNT_TYPE_LOCAL, OWNER_ACCOUNT)

    val cursor: Cursor = context.contentResolver.query(
        CalendarContract.Calendars.CONTENT_URI,
        EVENT_PROJECTION, selection, selectionArgs, null
    ) ?: return null

    var result: Long? = null

    while (cursor.moveToNext()) {
        result = cursor.getLong(PROJECTION_ID_INDEX)
    }

    cursor.close()

    return result
}

fun getOrCreateAccount(context: Context): Long {
    var result: Long? = getAccount(context)

    if (result == null) {
        result = createAccount(context)
    }

    return result
}

fun getEvent(context: Context, calId: Long, info: GameCalendarInfo): Long? {
    val selection: String = "(${CalendarContract.Events.TITLE} = ?) AND (" +
            "${CalendarContract.Events.CALENDAR_ID} = ?) AND (" +
            "${CalendarContract.Events.DTSTART} = ?)"
    val selectionArgs: Array<String> =
        arrayOf(
            info.name?:"",
            calId.toString(),
            DateUtil.parse(info.releaseDate, "yyyy.MM.dd").time.toString()
        )

    val cursor: Cursor = context.contentResolver.query(
        CalendarContract.Events.CONTENT_URI,
        arrayOf(CalendarContract.Events._ID), selection, selectionArgs, null
    ) ?: return null

    var result: Long? = null

    while (cursor.moveToNext()) {
        result = cursor.getLong(PROJECTION_ID_INDEX)
    }

    cursor.close()

    Log.i("CalendarUtils", "getEvent: $result")

    return result
}

fun addEvent(context: Context, calId: Long, info: GameCalendarInfo) {
    if (getEvent(context, calId, info) != null) {
        return
    }
    val values = ContentValues().apply {
        val releaseTime = DateUtil.parse(info.releaseDate, "yyyy.MM.dd").time

        put(CalendarContract.Events.DTSTART, releaseTime)
        put(CalendarContract.Events.DTEND, releaseTime + 24*60*60*1000-1)
        put(CalendarContract.Events.TITLE, info.name)
        put(CalendarContract.Events.DESCRIPTION, "《${info.name}》 现已在 ${info.platforms?.joinToString("、")} 上推出")
        put(CalendarContract.Events.CALENDAR_ID, calId)
        put(CalendarContract.Events.EVENT_TIMEZONE, "Asia/Shanghai")
        put(CalendarContract.Events.EVENT_LOCATION, info.platforms?.joinToString("、"))
    }
    context.contentResolver.insert(CalendarContract.Events.CONTENT_URI, values)

    Log.i("CalendarUtils", "addEvent: $calId \t ${info.name}")
}

