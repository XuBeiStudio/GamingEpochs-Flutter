import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../components/game_card.dart';
import '../utils/http_utils.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<StatefulWidget> createState() => _IndexPage();
}

class _IndexPage extends State<IndexPage> {
  late List<MapEntry<String, List<GamesIndex>>> gamesIndexes;

  @override
  void initState() {
    super.initState();

    gamesIndexes = [];

    getIndexes().then((data) {
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

      setState(() {
        gamesIndexes = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    //   child: ListView.builder(
    //     padding: EdgeInsets.zero,
    //     itemBuilder: (context, index) {
    //       return StickyHeader(
    //         // key: Key('header-$index'),
    //         header: MonthHeader(),
    //         content: Padding(
    //           padding: EdgeInsets.only(
    //             top: 8,
    //             bottom: 8,
    //           ),
    //           child: Column(
    //             children: List.generate(5, (index) {
    //               return GestureDetector(
    //                 onTap: () {
    //                   context.push('/game/233');
    //                 },
    //                 child: GameCard(),
    //               );
    //             }),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ListView(
        padding: EdgeInsets.zero,
        children: gamesIndexes
            .map((monthGroup) => StickyHeader(
                  // key: Key('header-$index'),
                  header: MonthHeader(
                    month: monthGroup.key,
                  ),
                  content: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                    ),
                    child: Column(
                      children: monthGroup.value
                          .map((g) => GestureDetector(
                                onTap: () {
                                  context.push('/game/${g.id}');
                                },
                                child: GameCard(game: g,),
                              ))
                          .toList(),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
