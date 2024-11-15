import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/login.dart';

PreferredSizeWidget? appBar(title, context, position, user) {
  return AppBar(
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
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
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
          title,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    ),
    // titleSpacing: 0,
    actions: <Widget>[
      PopupMenuButton(
        itemBuilder: (BuildContext bc) => [
          PopupMenuItem(child: Text("Logout"), value: "/logout"),
        ],
        onSelected: (route) async {
          // Note You must create respective pages for navigation
          if (route == "/logout") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('user');
            prefs.remove('email');
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => MyLoginPage()));
          }
        },
      ),
    ],
  );
}
