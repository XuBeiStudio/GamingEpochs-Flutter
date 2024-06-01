import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/primary_color_model.dart';

class SettingsWebPushDialogPage extends StatefulWidget {
  const SettingsWebPushDialogPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsWebPushDialogPage();
}

class _SettingsWebPushDialogPage
    extends State<SettingsWebPushDialogPage> {
  late SharedPreferences? prefs;
  late String provider;

  @override
  initState() {
    super.initState();
    prefs = null;
    provider = "_DISABLE";
    SharedPreferences.getInstance().then((prefs) => setState(() {
      this.prefs = prefs;
      provider = prefs.getString(PrefKeys.webPushProvider) ?? "_DISABLE";
    }));
  }

  void setValue(String? value) {
    var v = value ?? "_DISABLE";
    prefs?.setString(PrefKeys.webPushProvider, v);
    setState(() {
      provider = v;
    });
    Navigator.pop(context, v);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("选择推送通道"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            title: const Text("关闭"),
            value: "_DISABLE",
            groupValue: provider,
            onChanged: setValue,
          ),
          RadioListTile(
            title: const Text("FCM"),
            value: "FCM",
            groupValue: provider,
            onChanged: setValue,
          ),
          RadioListTile(
            title: const Text("华为"),
            value: "HMS",
            groupValue: provider,
            onChanged: setValue,
          ),
        ],
      ),
    );
  }
}