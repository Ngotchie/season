import 'package:flutter/material.dart';
import 'package:Season/login/login.dart';
import 'package:Season/widgets/bookings/booking.dart';
import 'package:Season/widgets/bookings/bookingAccommodation.dart';
import 'package:Season/widgets/bookings/new.dart';
import 'package:Season/widgets/bookings/onGoing.dart';
import 'package:Season/widgets/bookings/workflow.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../drawer.dart';
import 'cancellation.dart';

class IndexBookingWidget extends StatefulWidget {
  const IndexBookingWidget({Key? key, required this.user, required this.page})
      : super(key: key);
  final user;
  final page;
  @override
  _IndexBookingWidgetState createState() => _IndexBookingWidgetState();
}

class _IndexBookingWidgetState extends State<IndexBookingWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: widget.page,
        length: 6,
        child: Scaffold(
          drawer: drawer(widget.user, context),
          appBar: AppBar(
            backgroundColor: const Color(0xFF05A8CF),
            actionsIconTheme: IconThemeData(color: Colors.white),
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
            // GestureDetector(
            //   onTap: () {},
            //   child: Icon(Icons.menu_rounded),
            // ),
            title: Row(
              children: [
                Text(
                  "BOOKINGS",
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
              isScrollable: true,
              labelStyle: TextStyle(fontSize: 14),
              tabs: <Widget>[
                Tab(
                  child: Text('On going'),
                ),
                // Tab(
                //   child: Text('Future'),
                // ),
                Tab(
                  child: Text('New'),
                ),
                Tab(
                  child: Text('All'),
                ),
                Tab(
                  child: Text('Calendar'),
                ),
                Tab(
                  child: Text('Cancellation'),
                ),
                Tab(
                  child: Text('Workflow'),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              OngoingWidget(),
              // FutureWidget(),
              NewBookingWidget(),
              BookingWidget(),
              BookingAccommodationWidget(),
              CancellationWidget(),
              WorkflowWidget(),
            ],
          ),
        ));
  }
}
