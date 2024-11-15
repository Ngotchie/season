import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api/booking/api_booking.dart';
import 'package:Season/models/booking/model_booking.dart';
import '../methods.dart';

class CancellationWidget extends StatefulWidget {
  const CancellationWidget({Key? key}) : super(key: key);

  @override
  State<CancellationWidget> createState() => _CancellationWidgetState();
}

class _CancellationWidgetState extends State<CancellationWidget> {
  bool visibility = false;
  TextEditingController searchController = new TextEditingController();
  String filter = "";
  int _year = 0;
  List<int> years = <int>[];
  final apiBooking = new ApiBooking();

  Future<List<Cancellation>> cancellationBooking(year) {
    return apiBooking.cancellation(year);
  }

  void initState() {
    int currentYear = int.parse(DateFormat('yyyy').format(DateTime.now()));
    _year = currentYear;
    for (var i = 2020; i <= currentYear; i++) {
      years.add(i);
    }
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
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  iconSize: 25,
                  color: Colors.indigo[900],
                  icon: Icon(Icons.search),
                  onPressed: () {
                    visibility ? visibility = false : visibility = true;
                    setState(() {});
                  },
                ),
                Spacer(),
                Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 10, top: 5, right: 10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 226, 207, 38),
                          const Color.fromARGB(255, 255, 112, 68),
                          const Color.fromARGB(255, 64, 151, 251)
                          //add more colors
                        ]),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Color.fromRGBO(
                                  0, 0, 0, 0.57), //shadow for button
                              blurRadius: 5) //blur radius of shadow
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<int>(
                        focusColor: Colors.white,
                        value: _year,
                        //elevation: 5,
                        style: TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.white,
                        items: years.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "choose a year",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _year = value as int;
                          });
                        },
                        underline: Container(),
                        dropdownColor: Color.fromARGB(255, 221, 215, 215),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
                future: cancellationBooking(_year),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: Text("Loading..."),
                      ),
                    );
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.67,
                      child: Column(
                        children: [
                          visibility
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
                                        hintText: 'Search cancellation',
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
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
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
                                            snapshot.data[i].withPenalty
                                                .toString()
                                                .toLowerCase()
                                                .contains(filter) ||
                                            snapshot.data[i].internalName
                                                .toString()
                                                .toLowerCase()
                                                .contains(filter)
                                        ? GestureDetector(
                                            onTap: () {
                                              methods.showBookingCancellation(
                                                  context, snapshot.data[i]);
                                            },
                                            child: Container(
                                                height: 130,
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
                                                child: Row(
                                                  children: [
                                                    RotatedBox(
                                                      quarterTurns: 3,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 10),
                                                        child: Text(
                                                          snapshot.data[i]
                                                                  .withPenalty
                                                              ? "With Penalty"
                                                              : "No Penalty",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            backgroundColor:
                                                                snapshot.data[i]
                                                                        .withPenalty
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .teal,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Flexible(
                                                              child: Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Container(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                          "Canceled on: "),
                                                                      Text(
                                                                          DateFormat.MMMd('en_US').format(DateTime.parse(snapshot
                                                                              .data[
                                                                                  i]
                                                                              .date)),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12)),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 50),
                                                                Container(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                          "Check-in: "),
                                                                      Text(
                                                                          DateFormat.MMMd('en_US').format(DateTime.parse(snapshot
                                                                              .data[
                                                                                  i]
                                                                              .checkin)),
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12)),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                              child: Text(
                                                                  snapshot
                                                                          .data[
                                                                              i]
                                                                          .referer +
                                                                      " (" +
                                                                      snapshot
                                                                          .data[
                                                                              i]
                                                                          .internalName +
                                                                      ")",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          RichText(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              text: TextSpan(
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Montserrat',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18,
                                                                      color: Colors
                                                                          .black),
                                                                  text: snapshot
                                                                          .data[
                                                                              i]
                                                                          .guestFirstName +
                                                                      " " +
                                                                      snapshot
                                                                          .data[
                                                                              i]
                                                                          .guestName)),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Flexible(
                                                              child: Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Container(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                          "Price: "),
                                                                      Text(
                                                                          snapshot.data[i].price +
                                                                              "" +
                                                                              snapshot.data[i].currency,
                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 30),
                                                                Container(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                          "Commission: "),
                                                                      Text(
                                                                          snapshot.data[i].commission +
                                                                              "" +
                                                                              snapshot.data[i].currency,
                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          )
                                        : Container();
                                  }))
                        ],
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
