import 'package:flutter/material.dart';
import 'package:Season/api/booking/api_booking.dart';
import 'package:Season/models/booking/model_booking.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../methods.dart';

class NewBookingWidget extends StatefulWidget {
  const NewBookingWidget({Key? key}) : super(key: key);

  @override
  State<NewBookingWidget> createState() => _NewBookingWidgetState();
}

class _NewBookingWidgetState extends State<NewBookingWidget> {
  final apiBooking = new ApiBooking();
  bool visibility2 = false;
  int _page = 0;
  int _limit = 30;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  List<Booking> bookings = [];

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final res = apiBooking.newBookings(_page, _limit);
      res.then((List<Booking> data) {
        setState(() {
          bookings = data;
        });
      });
    } catch (err) {
      print('Something went wrong');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 50) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        final res = apiBooking.newBookings(_page, _limit);
        res.then((List<Booking> data) {
          if (data.length > 0) {
            setState(() {
              bookings.addAll(data);
            });
          } else {
            setState(() {
              _hasNextPage = false;
            });
          }
        });
      } catch (err) {
        print('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  late ScrollController _controller;

  TextEditingController searchController = new TextEditingController();
  String filter = "";

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    _firstLoad();
    _controller = new ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final methods = Methods();
    return SingleChildScrollView(
        child: Container(
            color: Colors.white,
            child: Column(children: [
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
              Container(
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
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  _isFirstLoadRunning
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: ListView.builder(
                              controller: _controller,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: bookings.length,
                              itemBuilder: (context, i) {
                                String status = "";
                                switch (bookings[i].status) {
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
                                int diff = DateTime.parse(bookings[i].lastNight)
                                    .difference(
                                        DateTime.parse(bookings[i].firstNight))
                                    .inDays;
                                return bookings[i]
                                            .referer
                                            .toString()
                                            .toLowerCase()
                                            .contains(filter) ||
                                        bookings[i]
                                            .guestFirstName
                                            .toString()
                                            .toLowerCase()
                                            .contains(filter) ||
                                        bookings[i]
                                            .guestName
                                            .toString()
                                            .toLowerCase()
                                            .contains(filter) ||
                                        bookings[i]
                                            .accommodation
                                            .toString()
                                            .toLowerCase()
                                            .contains(filter)
                                    ? GestureDetector(
                                        onTap: () {
                                          methods.showBooking(
                                              context, bookings[i]);
                                        },
                                        child: Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
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
                                                      child: Row(children: [
                                                Text(
                                                  status +
                                                      "( " +
                                                      bookings[i]
                                                          .paymentStatus +
                                                      ")",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "Booked At: ",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Text(
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(DateTime.parse(
                                                          bookings[i]
                                                              .bookedAt)),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ]))),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Flexible(
                                                child: Container(
                                                  child: Text(
                                                      bookings[i].referer +
                                                          " (" +
                                                          bookings[i]
                                                              .accommodation +
                                                          ")"),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Flexible(
                                                  child: Container(
                                                      child: Row(children: [
                                                Text(DateFormat.MMMd('en_US')
                                                        .format(DateTime.parse(
                                                            bookings[i]
                                                                .firstNight)) +
                                                    "  -  "),
                                                Text(DateFormat('MM').format(DateTime.parse(bookings[i].firstNight)) ==
                                                        DateFormat('MM').format(
                                                            DateTime.parse(bookings[i]
                                                                .lastNight))
                                                    ? DateFormat('d').format(
                                                        DateTime.parse(bookings[i]
                                                            .lastNight))
                                                    : DateFormat.MMMd('en_US')
                                                        .format(DateTime.parse(
                                                            bookings[i].lastNight))),
                                                Text(" (" +
                                                    diff.toString() +
                                                    " nights)"),
                                                if (bookings[i].arrivalTime !=
                                                    "")
                                                  Spacer(),
                                                if (bookings[i].arrivalTime !=
                                                    "")
                                                  Text(
                                                    "Arrival time : " +
                                                        (bookings[i]
                                                                .arrivalTime)
                                                            .substring(
                                                                0,
                                                                bookings[i]
                                                                        .arrivalTime
                                                                        .length -
                                                                    3),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                              ]))),
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
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                            color:
                                                                Colors.black),
                                                        text: bookings[i]
                                                                .guestFirstName +
                                                            " " +
                                                            bookings[i]
                                                                .guestName)),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Flexible(
                                                child: Container(
                                                  child: Text(
                                                    "Estimated Income: " +
                                                        bookings[i]
                                                            .price
                                                            .toString() +
                                                        " " +
                                                        bookings[i].currency,
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
                                                  bookings[i].phone != ""
                                                      ? Flexible(
                                                          flex: 4,
                                                          child: Text(
                                                            bookings[i].phone,
                                                            style: TextStyle(
                                                                fontSize: 15,
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
                                                  if (bookings[i].country != "")
                                                    Flexible(
                                                      flex: 3,
                                                      child: RichText(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          text: TextSpan(
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .grey),
                                                              text: " (" +
                                                                  bookings[i]
                                                                      .country +
                                                                  ")")),
                                                    ),
                                                  if (bookings[i].phone != "")
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
                                                                bookings[i]
                                                                    .phone);
                                                          },
                                                          child: Icon(
                                                            Icons.phone,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  if (bookings[i].phone != "")
                                                    Flexible(
                                                      child: Container(
                                                        height: 30,
                                                        width: 150,
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: TextButton(
                                                          onPressed: () {
                                                            String url =
                                                                "https://wa.me/" +
                                                                    bookings[i]
                                                                        .phone +
                                                                    "/?text=";
                                                            launch(url);
                                                          },
                                                          child: Icon(
                                                            Icons.chat,
                                                            color: Colors.white,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container();
                              })),
                  SizedBox(
                    height: 20,
                  ),

                  if (_isLoadMoreRunning == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),

                  // When nothing else to load
                  if (_hasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 40),
                      color: Colors.amber,
                      child: Center(
                        child: Text('You have fetched all of the content'),
                      ),
                    ),
                ]),
              )
            ])));
  }
}
