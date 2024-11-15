import 'package:flutter/material.dart';
import 'package:Season/widgets/bookings/calendar.dart';

import '../../api/accommodation/api_accommodation.dart';

class BookingAccommodationWidget extends StatefulWidget {
  const BookingAccommodationWidget({Key? key}) : super(key: key);
  @override
  State<BookingAccommodationWidget> createState() =>
      _BookingAccommodationWidgetState();
}

class _BookingAccommodationWidgetState
    extends State<BookingAccommodationWidget> {
  final apiAcc = ApiAccommodation();

  Future<dynamic> callApiListAcc() {
    return apiAcc.getAccommodations();
  }

  TextEditingController searchController = new TextEditingController();
  String filter = "";

  void initState() {
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: callApiListAcc(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            } else {
              return Container(
                margin: EdgeInsets.only(top: 5),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Padding(
                          padding: new EdgeInsets.all(8.0),
                          child: new TextField(
                            onChanged: (value) {
                              setState(() {
                                filter = value.toLowerCase();
                              });
                            },
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search accommodation',
                              contentPadding:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                          ),
                        ),
                      ),
                      Wrap(
                        children: [
                          for (var i = 0; i < snapshot.data.length; i++)
                            if (snapshot.data[i].status == 'exploiting')
                              snapshot.data[i].externalName
                                          .toString()
                                          .toLowerCase()
                                          .contains(filter) ||
                                      snapshot.data[i].internalName
                                          .toString()
                                          .toLowerCase()
                                          .contains(filter)
                                  ? card(snapshot.data[i])
                                  : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget card(accommodation) {
    return Card(
      shadowColor: Colors.black,
      color: Colors.grey[350],
      child: SizedBox(
        width: 155,
        height: 170,
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.home) //CircleAvatar
                  ), //CircleAvatar
              SizedBox(
                height: 1,
              ), //SizedBox
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: accommodation.internalName,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat')), //Textstyle
              ), //Text
              SizedBox(
                height: 5,
              ),
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: accommodation.externalName,
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat')), //Textstyle
              ), ////SizedBox//Text
              SizedBox(
                height: 5,
              ), //SizedBox
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BookingCalendarWidget(
                                  accommodation: accommodation.internalName,
                                )));
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF05A8CF))),
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: Colors.white,
                          size: 14,
                        ),
                        Text(
                          'View bookings',
                          style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      ],
                    ), //Row
                  ), //Padding
                ), //RaisedButton
              ) //SizedBox
            ],
          ), //Column
        ), //Padding
      ), //SizedBox
    );
  }
}
