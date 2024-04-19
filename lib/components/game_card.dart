import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme.dart';
import '../icons.dart';

class GameCard extends StatelessWidget {
  const GameCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              height: 180,
              constraints: const BoxConstraints(
                maxWidth: 540,
              ),
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  children: [
                    // 封面图
                    Image(
                      image: const AssetImage("assets/cover.jpg"),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 720.w,
                    ),
                    // Logo
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            child: const Image(
                              image: AssetImage("assets/logo.png"),
                              fit: BoxFit.contain,
                              width: 96,
                              height: 96,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // 黑色渐变
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [
                              0.0,
                              1.0
                            ],
                            colors: [
                              Color.fromRGBO(0, 0, 0, 0),
                              Color.fromRGBO(0, 0, 0, 0.2)
                            ]),
                      ),
                    ),
                    // 游戏名称
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "黑神话：悟空",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeights.semiBold,
                              fontSize: 18,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.75),
                                  offset: const Offset(1, 1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Black Myth: Wukong",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeights.medium,
                              fontSize: 14,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.75),
                                  offset: const Offset(1, 1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 发售时间、平台
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 18,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "2024.08.20",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeights.semiBold,
                                  fontSize: 16,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.75),
                                      offset: const Offset(1, 1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 4,
                              ),
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1.5),
                                          child: Icon(
                                            e,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // 会员免费
                    Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 128,
                                color: const Color.fromARGB(255, 16, 124, 16),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    "Xbox Game Pass",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeights.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 128,
                                color: const Color.fromARGB(255, 0, 67, 156),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    "PlayStation Plus",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeights.normal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MonthHeader extends StatelessWidget {
  const MonthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var text = Text(
      "2024.08",
      textAlign: TextAlign.right,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeights.bold,
        fontSize: 48,
      ),
    );

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [
                0.0,
                1.0,
              ],
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withOpacity(0.6),
              ],
            ),
          ),
          child: InkWell(
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    width: 540,
                    constraints: const BoxConstraints(
                      maxWidth: 540,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: text,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
