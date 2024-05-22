import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../icons.dart';
import '../utils/http_utils.dart';

class Tag extends StatelessWidget {
  final String content;

  const Tag(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 4.r,
          horizontal: 12.r,
        ),
        child: Text(
          content,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}

class ContentRow extends StatelessWidget {
  final Widget child;
  final double? bottom;

  const ContentRow(this.child, {super.key, this.bottom});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24.r,
        right: 24.r,
        bottom: bottom ?? 8.r,
      ),
      child: child,
    );
  }
}

class InfoRow extends StatelessWidget {
  final Widget child;

  const InfoRow(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 8.r,
        ),
        child: child,
      ),
    );
  }
}

class GameInfoPage extends StatefulWidget {
  final String id;

  const GameInfoPage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() => _GameInfoPageState();
}

class _GameInfoPageState extends State<GameInfoPage>
    with TickerProviderStateMixin {
  final dateFormat = DateFormat("yyyy.MM.dd");

  late final TabController _tabController;
  late Game? game;
  late String? introduction;

  late bool released;
  late DateTime releaseDate;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
    });

    game = null;
    released = false;
    releaseDate = DateTime.fromMicrosecondsSinceEpoch(0);
    getGameInfo(widget.id).then((value) {
      var date = dateFormat.parse(value.releaseDate ?? "1970.01.01");
      var today = DateTime.now();

      setState(() {
        game = value;
        releaseDate = date;
        released = today.isAfter(date);
      });
    });

    introduction = null;
    getGameIntroduction(widget.id).then((value) {
      setState(() {
        introduction = value;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tabs = [
      Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "发行商：${game?.publisher?.map((e) => e.name).join(", ")}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        "开发商：${game?.developer?.map((e) => e.name).join(", ")}",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: IconsExt.fromList(game?.platforms ?? [])
                            .map((e) => Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.r),
                                  child: Icon(
                                    e,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    size: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.fontSize ??
                                        12,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    if (game?.releaseDate != null)
                      Text(
                        released
                            ? "于 ${game?.releaseDate ?? ""} 发售"
                            : "预计 ${game?.releaseDate ?? ""} 发售",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                  ],
                ),
              ],
            ),
          )),
          InfoRow(
            Wrap(
              children: [
                Tag("动作"),
                Tag("冒险"),
                Tag("角色扮演"),
                Tag("奇幻"),
              ],
            ),
          ),
        ],
      ),
      MarkdownBody(data: introduction ?? ""),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        title: Text(game?.name?.locale("zh_CN") ?? "UNKNOWN"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          PopupMenuButton(
            tooltip: "操作",
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.share,
                      ),
                      Padding(padding: EdgeInsets.only(left: 4.r), child: Text("分享"),)
                    ],
                  ),
                  onTap: () {
                    final box = context.findRenderObject() as RenderBox?;

                    Share.share(
                      "https://gaming-epochs.liziyi0914.com/game/${widget.id}",
                      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                    );
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_alert,
                      ),
                      Padding(padding: EdgeInsets.only(left: 4.r), child: Text("订阅"),)
                    ],
                  ),
                  onTap: () {},
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          //背景
          if (game?.bg != null)
            Image.network(
              game?.bg ?? "",
              fit: BoxFit.cover,
              width: 1.sw,
              height: 128.r * 1.5,
            ),
          //渐变色
          Padding(
            padding: EdgeInsets.only(
              top: 128.r * 0.6,
            ),
            child: Container(
              width: double.infinity,
              height: 128.r * 0.9,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [
                    0.0,
                    1.0,
                  ],
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .surfaceContainer
                        .withOpacity(0),
                    Theme.of(context).colorScheme.surfaceContainer,
                  ],
                ),
              ),
            ),
          ),
          //游戏名
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1024,
              ),
              child: ListView(
                children: [
                  Container(
                    height: 128.r - 8.r,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 8.r,
                          ),
                          ContentRow(
                            Padding(
                              padding: EdgeInsets.only(
                                top: 12.r,
                                bottom: 12.r - 8.r,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    game?.name?.locale("zh_CN") ?? "Unknown",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    game?.name?.locale("en_US") ?? "Unknown",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (!released)
                          ContentRow(
                            Card.filled(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.r,
                                  horizontal: 18.r,
                                ),
                                child: Text(
                                  "距离游戏发售还有 ${releaseDate.difference(DateTime.now()).inDays} 天",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          ContentRow(
                            StickyHeader(
                              header: Container(
                                color: Theme.of(context).colorScheme.surface,
                                child: TabBar(
                                  controller: _tabController,
                                  tabs: const [
                                    Tab(
                                      text: "基本信息",
                                    ),
                                    Tab(
                                      text: "游戏简介",
                                    ),
                                  ],
                                ),
                              ),
                              content: Padding(
                                padding: EdgeInsets.only(
                                  left: 12.r,
                                  right: 12.r,
                                  top: 8.r,
                                  bottom: 16.r,
                                ),
                                child: tabs[tabIndex],
                              ),
                            ),
                            bottom: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 16.r,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
