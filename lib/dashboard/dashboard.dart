import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login/login.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text("DASHBOARD"),
              leading: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.dashboard,
                ),
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MyLoginPage(
                              )));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
