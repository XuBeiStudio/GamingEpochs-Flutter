import 'dart:js_interop';

@JS()
external JSPromise<JSString?> getHmsToken();

@JS()
external JSPromise deleteHmsToken(String token);

@JS()
external JSPromise<JSString?> getFcmToken();

@JS()
external JSPromise deleteFcmToken(String token);
