import 'dart:js_interop';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gaming_epochs/utils/http_utils.dart';
import 'package:gaming_epochs/utils/platform_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../platforms/web_push/web.dart';
import '../constants.dart';
import '../dialogs/loading_dialog.dart';
import '../pigeons/calendar.dart';
import '../pigeons/jpush.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  late PackageInfo? packageInfo;
  late SharedPreferences? prefs;
  late String? registrationId;
  late String? webPushProvider;

  late bool enableCalendar;
  late bool enablePush;

  @override
  initState() {
    super.initState();

    packageInfo = null;
    prefs = null;
    enableCalendar = false;
    enablePush = false;
    webPushProvider = "_DISABLE";

    PackageInfo.fromPlatform().then((info) => setState(() {
          packageInfo = info;
        }));

    SharedPreferences.getInstance().then((prefs) => setState(() {
          this.prefs = prefs;

          enableCalendar = prefs.getBool(PrefKeys.enableCalendar) ?? false;
          enablePush = prefs.getBool(PrefKeys.enablePush) ?? false;
          webPushProvider =
              prefs.getString(PrefKeys.webPushProvider) ?? "_DISABLE";

          if (PlatformUtils.isWeb) {
            if (webPushProvider == "HMS") {
              registrationId = prefs.getString(PrefKeys.webPushProviderHms);
            } else if (webPushProvider == "FCM") {
              registrationId = prefs.getString(PrefKeys.webPushProviderFcm);
            }
          }
        }));

    registrationId = null;
    if (PlatformUtils.isAndroid) {
      var jpush = JPushApi();
      jpush.getRegistrationID().then((id) => setState(() {
            registrationId = id;
          }));
    }
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
        child: Row(
          children: [
            Padding(
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8.r,
                      ),
                      child: extra,
                    ),
                  ]
                : []),
          ],
        ),
      ),
    );
  }

  Future<void> updateCalendarState(bool state) async {
    if (SupportUtils.supportCalendar) {
      // 获取权限
      var status = await Permission.calendarFullAccess.request();
      if (status.isGranted || status.isProvisional) {
        var api = CalendarApi();
        if (state) {
          // 显示进度Modal
          void Function(String) update = (String msg) {};
          SmartDialog.config.loading = SmartConfigLoading(
            leastLoadingTime: const Duration(seconds: 1),
          );
          SmartDialog.showLoading(
            builder: (context) {
              return LoadingDialog(
                title: "导入中",
                info: "0%",
                update: (f) => update = f,
              );
            },
          );

          // 导入日程
          var calId = await api.getOrCreateAccount();
          var indexes = await getIndexes();
          double total = indexes.length.toDouble();
          double current = 0;
          List<String> ids = [];
          for (var index in indexes) {
            if (index.id != null) {
              await api.addEvent(
                calId,
                GameCalendarInfo(
                  id: index.id!,
                  name: index.title,
                  releaseDate: index.releaseDate,
                  platforms: index.platforms,
                ),
              );
              ids.add(index.id!);
            }
            current++;
            update.call("${(current * 1000 / total).round().toDouble() / 10}%");
          }
          await prefs?.setStringList(PrefKeys.cachedEvents, ids);

          // 关闭进度Modal
          SmartDialog.dismiss();
          SmartDialog.config.loading = SmartConfigLoading();
        } else {
          SmartDialog.config.loading = SmartConfigLoading(
            leastLoadingTime: const Duration(seconds: 1),
          );
          SmartDialog.showLoading(msg: "删除中...");

          var id = await api.getAccount();
          if (id != null) {
            await api.removeAccount(id);
          }

          SmartDialog.dismiss();
          SmartDialog.config.loading = SmartConfigLoading();
        }
      } else if (status.isPermanentlyDenied) {
        BotToast.showText(text: "请授予日历权限");
        openAppSettings();
      } else {
        state = !state;
        BotToast.showText(text: "请授予日历权限");
      }

      setState(() {
        enableCalendar = state;
        prefs?.setBool(PrefKeys.enableCalendar, state);
      });
    } else {
      BotToast.showText(text: "暂时不支持此平台");
    }
  }

  Future<void> unsubscribeWebPush() async {
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

  Future<void> updateWebPushState() async {
    if (SupportUtils.supportPush && PlatformUtils.isWeb) {
      // 获取权限
      var status = await Permission.notification.request();
      if (status.isGranted || status.isProvisional) {
        String? data = await context.push("/settings/web_push");
        if (data == null) {
          return;
        }
        switch (data) {
          case "_DISABLE":
            {
              SmartDialog.config.loading = SmartConfigLoading(
                leastLoadingTime: const Duration(seconds: 1),
              );
              SmartDialog.showLoading(msg: "关闭中...");

              await unsubscribeWebPush();
              setState(() {
                webPushProvider = data;
              });

              SmartDialog.dismiss();
              SmartDialog.config.loading = SmartConfigLoading();
              break;
            }
          case "HMS":
            {
              SmartDialog.config.loading = SmartConfigLoading(
                leastLoadingTime: const Duration(seconds: 1),
              );
              SmartDialog.showLoading(msg: "启动中...");

              await unsubscribeWebPush();
              var token = await getHmsToken().toDart;
              if (token == null) {
                BotToast.showText(text: "华为Token获取失败，请重新尝试");
                break;
              }
              prefs?.setString(PrefKeys.webPushProviderHms, token.toDart);
              setState(() {
                webPushProvider = data;
                registrationId = token.toDart;
              });

              SmartDialog.dismiss();
              SmartDialog.config.loading = SmartConfigLoading();
              break;
            }
          case "FCM":
            {
              SmartDialog.config.loading = SmartConfigLoading(
                leastLoadingTime: const Duration(seconds: 1),
              );
              SmartDialog.showLoading(msg: "启动中...");

              await unsubscribeWebPush();
              var token = await getFcmToken().toDart;
              if (token == null) {
                BotToast.showText(text: "FCM Token获取失败，请重新尝试");
                break;
              }
              prefs?.setString(PrefKeys.webPushProviderFcm, token.toDart);
              setState(() {
                webPushProvider = data;
                registrationId = token.toDart;
              });

              SmartDialog.dismiss();
              SmartDialog.config.loading = SmartConfigLoading();
              break;
            }
        }
      } else if (status.isPermanentlyDenied) {
        BotToast.showText(text: "请授予通知相关权限");
      } else {
        BotToast.showText(text: "请授予通知相关权限");
      }
    } else {
      BotToast.showText(text: "暂时不支持此平台");
    }
  }

  Future<void> updatePushState(bool state) async {
    if (SupportUtils.supportPush) {
      // 获取权限
      var status = await Permission.notification.request();
      if (status.isGranted || status.isProvisional) {
        var api = JPushApi();
        await api.setAuth(state);
        var regId = await api.getRegistrationID();
        setState(() {
          registrationId = regId;
        });
      } else if (status.isPermanentlyDenied) {
        BotToast.showText(text: "请授予通知相关权限");
        openAppSettings();
      } else {
        state = !state;
        BotToast.showText(text: "请授予通知相关权限");
      }

      setState(() {
        enablePush = state;
        prefs?.setBool(PrefKeys.enablePush, state);
      });
    } else {
      BotToast.showText(text: "暂时不支持此平台");
    }
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
          if (SupportUtils.supportCalendar)
            Flexible(
              child: listItem(
                context: context,
                icon: Icons.calendar_month,
                title: "订阅日历",
                description: "自动订阅游戏发售时间到日历",
                extra: Switch(
                  value: enableCalendar,
                  onChanged: (value) async {
                    await updateCalendarState(!enableCalendar);
                  },
                ),
                onTap: () async {
                  await updateCalendarState(!enableCalendar);
                },
              ),
            ),
          Flexible(
            child: listItem(
              context: context,
              icon: Icons.calendar_month,
              title: "添加日历",
              description: "手动添加游戏发售时间到日历",
              onTap: () {
                context.push("/settings/calendar");
              },
            ),
          ),
          if (SupportUtils.supportPush)
            Flexible(
              child: listItem(
                context: context,
                icon: Icons.send,
                title: "推送",
                description: "接收游戏发售提醒推送",
                extra: PlatformUtils.isWeb
                    ? (Text({
                        "_DISABLE": "关闭",
                        "FCM": "FCM",
                        "HMS": "华为",
                      }[webPushProvider]!))
                    : (Switch(
                        value: enablePush,
                        onChanged: (value) async {
                          await updatePushState(!enablePush);
                        },
                      )),
                onTap: () async {
                  if (PlatformUtils.isWeb) {
                    await updateWebPushState();
                  } else {
                    await updatePushState(!enablePush);
                  }
                },
              ),
            ),
          Flexible(
            child: subtitle("其它"),
          ),
          if (SupportUtils.supportPush)
            Flexible(
              child: listItem(
                context: context,
                icon: Icons.bug_report,
                title: "Registration ID",
                description: registrationId ?? "未开启",
                onTap: () async {
                  Clipboard.setData(ClipboardData(text: registrationId ?? ""));
                  BotToast.showText(text: "复制成功");
                },
              ),
            ),
          Flexible(
            child: listItem(
              context: context,
              icon: Icons.feedback,
              title: "问题反馈",
              description: "反馈Bug与建议",
              onTap: () async {
                var uri = Uri(
                  scheme: "https",
                  host: "support.qq.com",
                  path: "product/634520",
                );
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  BotToast.showText(text: "兔小巢打开失败");
                }
              },
            ),
          ),
          Flexible(
            child: listItem(
              context: context,
              icon: Icons.people,
              title: "关于我们",
              description: "开发团队",
              onTap: () {
                context.push("/settings/dev_team");
              },
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
