import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../components/game_card.dart';
import '../icons.dart';

class Tag extends StatelessWidget {
  final String content;

  const Tag(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 4.r,
          horizontal: 12.r,
        ),
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodySmall,
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
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.r,
          right: 24.r,
          bottom: bottom ?? 8.r,
        ),
        child: child,
      ),
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
  late final TabController _tabController;

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
          InfoRow(Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("开发商：Game Science"),
                    Text("发行商：Game Science"),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconsExt.epic,
                      IconsExt.steam,
                      IconsExt.playstation,
                      IconsExt.xbox,
                      IconsExt.nintendo,
                      IconsExt.apple,
                      IconsExt.android,
                    ]
                        .map((e) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.r),
                              child: Icon(
                                e,
                                color: Colors.white,
                                size: 12,
                              ),
                            ))
                        .toList(),
                  ),
                  Text("预计 2024.08.20 发售"),
                ],
              ),
            ],
          )),
          InfoRow(
            Wrap(
              children: [
                Tag("动作"),
                Tag("冒险"),
                Tag("角色扮演"),
                Tag("奇幻"),
                Tag("动作"),
                Tag("冒险"),
                Tag("角色扮演"),
                Tag("奇幻"),
                Tag("动作"),
                Tag("冒险"),
                Tag("角色扮演"),
                Tag("奇幻"),
              ],
            ),
          ),
        ],
      ),
      MarkdownBody(data: """## 关于这款游戏

《黑神话：悟空》是一款以中国神话为背景的动作角色扮演游戏。故事取材于中国古典小说“四大名著”之一的《西游记》。你将扮演一位“天命人”，为了探寻昔日传说的真相，踏上一条充满危险与惊奇的西游之路。

![](https://media.st.dl.eccdnx.com/steam/apps/2358720/extras/SteamGIF_Scene.gif?t=1702002024)

### 雄奇壮丽，光怪陆离

别有世间曾未见，一行一步一花新。欢迎来到亦真亦幻的东方魔幻世界！天命人将前往多个引人入胜又风格迥异的西游故地，再次谱写前所未见的冒险史诗。

![](https://media.st.dl.eccdnx.com/steam/apps/2358720/extras/SteamGIF_Boss.gif?t=1702002024)

### 妖魔鬼怪，卷土重来

行者名声大，魔王手段强。《西游记》的一大看点，便是各有所长的厉害妖怪。西行的旅途并非只有风光旖旎，天命人还将遭遇许多强大的敌人与可敬的对手，与他们豪快战斗，至死方休。

![](https://media.st.dl.eccdnx.com/steam/apps/2358720/extras/SteamGIF_Battle.gif?t=1702002024)

### 山摇地动，各显神通

炼就长生多少法，学来变化广无边。五光十色又相生相克的法术、变化与法宝，一直都是中国神话中最为招牌的战斗要素。天命人除了精通不同棍术，更可自由搭配多样化的法术、变化、天赋、武器与披挂，找到最契合自身战斗风格的制胜之道。

![](https://media.st.dl.eccdnx.com/steam/apps/2358720/extras/SteamGIF_NPC.gif?t=1702002024)

### 千形万象，荡气回肠

六般体相六般兵，六样形骸六样情。敌人的凶恶狡猾只是表象，他们的来历、个性与动机，往往更加耐人寻味。天命人在战斗之外，也会探寻各色人物背后的故事，了解他们的爱与恨，贪与嗔，前世与今生。

## 成人内容描述

开发者对内容描述如下：

此游戏包含的内容可能不适合所有年龄段，或不宜在工作期间访问：频繁出现暴力或血腥, 常见成人内容
"""),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("黑神话：悟空"),
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
      ),
      body: Stack(
        children: [
          Image(
            image: const AssetImage("assets/cover.jpg"),
            fit: BoxFit.cover,
            width: 1.sw,
            height: 128.r,
          ),
          ListView(
            children: [
              Container(
                height: 128.r - 8.r,
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.r),
                  topLeft: Radius.circular(8.r),
                ),
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  height: 8.r,
                ),
              ),
              ContentRow(
                Padding(
                  padding: EdgeInsets.only(
                    top: 12.r,
                    bottom: 12.r - 8.r,
                  ),
                  child: Text(
                    "黑神话：悟空",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              ContentRow(
                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.r,
                      horizontal: 18.r,
                    ),
                    child: Text(
                      "距离游戏发售还有 100 天",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
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
                    ),
                    child: tabs[tabIndex],
                  ),
                ),
                bottom: 0,
              ),
            ],
          ),
          // ListView(children: []),
        ],
      ),
    );
  }
}
