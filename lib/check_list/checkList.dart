import 'package:flutter/material.dart';

class CheckList extends StatefulWidget {
  const CheckList({Key? key}) : super(key: key);

  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              AppBar(
                title: Text("CHECK LIST"),
                leading: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.check,
                  ),
                ),
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Icon(Icons.more_vert),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
