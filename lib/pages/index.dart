import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../components/game_card.dart';

class IndexPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return StickyHeader(
            // key: Key('header-$index'),
            header: MonthHeader(),
            content: Padding(
              padding: EdgeInsets.only(
                top: 8,
                bottom: 8,
              ),
              child: Column(
                children: List.generate(5, (index) {
                  return GameCard();
                }),
              ),
            ),
          );
        },
      ),
    );
  }

}