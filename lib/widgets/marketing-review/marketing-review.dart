import 'package:flutter/material.dart';
import 'package:Season/widgets/marketing-review/revenue.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../drawer.dart';
import '../../login/login.dart';
import 'occupacy-rate.dart';

class MarketingReviewWidget extends StatefulWidget {
  const MarketingReviewWidget({Key? key, required this.user}) : super(key: key);
  final user;
  @override
  State<MarketingReviewWidget> createState() => _MarketingReviewWidgetState();
}

class _MarketingReviewWidgetState extends State<MarketingReviewWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          drawer: drawer(widget.user, context),
          appBar: AppBar(
            actionsIconTheme: IconThemeData(color: Colors.white),
            backgroundColor: const Color(0xFF05A8CF),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            title: Row(
              children: [
                Text(
                  "MARKETING REVIEW",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            actions: <Widget>[
              PopupMenuButton(
                itemBuilder: (BuildContext bc) => [
                  PopupMenuItem(child: Text("Logout"), value: "/logout"),
                ],
                onSelected: (route) async {
                  // Note You must create respective pages for navigation
                  if (route == "/logout") {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('user');
                    prefs.remove('email');
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => MyLoginPage()));
                  }
                },
              ),
            ],
            bottom: TabBar(
              labelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 14),
              tabs: <Widget>[
                Tab(
                  child: Text('Occupacy Rate'),
                ),
                Tab(
                  child: Text('Revenue'),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              OccupacyRateWidget(),
              RevenueWidget(),
            ],
          ),
        ));
  }
}
