import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gaming_epochs/pages/game_info.dart';
import 'package:go_router/go_router.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'components/dynamic_navigation_bar.dart';
import 'components/game_card.dart';
import 'pages/index.dart';
import 'pages/settings.dart';

void main() {
  runApp(const MyApp());
}

final destinations = [
  const Destination(
    '首页',
    Icon(Icons.home),
    'index',
  ),
  const Destination(
    '设置',
    Icon(Icons.settings),
    'settings',
  ),
];

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_,__) => '/index',
    ),
    ShellRoute(
      routes: [
        GoRoute(
          name: 'index',
          path: '/index',
          builder: (context, state) => IndexPage(),
        ),
        GoRoute(
          name: 'settings',
          path: '/settings',
          builder: (context, state) => SettingsPage(),
        ),
      ],
      builder: (context, state, page) {
        return DynamicNavigationBar(
          body: page,
          destinations: destinations,
          currentPage: destinations.indexed.where((e) => e.$2.name == state.topRoute?.name).firstOrNull?.$1 ?? 0,
          onPageSelected: (index) {
            context.goNamed(destinations[index].name);
          },
        );
      },
    ),
    GoRoute(
      name: 'game_info',
      path: '/game/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']??'unknown';
        return GameInfoPage(id: id);
      },
    ),
  ],
);

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
        // return MaterialApp(
        //   title: 'Flutter Demo',
        //   theme: buildTheme(Brightness.light),
        //   darkTheme: buildTheme(Brightness.dark),
        //   home: child,
        // );

        // return MaterialApp(
        //   theme: buildTheme(Brightness.light),
        //   darkTheme: buildTheme(Brightness.dark),
        //   home: MaterialApp.router(
        //     routerConfig: _router,
        //   ),
        // );

        return MaterialApp.router(
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          routerConfig: _router,
        );
      },
      // child: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int currentPageIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//
//     return DynamicNavigationBar(
//       destinations: [
//         Destination(
//           '首页',
//           const Icon(Icons.home),
//         ),
//         Destination(
//           '设置',
//           const Icon(Icons.settings),
//         ),
//       ],
//     );
//   }
// }

// class IndexPage extends StatefulWidget {
//   final List<Destination> destinations;
//
//   const IndexPage({super.key, required this.destinations});
//
//   @override
//   State<IndexPage> createState() => _IndexPageState();
//
// }
//
// class _IndexPageState extends State<IndexPage> {
//   int currentPageIndex = 0;
//
//   late ScreenSize screenSize;
//   late PageController _pageController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _pageController = PageController(initialPage: 0);
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     var width = MediaQuery.of(context).size.width;
//     if (width < 720) {
//       screenSize = ScreenSize.small;
//     } else if (width < 1024) {
//       screenSize = ScreenSize.medium;
//     } else {
//       screenSize = ScreenSize.large;
//     }
//   }
//
//   void onDestinationSelected(int index) {
//     _pageController.animateToPage(
//       index,
//       duration: const Duration(milliseconds: 250),
//       curve: Curves.easeInOut,
//     );
//     setState(() {
//       currentPageIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DynamicNavigationBar(
//       body: PageView(
//         controller: _pageController,
//         physics: const NeverScrollableScrollPhysics(),
//         children: widget.destinations.map((e) => e.widget).toList(),
//       ),
//     );
//   }
//
// }
