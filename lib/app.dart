import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gaming_epochs/constants.dart';
import 'package:gaming_epochs/models/primary_color_model.dart';
import 'package:gaming_epochs/pages/game_info.dart';
import 'package:gaming_epochs/pigeons/jpush.dart';
import 'package:gaming_epochs/utils/platform_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/dynamic_navigation_bar.dart';
import 'pages/index.dart';
import 'pages/settings.dart';

final destinations = [
  const Destination('首页', Icon(Icons.home), 'index', '/index'),
  const Destination(
    '设置',
    Icon(Icons.settings),
    'settings',
    '/settings',
  ),
];

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// A dialog page with Material entrance and exit animations, modal barrier color,
/// and modal barrier behavior (dialog is dismissible with a tap on the barrier).
class DialogPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
      context: context,
      settings: this,
      builder: builder,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      themes: themes);
}

final _router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/index',
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      routes: [
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          name: 'index',
          path: '/index',
          builder: (context, state) => IndexPage(),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          name: 'settings',
          path: '/settings',
          builder: (context, state) => SettingsPage(),
          routes: [
            GoRoute(
              path: 'primary_color',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return DialogPage(
                    builder: (_) => const SettingsPrimaryColorDialogPage());
              },
            ),
            GoRoute(
              path: 'dev_team',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return DialogPage(
                    builder: (_) => const SettingsDevTeamDialogPage());
              },
            ),
          ],
        ),
      ],
      builder: (context, state, page) {
        return DynamicNavigationBar(
          body: page,
          destinations: destinations,
          currentPage: destinations.indexed
                  .where((e) =>
                      e.$2.name == state.topRoute?.name ||
                      (state.fullPath?.startsWith(e.$2.path) ?? false))
                  .firstOrNull
                  ?.$1 ??
              0,
          onPageSelected: (index) {
            context.goNamed(destinations[index].name);
          },
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: 'game_info',
      path: '/game/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'unknown';
        return GameInfoPage(id: id);
      },
    ),
  ],
  observers: [
    BotToastNavigatorObserver(),
    FlutterSmartDialog.observer,
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return const StatefulApp();
      },
    );
  }
}

class StatefulApp extends StatefulWidget {
  const StatefulApp({super.key});

  @override
  State<StatefulWidget> createState() => _StatefulApp();
}

class _StatefulApp extends State<StatefulApp> {
  late SharedPreferences? prefs;

  final botToastBuilder = BotToastInit();

  @override
  void initState() {
    super.initState();

    prefs = null;

    SharedPreferences.getInstance().then((prefs) async {
      setState(() {
        this.prefs = prefs;
      });

      if (PlatformUtils.isAndroid) {
        var jpush = JPushApi();
        await jpush.setDebug(true);
        await jpush.setAuth(prefs.getBool(PrefKeys.enablePush) == true);
        await jpush.init();
      }
    });
  }

  ThemeData buildTheme(Brightness brightness, Color primaryColor) {
    return ThemeData(
      colorScheme:
          ColorScheme.fromSeed(seedColor: primaryColor, brightness: brightness),
      fontFamily: 'MiSans',
      useMaterial3: true,
      brightness: brightness,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: PrimaryColorModel(
        Color(prefs?.getInt(PrefKeys.primaryColor) ?? 0xff157bae),
      ),
      child: ScopedModelDescendant<PrimaryColorModel>(
        builder: (context, child, model) => MaterialApp.router(
          theme: buildTheme(Brightness.light, model.primaryColor),
          darkTheme: buildTheme(Brightness.dark, model.primaryColor),
          routerConfig: _router,
          builder: FlutterSmartDialog.init(
            builder: (context, child) {
              child = botToastBuilder(context, child);
              return child;
            },
            loadingBuilder: (text) {
              return LoadingDialog(title: text);
            },
          ),
        ),
      ),
    );
  }
}
