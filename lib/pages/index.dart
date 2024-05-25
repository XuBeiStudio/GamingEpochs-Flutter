import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gaming_epochs/constants.dart';
import 'package:gaming_epochs/pages/settings.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../components/game_card.dart';
import '../pigeons/calendar.dart';
import '../utils/http_utils.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<StatefulWidget> createState() => _IndexPage();
}

class _IndexPage extends State<IndexPage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 350),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, 0.1),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  late List<MapEntry<String, List<GamesIndex>>> gamesIndexes;
  ScrollController scrollController = ScrollController();
  bool showToTopBtn = false;

  late SharedPreferences? prefs;

  late Future<List<MapEntry<String, List<GamesIndex>>>> future;

  final DateFormat monthFormat = DateFormat("yyyy.MM");

  Future<void> updateCalendar(List<GamesIndex> indexes) async {
    if (!(prefs?.getBool(PrefKeys.enableCalendar)??false)) {
      return;
    }

    var ids = prefs!.getStringList(PrefKeys.cachedEvents) ?? [];
    List<GamesIndex> taskIndexes = [];

    for (var index in indexes) {
      if (!ids.contains(index.id)) {
        taskIndexes.add(index);
        ids.add(index.id!);
      }
    }

    if (taskIndexes.isEmpty) {
      return;
    }

    var status = await Permission.calendarFullAccess.request();
    if (!(status.isGranted || status.isProvisional)) {
      return;
    }

    void Function(String) update = (String msg) {};
    SmartDialog.config.loading = SmartConfigLoading(
      leastLoadingTime: const Duration(seconds: 1),
    );
    SmartDialog.showLoading(
      builder: (context) {
        return LoadingDialog(
          title: "数据更新中",
          info: "0%",
          update: (f) => update = f,
        );
      },
    );

    var api = CalendarApi();
    var calId = await api.getOrCreateAccount();

    double total = taskIndexes.length.toDouble();
    double current = 0;

    for (var index in taskIndexes) {
      await api.addEvent(
        calId,
        GameCalendarInfo(
          id: index.id!,
          name: index.title,
          releaseDate: index.releaseDate,
          platforms: index.platforms,
        ),
      );
      current++;
      update
          .call("${(current * 1000 / total).round().toDouble() / 10}%");
    }
    await prefs?.setStringList(PrefKeys.cachedEvents, ids);

    // 关闭进度Modal
    SmartDialog.dismiss();
    SmartDialog.config.loading = SmartConfigLoading();
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) => setState(() {
      this.prefs = prefs;
    }));

    scrollController.addListener(() {
      if (scrollController.offset < 500 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
          _controller.reverse();
        });
      } else if (scrollController.offset >= 500 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
          _controller.forward();
        });
      }
    });

    gamesIndexes = [];

    future = Future(() async {
      var data = await getIndexes();

      Map<String, List<GamesIndex>> map = {};

      for (var element in data) {
        if (element.releaseDate == null) {
          continue;
        }
        var month = element.releaseDate!.substring(0, 7);
        map.update(month, (list) {
          list.add(element);
          return list;
        }, ifAbsent: () => List.of([element]));
      }

      var list = map.entries.toList();
      list.sort((a, b) => b.key.compareTo(a.key));

      for (var e in list) {
        e.value
            .sort((a, b) => b.releaseDate?.compareTo(a.releaseDate ?? "") ?? 0);
      }

      var offset = 0.0;
      var thisMonth = monthFormat.format(DateTime.now());

      for (var e in list) {
        if (!e.key.startsWith(thisMonth)) {
          offset += 72 + 4.r * 2 + e.value.length * (4.r * 2 + 180);
        } else {
          break;
        }
      }

      setState(() {
        gamesIndexes = list;
      });

      scrollController.jumpTo(offset);

      updateCalendar(data).then((_){});

      return list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              FutureBuilder(
                future: future,
                builder: (BuildContext context, AsyncSnapshot<List<MapEntry<String, List<GamesIndex>>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.r),
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.r),
                        child: Text("${snapshot.error}"),
                      ),
                    );
                  }

                  return Container();
                },
              ),
              ...gamesIndexes
                  .map((monthGroup) => StickyHeader(
                // key: Key('header-$index'),
                header: MonthHeader(
                  month: monthGroup.key,
                ),
                content: Padding(
                  padding: EdgeInsets.only(
                    top: 4.r,
                    bottom: 4.r,
                  ),
                  child: Column(
                    children: monthGroup.value
                        .map((g) => GestureDetector(
                      onTap: () {
                        context.push('/game/${g.id}');
                      },
                      child: GameCard(
                        game: g,
                      ),
                    ))
                        .toList(),
                  ),
                ),
              )),
            ],
          ),
        ),
        FadeTransition(
          opacity: _animation,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 12.r,
                  bottom: 12.r,
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    scrollController.animateTo(0,
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut);
                  },
                  child: const Icon(Icons.vertical_align_top),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
