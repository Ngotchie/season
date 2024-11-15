import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:Season/api/marketing-review/api-marketing-review.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class OccupacyRateWidget extends StatefulWidget {
  const OccupacyRateWidget({Key? key}) : super(key: key);

  @override
  State<OccupacyRateWidget> createState() => _OccupacyRateWidgetState();
}

class _OccupacyRateWidgetState extends State<OccupacyRateWidget> {
  bool visibility = false;
  String _month = '';
  int _year = 0;
  final apiMarketingReview = new ApiMarketingReview();
  List<String> months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  TextEditingController searchController = new TextEditingController();
  String filter = "";
  num allDays = 0;
  int nbDays = 0;
  num direct = 0;
  num booking = 0;
  num airbnb = 0;
  num vrbo = 0;

  List<int> years = <int>[];
  void initState() {
    int currentYear = int.parse(DateFormat('yyyy').format(DateTime.now()));
    _year = currentYear;
    _month = DateFormat.MMMM('en_US').format(DateTime.now());
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

  Future<dynamic> getOccupacyRate(month, year) {
    return apiMarketingReview.getOccypacyRate(month, year);
  }

  @override
  Widget build(BuildContext context) {
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
                  margin: EdgeInsets.only(left: 5, top: 5),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 221, 151, 151),
                          Colors.blueAccent,
                          Colors.purpleAccent
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
                      child: DropdownButton<String>(
                        focusColor: Colors.white,
                        value: _month,
                        //elevation: 5,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        iconEnabledColor: Colors.white,
                        items: months
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "choose a month",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _month = value as String;
                          });
                        },
                        underline: Container(),
                        dropdownColor: Color.fromARGB(255, 221, 215, 215),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 10, top: 5, right: 10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 221, 151, 151),
                          Colors.blueAccent,
                          Colors.purpleAccent
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
                future: getOccupacyRate(_month, _year),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: Text("Loading..."),
                      ),
                    );
                  } else {
                    for (var e in snapshot.data) {
                      allDays = allDays + e['total_days'];
                    }
                    DateTime cd =
                        lastDayOfMonth(_year, DateFormat("MMMM").parse(_month));
                    nbDays = cd.day;

                    return Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Column(
                        children: [
                          visibility
                              ? Container(
                                  height: 50,
                                  margin: EdgeInsets.only(left: 75),
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
                                        contentPadding: EdgeInsets.fromLTRB(
                                            10.0, 10.0, 10.0, 10.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
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
                                    direct = booking = airbnb = vrbo = 0;
                                    for (var b in snapshot.data[i]
                                        ['bookings']) {
                                      switch (b['apiSource']) {
                                        case "0":
                                          direct = direct + b['days'];
                                          break;
                                        case "19":
                                          booking = booking + b['days'];
                                          break;
                                        case "46":
                                          airbnb = airbnb + b['days'];
                                          break;
                                        case "30":
                                          vrbo = vrbo + b['days'];
                                          break;
                                        default:
                                      }
                                    }
                                    return snapshot.data[i]['internal_name']
                                            .toString()
                                            .toLowerCase()
                                            .contains(filter)
                                        ? Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.0),
                                                child: ExpansionTileCard(
                                                  baseColor: Colors.grey[100],
                                                  title: Text(
                                                    snapshot.data[i]
                                                        ['internal_name'],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    child: Row(children: [
                                                      Text(
                                                        'BNight: ',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(snapshot.data[i]
                                                              ['total_days']
                                                          .toString()),
                                                      Spacer(),
                                                      Text(
                                                        'Occupation: ',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(((snapshot.data[i][
                                                                          'total_days'] /
                                                                      nbDays) *
                                                                  100)
                                                              .toStringAsFixed(
                                                                  2) +
                                                          '%')
                                                    ]),
                                                  ),
                                                  children: [
                                                    DataTable(
                                                      headingRowColor:
                                                          MaterialStateColor
                                                              .resolveWith(
                                                                  (states) => Color
                                                                      .fromARGB(
                                                                          255,
                                                                          248,
                                                                          246,
                                                                          246)),
                                                      columns: <DataColumn>[
                                                        DataColumn(
                                                          label: Expanded(
                                                            child: Text(
                                                              'Platform',
                                                              style: TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            ),
                                                          ),
                                                        ),
                                                        DataColumn(
                                                          label: Expanded(
                                                            child: Text(
                                                              'BNight',
                                                              style: TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            ),
                                                          ),
                                                        ),
                                                        DataColumn(
                                                          label: Expanded(
                                                            child: Text(
                                                              'Rate(%)',
                                                              style: TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                      rows: <DataRow>[
                                                        DataRow(
                                                          cells: <DataCell>[
                                                            DataCell(Text(
                                                              'Direct',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                            DataCell(Text(direct
                                                                .toString())),
                                                            DataCell(Text(snapshot
                                                                            .data[i]
                                                                        [
                                                                        'total_days'] !=
                                                                    0
                                                                ? ((direct / snapshot.data[i]['total_days']) *
                                                                            100)
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    "%"
                                                                : "0.00%")),
                                                          ],
                                                        ),
                                                        DataRow(
                                                          cells: <DataCell>[
                                                            DataCell(Text(
                                                              'Airbnb',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                            DataCell(Text(airbnb
                                                                .toString())),
                                                            DataCell(Text(snapshot
                                                                            .data[i]
                                                                        [
                                                                        'total_days'] !=
                                                                    0
                                                                ? ((airbnb / snapshot.data[i]['total_days']) *
                                                                            100)
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    "%"
                                                                : "0.00%")),
                                                          ],
                                                        ),
                                                        DataRow(
                                                          cells: <DataCell>[
                                                            DataCell(Text(
                                                              'Booking.com',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                            DataCell(Text(booking
                                                                .toString())),
                                                            DataCell(Text(snapshot
                                                                            .data[i]
                                                                        [
                                                                        'total_days'] !=
                                                                    0
                                                                ? ((booking / snapshot.data[i]['total_days']) *
                                                                            100)
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    "%"
                                                                : "0.00%")),
                                                          ],
                                                        ),
                                                        DataRow(
                                                          cells: <DataCell>[
                                                            DataCell(Text(
                                                              'VRBO',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                            DataCell(Text(vrbo
                                                                .toString())),
                                                            DataCell(Text(snapshot
                                                                            .data[i]
                                                                        [
                                                                        'total_days'] !=
                                                                    0
                                                                ? ((vrbo / snapshot.data[i]['total_days']) *
                                                                            100)
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    "%"
                                                                : "0.00%")),
                                                          ],
                                                        ),
                                                      ],
                                                    )
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

  static DateTime lastDayOfMonth(year, DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(year, month.month + 1, 1)
        : new DateTime(year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }
}
