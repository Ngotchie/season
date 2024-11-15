import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Season/models/booking/model_booking.dart';

import '../../api/booking/api_booking.dart';

class WorkflowStepsWidget extends StatefulWidget {
  const WorkflowStepsWidget(
      {Key? key, required this.booking, required this.bookingId})
      : super(key: key);
  final String booking;
  final int bookingId;

  @override
  State<WorkflowStepsWidget> createState() => _WorkflowStepsWidgetState();
}

class _WorkflowStepsWidgetState extends State<WorkflowStepsWidget> {
  final apiBooking = new ApiBooking();

  Future<List<WorkflowStep>> workflowSteps(id) {
    return apiBooking.getWorkflowSteps(id);
  }

  Future<int> sendWorkflowUpdate(id, status, comment) {
    return apiBooking.sendWorkflowUpdate(id, status, comment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFF05A8CF),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamed(context, '/booking',
                      arguments: {'page': 5});
                }),
            title: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Booking Workflow Steps"),
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: TextSpan(
                          text: widget.booking,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color(0xFF636363))),
                    ),
                  ]),
            )),
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            children: [
              FutureBuilder(
                  future: workflowSteps(widget.bookingId),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(
                          child: Text("Loading..."),
                        ),
                      );
                    } else {
                      return snapshot.data.length > 0
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, i) {
                                            return Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                                  child: ExpansionTileCard(
                                                    baseColor: Colors.grey[100],
                                                    title: RichText(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        text: TextSpan(
                                                          text: snapshot
                                                              .data[i].name,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      22,
                                                                      21,
                                                                      21),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                    subtitle: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10),
                                                      child: Row(children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    224,
                                                                    223,
                                                                    223),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: RichText(
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: allWordsCapitilize(snapshot
                                                                        .data[i]
                                                                        .status),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            12,
                                                                        color: Color(
                                                                            0xFF636363)),
                                                                    recognizer:
                                                                        TapGestureRecognizer()
                                                                          ..onTap =
                                                                              () {
                                                                            stepValidation(
                                                                                context,
                                                                                snapshot.data[i].id,
                                                                                snapshot.data[i].status,
                                                                                snapshot.data[i].comment);
                                                                          },
                                                                  )
                                                                ]),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        snapshot.data[i]
                                                                    .hasAlert ==
                                                                true
                                                            ? Icon(
                                                                Icons
                                                                    .notifications,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        189,
                                                                        187,
                                                                        187),
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .notifications_off,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        189,
                                                                        187,
                                                                        187)),
                                                      ]),
                                                    ),
                                                    children: [
                                                      Divider(
                                                          color: Colors.black),
                                                      snapshot.data[i].comment
                                                                  .data !=
                                                              ""
                                                          ? Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              margin: EdgeInsets
                                                                  .all(5),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        235,
                                                                        233,
                                                                        233),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Comment: ',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  snapshot
                                                                      .data[i]
                                                                      .comment,
                                                                  SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                ],
                                                              ))
                                                          : Container(),
                                                      snapshot
                                                                      .data[i]
                                                                      .shortDescription
                                                                      .data !=
                                                                  "" &&
                                                              snapshot.data[i]
                                                                      .longDescription !=
                                                                  ""
                                                          ? Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              margin: EdgeInsets
                                                                  .all(5),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        235,
                                                                        233,
                                                                        233),
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      'Step description: ',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  snapshot
                                                                      .data[i]
                                                                      .shortDescription,
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  snapshot
                                                                      .data[i]
                                                                      .longDescription,
                                                                ],
                                                              ),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ));
                                          })),
                                ],
                              ),
                            )
                          : Center(
                              child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text("Nothing to display")));
                    }
                  })
            ],
          ),
        )));
  }

  stepValidation(context, id, currentStatus, comment) {
    var _comment;
    String? status = currentStatus;
    var statusList = [
      'pending',
      'in progress',
      'completed',
      'failed',
      'not applicable'
    ];
    if (comment.data != "") {
      _comment = TextEditingController(text: comment.data);
    } else {
      _comment = TextEditingController();
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update step"),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.29,
              child: Column(
                children: [
                  DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: "Choose status...",
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    value: status,
                    items: statusList.map<DropdownMenuItem<String>>((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(
                          allWordsCapitilize(status),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        status = newValue as String;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Status plan can\'t be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _comment,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: 15,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Comment..."),
                  )
                ],
              ),
            ),
            actions: [
              Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  child: new Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    postWorkflowUpdateStep(id, status, _comment.text);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }

  postWorkflowUpdateStep(id, status, comment) async {
    var response = await sendWorkflowUpdate(id, status, comment);
    if (response == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update succefully')),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during update')),
      );
    }
  }

  String allWordsCapitilize(String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }
}
