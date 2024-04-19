import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'components/dynamic_navigation_bar.dart';
import 'components/game_card.dart';
import 'pages/index.dart';
import 'pages/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData buildTheme(Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 21, 123, 174), brightness: brightness),
      fontFamily: 'MiSans',
      useMaterial3: true,
      brightness: brightness,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          home: child,
        );
      },
      child: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DynamicNavigationBar(
      destinations: [
        Destination(
          '首页',
          const Icon(Icons.home),
          IndexPage(),
        ),
        Destination(
          '设置',
          const Icon(Icons.settings),
          SettingsPage(),
        ),
      ],
    );
  }
}
