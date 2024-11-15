import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Season/api/booking/api_booking.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Methods {
  Widget label(label) {
    return Flexible(
        child: Text(
      label,
      style: TextStyle(fontSize: 12, color: Colors.grey),
    ));
  }

  Widget element(elt) {
    return Flexible(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            elt,
          ),
        ));
  }

  Widget elementText(elt) {
    return Flexible(
        flex: 2,
        child: Padding(padding: const EdgeInsets.all(8.0), child: elt));
  }

  Widget elementHyperLink(elt) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new RichText(
          text: new TextSpan(
            text: elt.toString(),
            style: new TextStyle(color: Colors.blue),
            recognizer: new TapGestureRecognizer()
              ..onTap = () async {
                final url = Uri.encodeFull(elt);
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false,
                  );
                }
              },
          ),
        ),
      ),
    );
  }

  Widget elementAdresseMap(elt) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new RichText(
          text: new TextSpan(
            text: elt,
            style: new TextStyle(color: Colors.blue),
            recognizer: new TapGestureRecognizer()
              ..onTap = () async {
                String googleUrl =
                    "https://www.google.com/maps/search/?api=1&query=$elt";
                final url = Uri.encodeFull(googleUrl);
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: true,
                  );
                }
              },
          ),
        ),
      ),
    );
  }

  String toAvatar(String input) {
    List<String> splitStr = input.split(' ');
    if (splitStr.length >= 2) {
      for (int i = 0; i < 2; i++) {
        splitStr[i] = splitStr[i].substring(0, 1);
      }

      splitStr.removeRange(2, splitStr.length);
    }
    if (splitStr.length == 1) {
      try {
        splitStr[0] = splitStr[0].substring(0, 2);
      } catch (e) {
        splitStr[0] = splitStr[0].substring(0, 1);
      }
    }

    if (splitStr.length == 0) {
      splitStr[0] = "P";
    }

    final output = splitStr.join('');

    return output;
  }

  showBooking(context, booking) {
    final apiBook = ApiBooking();
    Future<dynamic> callApiBooking(id) {
      return apiBook.getOneBooking(id);
    }

    Future<dynamic> getBookingMessages(propId, bookingId) {
      return apiBook.getMessages(propId, bookingId);
    }

    final methods = Methods();
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder(
                          future: callApiBooking(booking.id),
                          builder: (context, AsyncSnapshot snap) {
                            if (snap.data == null) {
                              return Container(
                                child: Center(
                                  child: Text("Loading..."),
                                ),
                              );
                            } else {
                              var book = snap.data;
                              return Column(
                                children: [
                                  ExpansionTile(
                                    title: Text("Channel Reference",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    children: [
                                      Row(children: <Widget>[
                                        methods.label("Referer: "),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        methods.element(booking.referer),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Booking ID: "),
                                        methods.element(book.bookId.toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text("Booking Details",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    children: [
                                      Row(children: <Widget>[
                                        methods.label("Booked At: "),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        methods.element(DateFormat('dd-MM-yyyy')
                                            .format(
                                                DateTime.parse(book.bookedAt))),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Check-In: "),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        methods.element(DateFormat('dd-MM-yyyy')
                                            .format(DateTime.parse(
                                                book.firstNight))),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Check-Out: "),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        methods.element(DateFormat('dd-MM-yyyy')
                                            .format(
                                                DateTime.parse(book.lastNight)
                                                    .add(Duration(days: 1)))),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Adults: "),
                                        SizedBox(
                                          width: 28,
                                        ),
                                        methods.element(book.adult.toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Children: "),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        methods.element(book.child.toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Arrival Time: "),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        methods.element(book.arriveTime),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text("Guest Details",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    children: [
                                      if (book.title != "")
                                        Row(children: <Widget>[
                                          methods.label("Title: "),
                                          SizedBox(
                                            width: 25,
                                          ),
                                          methods.element(book.title),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.guestFirstName != "")
                                        Row(children: <Widget>[
                                          methods.label("First Name: "),
                                          SizedBox(
                                            width: 0,
                                          ),
                                          methods.element(book.guestFirstName),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.guestName != "")
                                        Row(children: <Widget>[
                                          methods.label("Last Name: "),
                                          SizedBox(
                                            width: 0,
                                          ),
                                          methods.element(book.guestName),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.email != "")
                                        Row(children: <Widget>[
                                          methods.label("Email: "),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          methods.element(book.email),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.phone != "")
                                        Row(children: <Widget>[
                                          methods.label("Phone: "),
                                          SizedBox(
                                            width: 25,
                                          ),
                                          methods.element(book.phone),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.mobile != "")
                                        Row(children: <Widget>[
                                          methods.label("Mobile: "),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          methods.element(book.mobile),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.fax != "")
                                        Row(children: <Widget>[
                                          methods.label("Fax: "),
                                          SizedBox(
                                            width: 45,
                                          ),
                                          methods.element(book.fax),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.compagny != "")
                                        Row(children: <Widget>[
                                          methods.label("Compagny: "),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          methods.element(book.compagny),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.address != "")
                                        Row(children: <Widget>[
                                          methods.label("Address: "),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          methods.element(book.address),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.city != "")
                                        Row(children: <Widget>[
                                          methods.label("City: "),
                                          SizedBox(
                                            width: 45,
                                          ),
                                          methods.element(book.city),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.state != "")
                                        Row(children: <Widget>[
                                          methods.label("State: "),
                                          SizedBox(
                                            width: 35,
                                          ),
                                          methods.element(book.state),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.postCode != "")
                                        Row(children: <Widget>[
                                          methods.label("Post Code: "),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          methods.element(book.postCode),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.country != "")
                                        Row(children: <Widget>[
                                          methods.label("Country: "),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          methods.element(book.country),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                      if (book.comment != Text(" "))
                                        Row(children: <Widget>[
                                          methods.label("Guest Comments: "),
                                          SizedBox(
                                            width: 0,
                                          ),
                                          methods.elementText(book.comment),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ]),
                                      if (book.note != Text(" "))
                                        Row(children: <Widget>[
                                          methods.label("Booking Notes: "),
                                          SizedBox(
                                            width: 0,
                                          ),
                                          methods.elementText(book.note),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ]),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text("Invoice Details",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    children: [
                                      Row(children: <Widget>[
                                        methods.label("Original Price: "),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        methods.element(book.price.toString() +
                                            " " +
                                            book.currency),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Price Multiplier: "),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        methods.element(book.multiplier !=
                                                'Not defined'
                                            ? book.multiplier.toString() + " %"
                                            : book.multiplier),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Deposit: "),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        methods.element(
                                            book.deposit.toString() +
                                                " " +
                                                book.currency),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Tax: "),
                                        SizedBox(
                                          width: 65,
                                        ),
                                        methods.element(book.tax.toString() +
                                            " " +
                                            book.currency),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Commission: "),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        methods.element(
                                            book.commission.toString() +
                                                " " +
                                                book.currency),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        methods.label("Rate Description: "),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        methods
                                            .elementText(book.rateDescription),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                    ],
                                  ),
                                  ExpansionTile(
                                    title: Text("Messages",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    children: [
                                      FutureBuilder(
                                          future: getBookingMessages(
                                              book.propId, book.bookId),
                                          builder:
                                              (context, AsyncSnapshot snap) {
                                            if (snap.data == null) {
                                              return Container(
                                                child: Center(
                                                  child: Text("Loading..."),
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                child: ListView.builder(
                                                  reverse: true,
                                                  itemCount:
                                                      snap.data["data"].length,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                          ),
                                                          child: Align(
                                                            alignment: snap.data["data"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "author"] ==
                                                                    "guest"
                                                                ? Alignment
                                                                    .topLeft
                                                                : Alignment
                                                                    .topRight,
                                                            child: Text(snap
                                                                        .data[
                                                                    "data"][
                                                                index]["time"]),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 0,
                                                                  right: 0,
                                                                  top: 0,
                                                                  bottom: 10),
                                                          child: Align(
                                                            alignment: (snap.data["data"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "author"] ==
                                                                    "guest"
                                                                ? Alignment
                                                                    .topLeft
                                                                : Alignment
                                                                    .topRight),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: (snap.data["data"][index]
                                                                            [
                                                                            "author"] ==
                                                                        "host"
                                                                    ? Colors
                                                                        .grey
                                                                        .shade200
                                                                    : Colors.blue[
                                                                        200]),
                                                              ),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(16),
                                                              child: Text(
                                                                snap.data["data"]
                                                                        [index]
                                                                    ["message"],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              );
                                            }
                                          }),
                                    ],
                                  )
                                ],
                              );
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  showBookingCancellation(context, cancellation) {
    final apiBook = ApiBooking();
    Future<dynamic> callApiBookingCancellation(id) {
      return apiBook.getOneBookingCancelllation(id);
    }

    final methods = Methods();
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Material(
                  child: SingleChildScrollView(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          padding: EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FutureBuilder(
                                    future: callApiBookingCancellation(
                                        cancellation.id),
                                    builder: (context, AsyncSnapshot snap) {
                                      if (snap.data == null) {
                                        return Container(
                                          child: Center(
                                            child: Text("Loading..."),
                                          ),
                                        );
                                      } else {
                                        var cancel = snap.data[0];
                                        return Column(children: [
                                          Row(children: <Widget>[
                                            methods.label("Booking: "),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            methods.element(cancellation
                                                    .referer +
                                                " - " +
                                                cancellation.guestFirstName +
                                                " " +
                                                cancellation.guestName +
                                                "(" +
                                                cancellation.checkin +
                                                ")"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                          Row(children: <Widget>[
                                            methods
                                                .label("Cancellation date: "),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            methods.element(cancellation.date),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                          Row(children: <Widget>[
                                            methods.label("With penalty: "),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            methods.element(
                                                cancellation.withPenalty
                                                    ? "YES"
                                                    : "NO"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                          Row(children: <Widget>[
                                            methods.label("Original price: "),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            methods.element(cancellation.price +
                                                " " +
                                                cancellation.currency),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                          Row(children: <Widget>[
                                            methods.label(
                                                "Amount after cancellation: "),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            methods.element(cancel[
                                                        "amount_after_cancellation"] !=
                                                    null
                                                ? cancel[
                                                        "amount_after_cancellation"] +
                                                    " " +
                                                    cancellation.currency
                                                : "Not defined"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                          Row(children: <Widget>[
                                            methods.label("Penalty amount: "),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            methods.element(cancel[
                                                        "amount_of_penalty"] !=
                                                    null
                                                ? (cancel["amount_of_penalty"] +
                                                    " " +
                                                    cancellation.currency)
                                                : "Not defined"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                          Row(children: <Widget>[
                                            methods.label("Calender blocked: "),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            methods.element(cancel[
                                                        "calendar_blocked"] !=
                                                    null
                                                ? (cancel["calendar_blocked"]
                                                    ? "YES"
                                                    : "NO")
                                                : "Not defined"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                          Row(children: <Widget>[
                                            methods
                                                .label("Cancellation Raison: "),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            methods.element(!cancel["reasons"]
                                                    .isEmpty
                                                ? cancel["reasons"][0]["named"]
                                                : "Not defined"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                          Row(children: <Widget>[
                                            methods.label("Details: "),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            methods.element(
                                                cancel["details"] != null
                                                    ? cancel["details"]
                                                    : "Not defined"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                          Row(children: <Widget>[
                                            methods.label("Payout control: "),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            methods.element(
                                                cancel["payout_control"] != null
                                                    ? cancel["payout_control"]
                                                    : "Not defined"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                        ]);
                                      }
                                    })
                              ])))));
        });
  }

  String allWordsCapitilize(String str) {
    return str.toLowerCase().split(' ').map((word) {
      String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
      return word[0].toUpperCase() + leftText;
    }).join(' ');
  }
}
