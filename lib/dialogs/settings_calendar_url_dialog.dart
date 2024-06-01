import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsCalendarUrlDialogPage extends StatefulWidget {
  const SettingsCalendarUrlDialogPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsCalendarUrlDialogPage();
}

class _SettingsCalendarUrlDialogPage
    extends State<SettingsCalendarUrlDialogPage> {
  static const url = "https://gaming-epochs.vercel.app/calendar.ics";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("日历订阅URL"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("请在日历APP中订阅以下URL"),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(
                    text: url,
                  ),
                  readOnly: true,
                ),
              ),
              TextButton(
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: url));
                  BotToast.showText(text: "已复制到剪贴板");
                },
                child: const Text("复制"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}