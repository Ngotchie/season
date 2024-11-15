import 'package:flutter/material.dart';
import 'package:Season/models/booking/model_booking.dart';
import 'package:Season/widgets/bookings/workflowSteps.dart';

import '../../api/booking/api_booking.dart';
import 'package:intl/intl.dart';

class WorkflowWidget extends StatefulWidget {
  const WorkflowWidget({Key? key}) : super(key: key);

  @override
  State<WorkflowWidget> createState() => _WorkflowWidgetState();
}

class _WorkflowWidgetState extends State<WorkflowWidget> {
  final apiBooking = new ApiBooking();
  bool visibility2 = false;

  Future<List<Workflow>> workflowBooking() {
    return apiBooking.getWorkflow();
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

  bool isSwitched = false;
  var textValue = 'Show all';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Only New bookings';
      });
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Show all';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Align(
                    child: Row(children: [
                  Switch(
                    onChanged: toggleSwitch,
                    value: isSwitched,
                    activeColor: Color(0xFF54bf31),
                    activeTrackColor: Color(0xFF636363),
                    inactiveThumbColor: Colors.blue,
                    inactiveTrackColor: Color(0xFF636363),
                  ),
                  Text(
                    '$textValue',
                    style: TextStyle(fontSize: 14),
                  )
                ])),
              ),
              Spacer(),
              Align(
                child: IconButton(
                  iconSize: 25,
                  color: Colors.indigo[900],
                  icon: Icon(Icons.search),
                  onPressed: () {
                    visibility2 ? visibility2 = false : visibility2 = true;
                    setState(() {});
                  },
                ),
              )
            ],
          ),
          SizedBox(
            height: 2,
          ),
          FutureBuilder(
              future: workflowBooking(),
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
                                int diff =
                                    DateTime.parse(snapshot.data[i].lastNight)
                                        .difference(DateTime.parse(
                                            snapshot.data[i].firstNight))
                                        .inDays;
                                if (isSwitched &&
                                    snapshot.data[i].bookingStatus ==
                                        'Confirmed') {
                                  return Container();
                                }
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
                                        snapshot.data[i].internalName
                                            .toString()
                                            .toLowerCase()
                                            .contains(filter)
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => WorkflowStepsWidget(
                                                      booking: snapshot.data[i].referer +
                                                          ' (' +
                                                          snapshot.data[i]
                                                              .guestFirstName +
                                                          " " +
                                                          snapshot.data[i]
                                                              .guestName +
                                                          ') from ' +
                                                          DateFormat('dd-MM-yyyy')
                                                              .format(DateTime.parse(
                                                                  snapshot
                                                                      .data[i]
                                                                      .firstNight)) +
                                                          ' to ' +
                                                          DateFormat('dd-MM-yyyy')
                                                              .format(DateTime.parse(
                                                                  snapshot
                                                                      .data[i]
                                                                      .lastNight)),
                                                      bookingId: snapshot
                                                          .data[i].bookingId)));
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
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                    child: Text(
                                                      snapshot.data[i]
                                                              .bookingStatus +
                                                          ' (' +
                                                          snapshot
                                                              .data[i].bookId
                                                              .toString() +
                                                          ')',
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
                                                            .data[i].referer +
                                                        " (" +
                                                        snapshot.data[i]
                                                            .internalName +
                                                        ")"),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  child: RichText(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: TextSpan(
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Montserrat',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.black),
                                                          text: snapshot.data[i]
                                                                  .guestFirstName +
                                                              " " +
                                                              snapshot.data[i]
                                                                  .guestName)),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Flexible(
                                                    child: Container(
                                                        child: Row(children: [
                                                  Text(
                                                    "From: ",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  Text(
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(DateTime.parse(
                                                            snapshot.data[i]
                                                                .firstNight)),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    "To: ",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  Text(
                                                    DateFormat('dd-MM-yyyy')
                                                            .format(DateTime
                                                                .parse(snapshot
                                                                    .data[i]
                                                                    .firstNight)) +
                                                        ' (' +
                                                        diff.toString() +
                                                        ' nights)',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ]))),
                                              ],
                                            )),
                                      )
                                    : Container();
                              }),
                        )
                      ]));
                }
              })
        ],
      ),
    );
  }
}
