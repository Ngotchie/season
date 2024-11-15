import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../api/marketing-review/api-marketing-review.dart';

class RevenueWidget extends StatefulWidget {
  const RevenueWidget({Key? key}) : super(key: key);

  @override
  State<RevenueWidget> createState() => _RevenueWidgetState();
}

class _RevenueWidgetState extends State<RevenueWidget> {
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
  num total = 0;
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

  Future<dynamic> getRevenue(month, year) {
    return apiMarketingReview.getRevenue(month, year);
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
                future: getRevenue(_month, _year),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: Text("Loading..."),
                      ),
                    );
                  } else {
                    for (var e in snapshot.data) {
                      total = total + e['total_amount'];
                    }
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
                                                trailing: SizedBox(),
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
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  child: Row(children: [
                                                    Text(
                                                      'Amount: ',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(snapshot.data[i]
                                                                ['total_amount']
                                                            .toStringAsFixed(
                                                                2) +
                                                        "€"),
                                                    Spacer(),
                                                    Text(
                                                      'Percent: ',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(((snapshot.data[i][
                                                                        'total_amount'] /
                                                                    total) *
                                                                100)
                                                            .toStringAsFixed(
                                                                2) +
                                                        '%')
                                                  ]),
                                                ),
                                              ),
                                            ),
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
