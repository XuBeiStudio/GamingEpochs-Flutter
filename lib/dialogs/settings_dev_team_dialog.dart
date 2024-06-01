import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/http_utils.dart';

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