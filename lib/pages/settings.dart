import 'package:flutter/material.dart';

import '../components/game_card.dart';

class SettingsPage extends StatelessWidget {
  Widget subtitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget listItem(
      {required BuildContext context,
      required IconData icon,
      required String title,
      required String description,
      Widget? extra}) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              flex: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
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
                          horizontal: 8,
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
      onTap: () {},
    );
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
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 16,
              ),
              child: Text(
                "设置",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          Flexible(
            child: subtitle(context, "常规"),
          ),
          Flexible(
            child: listItem(
              context: context,
              icon: Icons.color_lens,
              title: "主题色",
              description: "选择应用的主题色",
              extra: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Flexible(
            child: listItem(
              context: context,
              icon: Icons.calendar_month,
              title: "日历",
              description: "订阅游戏发售时间到日历",
              extra: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
          ),
          Flexible(
            child: listItem(
              context: context,
              icon: Icons.send,
              title: "推送",
              description: "接收游戏发售提醒推送",
              extra: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
          ),
          Flexible(
            child: subtitle(context, "其它"),
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
              description: "v0.1.0",
            ),
          ),
        ],
      ),
    );
  }
}
