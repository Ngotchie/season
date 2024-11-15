import 'package:flutter/material.dart';
import 'package:Season/appBar.dart';
import 'package:Season/drawer.dart';
import 'calendarWidget.dart';

class Operation extends StatefulWidget {
  const Operation({Key? key, required this.user}) : super(key: key);
  final user;
  @override
  _OperationState createState() => _OperationState();
}

class _OperationState extends State<Operation> {
  @override
  Widget build(BuildContext context) {
    // print(widget.user);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: appBar("OPERATIONS", context, 1, null),
        drawer: drawer(widget.user, context),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[CalendarWidget()],
            ),
          ),
        ),
      ),
    );
  }
}
