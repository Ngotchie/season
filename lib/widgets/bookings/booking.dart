import 'package:flutter/material.dart';
import 'package:Season/api/booking/api_booking.dart';
import 'package:Season/models/booking/model_booking.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../methods.dart';

class BookingWidget extends StatefulWidget {
  const BookingWidget({Key? key}) : super(key: key);
  @override
  _BookingWidgetState createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget>
    with TickerProviderStateMixin {
  final apiBooking = new ApiBooking();
  String _selectedDate = '';
  String _dateCount = '';
  String _range = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(const Duration(days: 15))) +
      ' => ' +
      DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 15)));
  String _rangeCount = '';
  bool visibility = false;
  bool visibility2 = false;
  String label = ""; //new DateFormat.yMMMMd('en_US').format(DateTime.now());
  int checkin = 0;
  int checkout = 0;
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('yyyy-MM-dd').format(args.value.startDate)} =>'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
        label = _label(_range);
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
        label = _selectedDate;
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  String _label(range) {
    var split = _range.split("=>");
    if (split[0].replaceAll(' ', '') == split[1].replaceAll(' ', '')) {
      label = DateFormat.yMMMMd('en_US')
          .format(DateTime.parse(split[0].replaceAll(' ', '')));
    } else {
      label = DateFormat.yMMMMd('en_US')
              .format(DateTime.parse(split[0].replaceAll(' ', ''))) +
          "=>" +
          DateFormat.yMMMMd('en_US')
              .format(DateTime.parse(split[1].replaceAll(' ', '')));
    }
    return label;
  }

  Future<List<Booking>> getBooking(range) {
    return apiBooking.getBookings(range);
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
    label = _label(_range);
    final methods = Methods();
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              // alignment: Alignment.centerRight,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  iconSize: 25,
                  color: Colors.indigo[900],
                  icon: Icon(Icons.search),
                  onPressed: () {
                    visibility2 ? visibility2 = false : visibility2 = true;
                    setState(() {});
                  },
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color(0xFFFBD107),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 45,
                  height: 40,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 4),
                    color: Colors.indigo[900],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    iconSize: 15,
                    icon: Icon(Icons.calendar_today_outlined),
                    onPressed: () {
                      visibility ? visibility = false : visibility = true;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
            ),
            visibility
                ? SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(
                        DateTime.now().subtract(const Duration(days: 4)),
                        DateTime.now().add(const Duration(days: 3))),
                  )
                : FutureBuilder(
                    future: getBooking(_range),
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
                          child: Column(
                            children: [
                              visibility2
                                  ? Container(
                                      height: 50,
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
                                                    BorderRadius.circular(
                                                        32.0)),
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
                                        // if(snapshot.data[i] == ){

                                        // }else{

                                        // }
                                        String status = "";
                                        switch (snapshot.data[i].status) {
                                          case 0:
                                            status = "Cancelled";
                                            break;
                                          case 1:
                                            status = "Confirmed";
                                            break;
                                          case 2:
                                            status = "New";
                                            break;
                                          case 3:
                                            status = "Request";
                                            break;
                                          case 4:
                                            status = "Black";
                                            break;
                                          default:
                                            status = "";
                                        }
                                        int diff = DateTime.parse(
                                                snapshot.data[i].lastNight)
                                            .difference(DateTime.parse(
                                                snapshot.data[i].firstNight))
                                            .inDays;
                                        var start = _range
                                            .split("=>")[0]
                                            .replaceAll(' ', '');
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
                                                  methods.showBooking(context,
                                                      snapshot.data[i]);
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Flexible(
                                                        child: Container(
                                                          child: Text(
                                                            status +
                                                                " (" +
                                                                snapshot.data[i]
                                                                    .paymentStatus +
                                                                ") ",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                              child: Row(
                                                                  children: [
                                                            Text(DateFormat.MMMd(
                                                                        'en_US')
                                                                    .format(DateTime.parse(snapshot
                                                                        .data[i]
                                                                        .firstNight)) +
                                                                "  -  "),
                                                            Text(DateFormat('MM').format(DateTime.parse(snapshot.data[i].firstNight)) ==
                                                                    DateFormat('MM').format(DateTime.parse(snapshot
                                                                        .data[i]
                                                                        .lastNight))
                                                                ? DateFormat('d').format(
                                                                    DateTime.parse(snapshot
                                                                        .data[i]
                                                                        .lastNight))
                                                                : DateFormat.MMMd('en_US').format(
                                                                    DateTime.parse(snapshot
                                                                        .data[i]
                                                                        .lastNight))),
                                                            Text(" (" +
                                                                diff.toString() +
                                                                " nights)")
                                                          ]))),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        child: RichText(
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
                                                                snapshot.data[i]
                                                                    .price
                                                                    .toString() +
                                                                " " +
                                                                snapshot.data[i]
                                                                    .currency,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                                                            FontStyle.italic),
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
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    launch("tel://" +
                                                                        snapshot
                                                                            .data[i]
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
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    String url = "https://wa.me/" +
                                                                        snapshot
                                                                            .data[i]
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
                            ],
                          ),
                        );
                      }
                    }),
          ],
        ),
      ),
    );
  }

// 0 = Cancelled
  // 1 = Confirmed
  // 2 = New (same as confirmed but unread)
  // 3 = Request
  // 4 = Black
  Widget _status(status) {
    if (status == 0) {
      return Container(
        width: 60,
        child: Text("Cancelled",
            style: TextStyle(fontSize: 10, color: Colors.white)),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.redAccent[100],
          borderRadius: BorderRadius.circular(10),
        ),
      );
    } else if (status == 1) {
      return Container(
        width: 65,
        child: Text(
          "Confirmed",
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    } else if (status == 2) {
      return Container(
        width: 60,
        child: Text(
          "New",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.greenAccent[200],
          borderRadius: BorderRadius.circular(10),
        ),
      );
    } else if (status == 3) {
      return Container(
        width: 60,
        child: Text(
          "Request",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    } else {
      return Container(
        width: 60,
        child: Text("Black",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.white)),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }
  }

  Widget _statusPay(status) {
    if (status == "paid") {
      return Container(
        width: 60,
        child: Text("Paid",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.white)),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    } else if (status == "unpaid") {
      return Container(
        width: 60,
        child: Text(
          "Unpaid",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.redAccent[100],
          borderRadius: BorderRadius.circular(10),
        ),
      );
    } else {
      return Container(
        width: 60,
        child: Text("Overdraft",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.white)),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }
  }
}

/*
child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Flexible(
                                                              child: Container(
                                                                  child: Center(
                                                            child: _status(
                                                                snapshot.data[i]
                                                                    .status),
                                                          ))),
                                                          Flexible(
                                                              child: Container(
                                                                  child: Center(
                                                            child: _statusPay(
                                                                snapshot.data[i]
                                                                    .paymentStatus),
                                                          )))
                                                        ],
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        fit: FlexFit.tight,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Center(
                                                                child: RichText(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    strutStyle: StrutStyle(
                                                                        fontSize:
                                                                            15.0),
                                                                    text: TextSpan(
                                                                        text: snapshot.data[i].referer +
                                                                            " (" +
                                                                            snapshot
                                                                                .data[
                                                                                    i]
                                                                                .accommodation +
                                                                            ")",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold))),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Center(
                                                                child:
                                                                    Container(
                                                                  child: RichText(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      text: TextSpan(
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .black),
                                                                          text: snapshot.data[i].guestFirstName +
                                                                              " " +
                                                                              snapshot.data[i].guestName)),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                        "Check-in: " +
                                                                            DateFormat('dd-MM-yyyy').format(DateTime.parse(snapshot
                                                                                .data[
                                                                                    i]
                                                                                .firstNight)),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.white)),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      color: Colors
                                                                              .green[
                                                                          200],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                        "Check-out: " +
                                                                            DateFormat('dd-MM-yyyy').format(DateTime.parse(snapshot
                                                                                .data[
                                                                                    i]
                                                                                .lastNight)),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.white)),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      color: Colors
                                                                              .red[
                                                                          200],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              0),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),*/