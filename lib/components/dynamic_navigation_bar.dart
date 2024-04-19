import 'package:flutter/material.dart';
import 'package:gaming_epochs/theme.dart';

enum ScreenSize {
  small,
  medium,
  large,
}

class Destination {
  const Destination(this.title, this.icon, this.widget);

  final String title;
  final Icon icon;
  final Widget widget;
}

class DynamicNavigationBar extends StatefulWidget {
  final List<Destination> destinations;

  const DynamicNavigationBar({super.key, required this.destinations});

  @override
  State<DynamicNavigationBar> createState() => _DynamicNavigationBarState();

}

class _DynamicNavigationBarState extends State<DynamicNavigationBar> {
  int currentPageIndex = 0;

  late ScreenSize screenSize;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);
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

  void onDestinationSelected(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    setState(() {
      currentPageIndex = index;
    });
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
        selectedIndex: currentPageIndex,
        onDestinationSelected: onDestinationSelected,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: widget.destinations
            .map((e) => NavigationDestination(icon: e.icon, label: e.title))
            .toList(),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: widget.destinations.map((e) => e.widget).toList(),
      ),
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
                  selectedIndex: currentPageIndex,
                  useIndicator: true,
                  onDestinationSelected: onDestinationSelected,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: widget.destinations.map((e) => e.widget).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
