import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gaming_epochs/models/primary_color_model.dart';
import 'package:gaming_epochs/utils/http_utils.dart';
import 'package:gaming_epochs/utils/platform_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../pigeons/calendar.dart';
import '../pigeons/jpush.dart';

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

class GithubAvatar extends StatefulWidget {
  final String username;

  const GithubAvatar({super.key, required this.username});

  @override
  State<StatefulWidget> createState() => _GithubAvatar();
}

class _GithubAvatar extends State<GithubAvatar> {
  late String url;

  @override
  void initState() {
    super.initState();

    url = "https://github.com/identicons/xb.png";

    getGithubAvatar(widget.username).then((value) {
      setState(() {
        url = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(url),
    );
  }
}

class SettingsDevTeamDialogPage extends StatefulWidget {
  const SettingsDevTeamDialogPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsDevTeamDialogPage();
}

class _SettingsDevTeamDialogPage extends State<SettingsDevTeamDialogPage> {
  late SharedPreferences? prefs;

  @override
  initState() {
    super.initState();
    prefs = null;
    SharedPreferences.getInstance().then((prefs) => setState(() {
          this.prefs = prefs;
        }));
  }

  Widget githubUser({
    required String name,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.r),
      onTap: () async {
        var uri = Uri(
          scheme: "https",
          host: "github.com",
          path: name,
        );
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          BotToast.showText(text: "Github打开失败");
        }
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
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: GithubAvatar(
                  username: name,
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
      title: const Text("开发团队"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Flutter开发",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          githubUser(name: "liziyi0914"),
          Text(
            "数据整理",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          githubUser(name: "DefinerSy"),
        ],
      ),
    );
  }
}

class LoadingDialog extends StatefulWidget {
  final String title;
  final Function(void Function(String))? update;
  final String? info;

  const LoadingDialog({super.key, required this.title, this.update, this.info});

  @override
  State<StatefulWidget> createState() => _LoadingDialog();
}

class _LoadingDialog extends State<LoadingDialog> {
  late String info;

  @override
  initState() {
    super.initState();

    info = widget.info ?? "";

    widget.update?.call((info) {
      setState(() {
        this.info = info;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.only(top: 4.r),
            child: Text(info),
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
  late String? registrationId;

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

  Future<void> updatePushState(bool state) async {
    if (SupportUtils.supportPush) {
      // 获取权限
      var status = await Permission.notification.request();
      if (status.isGranted || status.isProvisional) {
        var api = JPushApi();
        await api.setAuth(state);
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
                extra: Switch(
                  value: enablePush,
                  onChanged: (value) async {
                    await updatePushState(!enablePush);
                  },
                ),
                onTap: () async {
                  await updatePushState(!enablePush);
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
                description: registrationId ?? "",
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
