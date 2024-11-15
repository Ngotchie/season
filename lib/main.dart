import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Season/homeBottomMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login/login.dart';
import 'package:background_fetch/background_fetch.dart';

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  var taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  // Do your work here...
  BackgroundFetch.finish(taskId);
}

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // navigation bar color
    statusBarColor: Color(0xff04994b6), // status bar color
  ));
  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const MaterialColor blue = const MaterialColor(
      0xFF05A8CF,
      const <int, Color>{
        50: const Color(0xFF05A8CF),
        100: const Color(0xFF05A8CF),
        200: const Color(0xFF05A8CF),
        300: const Color(0xFF05A8CF),
        400: const Color(0xFF05A8CF),
        500: const Color(0xFF05A8CF),
        600: const Color(0xFF05A8CF),
        700: const Color(0xFF05A8CF),
        800: const Color(0xFF05A8CF),
        900: const Color(0xFF05A8CF),
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Season: Mobile',
      theme: ThemeData(primarySwatch: blue, fontFamily: 'Montserrat'),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => MyLoginPage(),
        '/finance': (context) => HomeBottomMenu(index: 2),
        '/hostings': (context) => HomeBottomMenu(index: 4),
        '/accommodation': (context) => HomeBottomMenu(index: 0),
        '/operation': (context) => HomeBottomMenu(index: 1),
        '/marketing-review': (context) => HomeBottomMenu(index: 5),
        '/booking': (context) => HomeBottomMenu(index: 3),
      },
      //home: MyLoginPage(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String currentEmail = "";
  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  getData() async {}

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentEmail = prefs.getString('email') ?? "";
    });
    if (currentEmail != "") {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (_) => MyHomePage(index: 0)));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => HomeBottomMenu(
                    index: 0,
                  )));
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
    //initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/season-intranet.png",
          width: 200,
        ),
      ),
    );
  }

  // bool _enabled = true;
  // int _status = 0;
  // List<DateTime> _events = [];
  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   // Configure BackgroundFetch.
  //   int status = await BackgroundFetch.configure(
  //       BackgroundFetchConfig(
  //           minimumFetchInterval: 15,
  //           stopOnTerminate: false,
  //           enableHeadless: true,
  //           requiresBatteryNotLow: false,
  //           requiresCharging: false,
  //           requiresStorageNotLow: false,
  //           requiresDeviceIdle: false,
  //           requiredNetworkType: NetworkType.NONE), (String taskId) async {
  //     // <-- Event handler
  //     // This is the fetch-event callback.
  //     print("[BackgroundFetch] Event received $taskId");
  //     setState(() {
  //       _events.insert(0, new DateTime.now());
  //     });
  //     // IMPORTANT:  You must signal completion of your task or the OS can punish your app
  //     // for taking too long in the background.
  //     BackgroundFetch.finish(taskId);
  //   }, (String taskId) async {
  //     // <-- Task timeout handler.
  //     // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
  //     print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
  //     BackgroundFetch.finish(taskId);
  //   });
  //   print('[BackgroundFetch] configure success: $status');
  //   setState(() {
  //     _status = status;
  //   });

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  // }
}
