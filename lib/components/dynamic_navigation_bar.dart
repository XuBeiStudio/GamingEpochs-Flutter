import 'package:flutter/material.dart';
import 'package:gaming_epochs/theme.dart';

enum ScreenSize {
  small,
  medium,
  large,
}

class Destination {
  const Destination(this.title, this.icon, this.name);

  final String title;
  final Icon icon;
  final String name;
}

class DynamicNavigationBar extends StatefulWidget {
  final Widget body;
  final List<Destination> destinations;
  final int currentPage;
  final Function(int) onPageSelected;

  const DynamicNavigationBar({super.key, required this.body, required this.destinations, required this.onPageSelected, required this.currentPage});

  @override
  State<DynamicNavigationBar> createState() => _DynamicNavigationBarState();

}

class _DynamicNavigationBarState extends State<DynamicNavigationBar> {

  late ScreenSize screenSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var width = MediaQuery.of(context).size.width;
    if (width < 720) {
      screenSize = ScreenSize.small;
    } else if (width < 1024) {
      screenSize = ScreenSize.medium;
    } else {
      screenSize = ScreenSize.large;
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (screenSize) {
      case ScreenSize.small:
        return buildSmallPageNavigationBar();
      case ScreenSize.medium:
      case ScreenSize.large:
        return buildMediumPageNavigationBar();
    }
  }

  Widget buildSmallPageNavigationBar() {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.currentPage,
        onDestinationSelected: widget.onPageSelected,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: widget.destinations
            .map((e) => NavigationDestination(icon: e.icon, label: e.title))
            .toList(),
      ),
      body: widget.body,
    );
  }

  Widget buildMediumPageNavigationBar() {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          children: [
            Container(
              color: Theme.of(context).cardColorWithElevation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: NavigationRail(
                  leading: const Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        '游历年轴',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  extended: true,
                  backgroundColor: Theme.of(context).cardColorWithElevation,
                  // minWidth: 50,
                  destinations: widget.destinations
                      .map((e) => NavigationRailDestination(icon: e.icon, label: Text(e.title)))
                      .toList(),
                  selectedIndex: widget.currentPage,
                  useIndicator: true,
                  onDestinationSelected: widget.onPageSelected,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  widget.body,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
