import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class JPushApi {
  void setAuth(bool auth);
  void setDebug(bool debug);
  void init();
  String? getRegistrationID();
}