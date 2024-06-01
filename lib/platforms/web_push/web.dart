import 'dart:async';
import 'dart:js_interop';

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

@JS()
external JSPromise<JSString?> getHmsToken();

@JS()
external JSPromise deleteHmsToken(String token);

@JS()
external JSPromise<JSString?> getFcmToken();

@JS()
external JSPromise deleteFcmToken(String token);

Future<void> unsubscribeWebPush(String? webPushProvider, SharedPreferences? prefs) async {
  switch (webPushProvider) {
    case "HMS": {
      var token = prefs?.getString(PrefKeys.webPushProviderHms);
      if (token == null) {
        break;
      }
      await deleteHmsToken(token).toDart;
      break;
    }
    case "FCM": {
      var token = prefs?.getString(PrefKeys.webPushProviderFcm);
      if (token == null) {
        break;
      }
      await deleteFcmToken(token).toDart;
      break;
    }
  }
}

Future<String?> getHmsTokenWrapped() async {
  return (await (getHmsToken().toDart))?.toDart;
}

Future<String?> getFcmTokenWrapped() async {
  return (await (getFcmToken().toDart))?.toDart;
}
