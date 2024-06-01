import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/primary_color_model.dart';

class SettingsPrimaryColorDialogPage extends StatefulWidget {
  const SettingsPrimaryColorDialogPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPrimaryColorDialogPage();
}

class _SettingsPrimaryColorDialogPage
    extends State<SettingsPrimaryColorDialogPage> {
  late SharedPreferences? prefs;

  @override
  initState() {
    super.initState();
    prefs = null;
    SharedPreferences.getInstance().then((prefs) => setState(() {
      this.prefs = prefs;
    }));
  }

  Widget colorItem({
    required String name,
    required Color color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: () {
        prefs?.setInt(PrefKeys.primaryColor, color.value).then((isSuccess) {
          if (isSuccess) {
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        });
        PrimaryColorModel.of(context).updatePrimaryColor(color);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.r,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.r),
              child: Container(
                width: 12.r,
                height: 12.r,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Text(name),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("选择主题色"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          colorItem(
            name: "妃色",
            color: const Color(0xFFED5736),
          ),
          colorItem(
            name: "杏黄",
            color: const Color(0xFFFFA631),
          ),
          colorItem(
            name: "松柏绿",
            color: const Color(0xFF21A675),
          ),
          colorItem(
            name: "靛青",
            color: const Color(0xFF177CB0),
          ),
          colorItem(
            name: "藏蓝",
            color: const Color(0xFF3B2E7E),
          ),
          colorItem(
            name: "紫棠",
            color: const Color(0xFF56004F),
          ),
        ],
      ),
    );
  }
}