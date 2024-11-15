import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:Season/widgets/cash_transactions/cashTransaction.dart';
import 'widgets/operations/operation.dart';
import 'widgets/accommodations/accomodation.dart';
import 'check_list/checkList.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.index}) : super(key: key);

  final int index;
  //final LoginResponse user;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _extendRail = false;

  PageController pageController = PageController();
  void setExtended(bool isExtend) {
    setState(() => _extendRail = isExtend);
  }

  initState() {
    super.initState();
    _selectedIndex = this.widget.index;
    pageController = PageController(initialPage: _selectedIndex);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            MouseRegion(
              cursor: SystemMouseCursors.basic,
              opaque: true,
              onEnter: (_) => setExtended(true),
              onExit: (_) => setExtended(false),
              child: NavigationRail(
                leading: Center(
                    child: Image.asset("assets/icons/season-intranet.png")),
                // trailing: Icon(Icons.view_comfy),
                selectedIndex: _selectedIndex,
                extended: _extendRail,
                onDestinationSelected: (int index) {
                  setState(() {
                    pageController.animateToPage(index,
                        duration: Duration(microseconds: 250),
                        curve: Curves.ease);
                    _selectedIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.none,
                destinations: const <NavigationRailDestination>[
                  // NavigationRailDestination(
                  //   icon: Icon(Icons.dashboard),
                  //   selectedIcon: Icon(Icons.dashboard_rounded),
                  //   label: Text('Dashboard'),
                  // ),
                  NavigationRailDestination(
                    icon: Icon(Icons.assignment),
                    selectedIcon: Icon(Icons.assignment),
                    label: Text('Operations'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.euro),
                    selectedIcon: Icon(Icons.euro),
                    label: Text('Cash Transaction'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Accommodations'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.check_circle),
                    selectedIcon: Icon(Icons.check),
                    label: Text('Check List'),
                  ),
                ],
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            // This is the main content.
            Expanded(
                child: PageView(
              controller: pageController,
              children: [
                // Container(
                //   child: Dashboard(),
                // ),
                Container(
                  child: Operation(user: ""),
                ),
                Container(
                  child: CashTransactionWidget(
                    user: "",
                  ),
                ),
                Container(
                  child: Accomodation(
                    user: "",
                  ),
                ),
                Container(
                  child: CheckList(),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class ExtendNavigation extends StatelessWidget {
  const ExtendNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation =
        NavigationRail.extendedAnimation(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        // The extended fab has a shorter height than the regular fab.
        return Container(
          height: 56,
          padding: EdgeInsets.symmetric(
            vertical: lerpDouble(0, 6, animation.value)!,
          ),
          child: animation.value == 0
              ? FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {},
                )
              : Align(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: animation.value,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: FloatingActionButton.extended(
                      icon: const Icon(Icons.add),
                      label: const Text('CREATE'),
                      onPressed: () {},
                    ),
                  ),
                ),
        );
      },
    );
  }
}
