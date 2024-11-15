import 'package:flutter/material.dart';
import 'package:Season/api/booking/api_booking.dart';
import 'package:Season/models/booking/model_booking.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../methods.dart';

class OngoingWidget extends StatefulWidget {
  const OngoingWidget({Key? key}) : super(key: key);

  @override
  _OngoingWidgetState createState() => _OngoingWidgetState();
}

class _OngoingWidgetState extends State<OngoingWidget> {
  final apiBooking = new ApiBooking();

  Future<List<Booking>> ongoingBooking() {
    return apiBooking.ongoingBookings();
  }

  bool visibility2 = false;
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
    final methods = Methods();
    return SingleChildScrollView(
        child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    iconSize: 25,
                    color: Colors.indigo[900],
                    icon: Icon(Icons.search),
                    onPressed: () {
                      visibility2 ? visibility2 = false : visibility2 = true;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                FutureBuilder(
                    future: ongoingBooking(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Container(
                          child: Center(
                            child: Text("Loading..."),
                          ),
                        );
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Column(children: [
                            visibility2
                                ? Container(
                                    height: 50,
                                    margin: EdgeInsets.only(bottom: 5),
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
                                          hintText: 'Search booking',
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10.0, 10.0, 10.0, 10.0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0)),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, i) {
                                      var label = "Ongoing Stay";
                                      int day = DateTime.parse(
                                              snapshot.data[i].lastNight)
                                          .difference(DateTime.parse(
                                              DateFormat('yyyy-MM-dd')
                                                  .format(DateTime.now())))
                                          .inDays;
                                      int day2 = DateTime.parse(
                                              snapshot.data[i].firstNight)
                                          .difference(DateTime.parse(
                                              DateFormat('yyyy-MM-dd')
                                                  .format(DateTime.now())))
                                          .inDays;
                                      int diff = DateTime.parse(
                                              snapshot.data[i].lastNight)
                                          .difference(DateTime.parse(
                                              snapshot.data[i].firstNight))
                                          .inDays;
                                      if (day == 1)
                                        label = "Check-Out tomorrow";
                                      if (day == 0) label = "Check-Out today";
                                      if (day2 == 0) label = "Check-In today";
                                      return snapshot.data[i].referer
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(filter) ||
                                              snapshot.data[i].guestFirstName
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(filter) ||
                                              snapshot.data[i].guestName
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(filter) ||
                                              snapshot.data[i].accommodation
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(filter)
                                          ? GestureDetector(
                                              onTap: () {
                                                methods.showBooking(
                                                    context, snapshot.data[i]);
                                              },
                                              child: Container(
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 0.5),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          5.0) //         <--- border radius here
                                                      ),
                                                ),
                                                margin: EdgeInsets.all(8),
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: Container(
                                                        child: Text(
                                                          label +
                                                              " (" +
                                                              snapshot.data[i]
                                                                  .paymentStatus +
                                                              ") ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        child: Text(snapshot
                                                                .data[i]
                                                                .referer +
                                                            " (" +
                                                            snapshot.data[i]
                                                                .accommodation +
                                                            ")"),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Flexible(
                                                        child: Container(
                                                            child:
                                                                Row(children: [
                                                      Text(DateFormat.MMMd(
                                                                  'en_US')
                                                              .format(DateTime
                                                                  .parse(snapshot
                                                                      .data[i]
                                                                      .firstNight)) +
                                                          "  -  "),
                                                      Text(DateFormat('MM').format(DateTime.parse(snapshot.data[i].firstNight)) ==
                                                              DateFormat('MM').format(
                                                                  DateTime.parse(snapshot
                                                                      .data[i]
                                                                      .lastNight))
                                                          ? DateFormat('d').format(
                                                              DateTime.parse(snapshot
                                                                  .data[i]
                                                                  .lastNight))
                                                          : DateFormat.MMMd('en_US')
                                                              .format(DateTime.parse(
                                                                  snapshot.data[i].lastNight))),
                                                      Text(" (" +
                                                          diff.toString() +
                                                          " nights)")
                                                    ]))),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      child: RichText(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          text: TextSpan(
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .black),
                                                              text: snapshot
                                                                      .data[i]
                                                                      .guestFirstName +
                                                                  " " +
                                                                  snapshot
                                                                      .data[i]
                                                                      .guestName)),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        child: Text(
                                                          "Estimated Income: " +
                                                              snapshot
                                                                  .data[i].price
                                                                  .toString() +
                                                              " " +
                                                              snapshot.data[i]
                                                                  .currency,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        snapshot.data[i]
                                                                    .phone !=
                                                                ""
                                                            ? Flexible(
                                                                flex: 4,
                                                                child: Text(
                                                                  snapshot
                                                                      .data[i]
                                                                      .phone,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              )
                                                            : Container(
                                                                child: Text(
                                                                  "Number not provided",
                                                                  style: TextStyle(
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                                ),
                                                              ),
                                                        if (snapshot.data[i]
                                                                .country !=
                                                            "")
                                                          Flexible(
                                                            flex: 3,
                                                            child: RichText(
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                text: TextSpan(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .grey),
                                                                    text: " (" +
                                                                        snapshot
                                                                            .data[i]
                                                                            .country +
                                                                        ")")),
                                                          ),
                                                        if (snapshot.data[i]
                                                                .phone !=
                                                            "")
                                                          Flexible(
                                                            child: Container(
                                                              height: 30,
                                                              width: 150,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                          .greenAccent[
                                                                      200],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  launch("tel://" +
                                                                      snapshot
                                                                          .data[
                                                                              i]
                                                                          .phone);
                                                                },
                                                                child: Icon(
                                                                  Icons.phone,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        if (snapshot.data[i]
                                                                .phone !=
                                                            "")
                                                          Flexible(
                                                            child: Container(
                                                              height: 30,
                                                              width: 150,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  String url = "https://wa.me/" +
                                                                      snapshot
                                                                          .data[
                                                                              i]
                                                                          .phone +
                                                                      "/?text=";
                                                                  launch(url);
                                                                },
                                                                child: Icon(
                                                                  Icons.chat,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20.0,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container();
                                    }))
                          ]),
                        );
                      }
                    })
              ],
            )));
  }
}
