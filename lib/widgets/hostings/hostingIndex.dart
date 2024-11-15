import 'package:flutter/material.dart';
import 'package:Season/widgets/contract/contract.dart';
import 'package:Season/widgets/partner/partner.dart';

import '../../appBar.dart';
import '../../drawer.dart';

class HostingIndexWidget extends StatefulWidget {
  const HostingIndexWidget({Key? key, required this.user}) : super(key: key);
  final user;

  @override
  _HostingIndexWidgetState createState() => _HostingIndexWidgetState();
}

class _HostingIndexWidgetState extends State<HostingIndexWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar("Hostings", context, 1, widget.user),
        drawer: drawer(widget.user, context),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.people_alt_outlined,
                      color: Colors.white,
                    ),
                    label: Text('Partners',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14.0)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFF8B1FA9)), //0xFFd1b690
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  PartnerWidget(user: widget.user)));
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.book_online, color: Colors.white),
                    label: Text('Contracts',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14.0)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFF54bf31)), //0xFFd49f55
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ContractWidget(user: widget.user)));
                    },
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
