import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaming_epochs/models/primary_color_model.dart';
import 'package:gaming_epochs/utils/platform_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

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

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  late PackageInfo? packageInfo;
  late SharedPreferences? prefs;

  late bool enableCalendar;
  late bool enablePush;

  @override
  initState() {
    super.initState();
    packageInfo = null;
    prefs = null;
    enableCalendar = false;
    enablePush = false;
    PackageInfo.fromPlatform().then((info) => setState(() {
          packageInfo = info;
        }));
    SharedPreferences.getInstance().then((prefs) => setState(() {
          this.prefs = prefs;

          enableCalendar = prefs.getBool(PrefKeys.enableCalendar) ?? false;
          enablePush = prefs.getBool(PrefKeys.enablePush) ?? false;
        }));
  }

  Widget subtitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16.r,
        horizontal: 24.r,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget listItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    Widget? extra,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: onTap ?? () {},
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.r,
          horizontal: 8.r,
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              flex: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16.r,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            ...(extra != null
                ? [
                    Flexible(
                      flex: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 8.r,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            extra,
                          ],
                        ),
                      ),
                    ),
                  ]
                : []),
          ],
        ),
      ),
    );
  }

  void updateCalendarState(bool state) {
    if (!PlatformUtils.isAndroid) {
      BotToast.showText(text:"暂时不支持此平台");
      return;
    }

    setState(() {
      enableCalendar = state;
    });
  }

  void updatePushState(bool state) {
    if (!PlatformUtils.isAndroid) {
      BotToast.showText(text:"暂时不支持此平台");
      return;
    }

    setState(() {
      enablePush = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: MediaQuery.of(context).padding.left,
        right: MediaQuery.of(context).padding.right,
      ),
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                top: 24.r,
                bottom: 12.r,
                left: 16.r,
                right: 16.r,
              ),
              child: Text(
                "设置",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          Flexible(
            child: subtitle("常规"),
          ),
          Flexible(
            child: listItem(
              context: context,
              icon: Icons.color_lens,
              title: "主题色",
              description: "选择应用的主题色",
              extra: Container(
                width: 16.r,
                height: 16.r,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () {
                context.push("/settings/primary_color");
              },
            ),
          ),
          Flexible(
            child: listItem(
              context: context,
              icon: Icons.calendar_month,
              title: "日历",
              description: "订阅游戏发售时间到日历",
              extra: Switch(
                value: enableCalendar,
                onChanged: (value) {
                  updateCalendarState(!enableCalendar);
                },
              ),
              onTap: () {
                updateCalendarState(!enableCalendar);
              },
            ),
          ),
          Flexible(
            child: listItem(
              context: context,
              icon: Icons.send,
              title: "推送",
              description: "接收游戏发售提醒推送",
              extra: Switch(
                value: enablePush,
                onChanged: (value) {
                  updatePushState(!enablePush);
                },
              ),
              onTap: () {
                updatePushState(!enablePush);
              },
            ),
          ),
          Flexible(
            child: subtitle("其它"),
          ),
          Flexible(
            child: listItem(
              context: context,
              icon: Icons.feedback,
              title: "问题反馈",
              description: "反馈Bug与建议",
            ),
          ),
          Flexible(
            child: listItem(
              context: context,
              icon: Icons.people,
              title: "关于我们",
              description: "开发团队",
            ),
          ),
          Flexible(
            child: listItem(
              context: context,
              icon: Icons.info,
              title: "游历年轴 版本",
              description:
                  "v${packageInfo?.version ?? "UNKNOWN"}_${packageInfo?.buildNumber ?? "UNKNOWN"}",
            ),
          ),
        ],
      ),
    );
  }
}
