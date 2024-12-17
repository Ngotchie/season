import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'widgets/agent_booklet.dart';

Widget drawer(user, context) {
  return Drawer(
    elevation: 10.0,
    child: ListView(
      children: <Widget>[
        Container(
          height: 110,
          child: DrawerHeader(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(color: Color(0xFF05A8CF)),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                      // NetworkImage(
                      //     'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                      radius: 40.0,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16.0),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                user.email,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14.0),
              ),
            ]),
          ),
        ),
        // if (user.role[0] == "admin" ||
        //     user.permissions.contains("view accommodations listing"))
        ListTile(
          leading: Icon(Icons.home_sharp),
          title: Text('Accommodations', style: TextStyle(fontSize: 18)),
          onTap: () {
            Navigator.pushNamed(context, '/accommodation');
          },
        ),
        Divider(height: 3.0),
        if (user.role[0] == "admin" ||
            user.permissions.contains("consult operations"))
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Operations', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushNamed(context, '/operation');
            },
          ),
        Divider(height: 3.0),
        if (user.role[0] == "admin" ||
            user.permissions.contains("view cash transactions listing"))
          ListTile(
            leading: Icon(Icons.euro),
            title: Text('Finance', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushNamed(context, '/finance');
            },
          ),
        Divider(height: 3.0),
        if (user.role[0] == "admin" ||
            user.permissions.contains("view bookings listing"))
          ListTile(
            leading: Icon(Icons.ballot_outlined),
            title: Text('Bookings', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushNamed(context, '/booking');
            },
          ),
        Divider(height: 3.0),
        if (user.role[0] == "admin" ||
            user.permissions.contains("view partners listing"))
          ListTile(
            leading: Icon(Icons.home_work),
            title: Text('Hostings', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushNamed(context, '/hostigns');
            },
          ),
        Divider(height: 3.0),
        if (user.role[0] == "admin" ||
            user.permissions.contains("view marketing-review"))
          ListTile(
            leading: Icon(Icons.document_scanner_outlined),
            title: Text('Marketing Review', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushNamed(context, '/marketing-review');
            },
          ),
        Divider(height: 3.0),
        ListTile(
          leading: Icon(Icons.paste),
          title: Text('Agent Welcome Booklet', style: TextStyle(fontSize: 18)),
          onTap: () async {
            const url = "https://chic-aparts.com/agent_booklet.pdf";
            final file = await loadPdfFromNetwork(url);
            openPdf(context, file, url);
          },
        ),
        // Divider(height: 3.0),
        // ListTile(
        //   leading: Icon(Icons.settings),
        //   title: Text('Settings', style: TextStyle(fontSize: 18)),
        //   onTap: () {
        //     // Here you can give your route to navigate
        //   },
        // ),
      ],
    ),
  );
}

Future<File> loadPdfFromNetwork(String url) async {
  final response = await http.get(Uri.parse(url));
  final bytes = response.bodyBytes;
  return _storeFile(url, bytes);
}

Future<File> _storeFile(String url, List<int> bytes) async {
  final filename = basename(url);
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes, flush: true);
  if (kDebugMode) {
    print('$file');
  }
  return file;
}

void openPdf(BuildContext context, File file, String url) =>
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AgentBookletWidget(
          file: file,
          url: url,
        ),
      ),
    );
