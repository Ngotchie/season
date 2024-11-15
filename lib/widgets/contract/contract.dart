import 'package:flutter/material.dart';
import 'package:Season/api/contract/api_contract.dart';
import 'package:Season/models/contract/model_contract.dart';

import '../../homeBottomMenu.dart';
import '../methods.dart';

class ContractWidget extends StatefulWidget {
  const ContractWidget({Key? key, required this.user}) : super(key: key);
  final user;
  @override
  _ContractWidgetState createState() => _ContractWidgetState();
}

class _ContractWidgetState extends State<ContractWidget> {
  final apiContract = ApiContract();
  Future<List<Contract>> getContracts() {
    return apiContract.getContracts();
  }

  TextEditingController searchController = new TextEditingController();
  String filter = "";

  @override
  void initState() {
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final methods = Methods();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF05A8CF),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => HomeBottomMenu(index: 4)));
          },
        ),
        title: Text(
          "CONTRACTS",
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              FutureBuilder(
                  future: getContracts(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(
                          child: Text("Loading..."),
                        ),
                      );
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              padding: new EdgeInsets.all(8.0),
                              child: new TextField(
                                onChanged: (value) {
                                  setState(() {
                                    filter = value.toLowerCase();
                                  });
                                },
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search contract',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      10.0, 10.0, 10.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                ),
                              ),
                            ),
                            Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, i) {
                                      return snapshot.data[i].accommodation
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(filter) ||
                                              snapshot.data[i].businessName
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(filter) ||
                                              snapshot.data[i].lastName
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(filter) ||
                                              snapshot.data[i].firstName
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(filter) ||
                                              snapshot.data[i].status
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(filter)
                                          ? ListTile(
                                              onTap: () {
                                                showContract(context,
                                                    snapshot.data[i].id);
                                              },
                                              title: Text(
                                                snapshot.data[i].businessName +
                                                    "" +
                                                    snapshot.data[i].firstName +
                                                    " " +
                                                    snapshot.data[i].lastName +
                                                    " (" +
                                                    snapshot
                                                        .data[i].accommodation +
                                                    " )",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Row(
                                                children: [
                                                  Text(snapshot.data[i].offer),
                                                  Spacer(
                                                    flex: 1,
                                                  ),
                                                  _status(
                                                      snapshot.data[i].status)
                                                ],
                                              ),
                                              leading: new CircleAvatar(
                                                backgroundColor:
                                                    Color(0xFF05A8CF),
                                                child: (snapshot.data[i]
                                                                .businessName !=
                                                            "" &&
                                                        snapshot.data[i]
                                                                .firstName !=
                                                            "" &&
                                                        snapshot.data[i]
                                                                .lastName !=
                                                            "")
                                                    ? Text(
                                                        (snapshot.data[i]
                                                                    .businessName !=
                                                                ""
                                                            ? methods.toAvatar(
                                                                snapshot.data[i]
                                                                    .businessName)
                                                            : snapshot.data[i].firstName !=
                                                                        "" &&
                                                                    snapshot.data[i].lastName !=
                                                                        ""
                                                                ? methods.toAvatar(snapshot
                                                                        .data[i]
                                                                        .firstName +
                                                                    " " +
                                                                    snapshot
                                                                        .data[i]
                                                                        .lastName)
                                                                : snapshot.data[i].lastName !=
                                                                        ""
                                                                    ? methods.toAvatar(snapshot
                                                                        .data[i]
                                                                        .lastName)
                                                                    : methods.toAvatar(snapshot
                                                                        .data[i]
                                                                        .firstName)),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Text("CS",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
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
      ),
    );
  }

  showContract(context, id) {
    Future<dynamic> callApiContract(id) {
      return apiContract.getOneContract(id);
    }

    final methods = Methods();
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
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
                        future: callApiContract(id),
                        builder: (context, AsyncSnapshot snap) {
                          var contract = snap.data;
                          if (snap.data == null) {
                            return Container(
                              child: Center(
                                child: Text("Loading..."),
                              ),
                            );
                          } else {
                            return Column(children: [
                              ExpansionTile(
                                  title: Text(
                                    "Base Information",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        methods.label("Reference: "),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        methods.element(contract.ref),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        methods.label("Status: "),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        methods.element(contract.status),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   children: <Widget>[
                                    //     methods.label("Type: "),
                                    //     SizedBox(
                                    //       width: 17,
                                    //     ),
                                    //     methods.element(contract["partner_type"]),
                                    //     SizedBox(
                                    //       height: 10,
                                    //     ),
                                    //   ],
                                    // ),
                                    Row(
                                      children: <Widget>[
                                        methods.label("Offer: "),
                                        SizedBox(
                                          width: 60,
                                        ),
                                        methods.element(contract.offer),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        methods.label("Currency: "),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        methods.element(contract.currency),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        methods.label("Accommodation: "),
                                        SizedBox(
                                          width: 17,
                                        ),
                                        methods.element(contract.accommodation),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        methods.label("Partner: "),
                                        SizedBox(
                                          width: 17,
                                        ),
                                        methods.element(contract.partner),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        methods.label("Partner type: "),
                                        SizedBox(
                                          width: 17,
                                        ),
                                        methods.element(contract.partnerType),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        methods.label("Start date: "),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        methods.element(contract.startDate),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        methods.label("End date: "),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        methods.element(contract.endDate),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        methods.label("Commitment period: "),
                                        SizedBox(
                                          width: 17,
                                        ),
                                        methods.element(contract
                                            .commitmentPeriod
                                            .toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        methods.label("Signing date: "),
                                        SizedBox(
                                          width: 17,
                                        ),
                                        methods.element(contract.signingDate),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ]),
                              ExpansionTile(
                                title: Text(
                                  "Cost Information",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: [
                                  Row(
                                    children: [
                                      methods.label("Commission:"),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      methods.element(
                                          contract.offer == "Chic'Zen"
                                              ? contract.commission.toString() +
                                                  " " +
                                                  contract.currency
                                              : contract.commission.toString() +
                                                  " %"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Guaranteed deposit:"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.element(contract.guaranteedDeposit
                                              .toString() +
                                          " " +
                                          contract.currency),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Cleaning fees:"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.element(
                                          contract.cleaningFees.toString() +
                                              " " +
                                              contract.currency),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      methods
                                          .label("Cleaning fees for partner:"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.element(contract
                                              .cleaningFeesForPartner
                                              .toString() +
                                          " " +
                                          contract.currency),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Travelers deposit:"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.element(
                                          contract.travelersDeposit.toString() +
                                              " " +
                                              contract.currency),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Emergency envelope:"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.element(
                                          contract.emergencyEnvelop.toString() +
                                              " " +
                                              contract.currency),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Supplies base price:"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.element(contract.suppliesBasePrise
                                              .toString() +
                                          " " +
                                          contract.currency),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                title: Text(
                                  "Payment Process Details",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: [
                                  Row(
                                    children: [
                                      methods.label("Bank Details:"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.elementText(contract.bankDetails),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Payment Date :"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.element(contract.paymentDate +
                                          " (day in month)"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                title: Text(
                                  "Additional Details",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: [
                                  Row(
                                    children: [
                                      methods
                                          .label("Is breakfast included ? :"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.element(contract.breakfastIncluded
                                          ? "True"
                                          : "False"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Supplies managed by :"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods
                                          .element(contract.suppliesManageBy),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Retraction delay :"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.element(
                                          contract.retractionDelay.toString() +
                                              " days"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Cleaning duration  :"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.element(
                                          contract.cleaningDuration.toString() +
                                              " minutes per person"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      methods.label(
                                          "Termination notice duration :"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.element(contract.terminaisonNotice
                                              .toString() +
                                          " months"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      methods.label(
                                          "Reservation notice duration :"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.element(contract.reservationNotice
                                              .toString() +
                                          " months"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Partner booking range :"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods.element(contract
                                              .partnerBookingRange
                                              .toString() +
                                          " months"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      methods.label("Special clauses :"),
                                      SizedBox(
                                        width: 17,
                                      ),
                                      methods
                                          .elementText(contract.specialClose),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                title: Text(
                                  "Supplies List",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: [
                                  Center(
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: contract.supplies.length,
                                        itemBuilder: (context, i) {
                                          return Card(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    methods.label("Name: "),
                                                    methods.element(contract
                                                        .supplies[i]["name"]),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    methods.label("Price: "),
                                                    SizedBox(
                                                      width: 25,
                                                    ),
                                                    methods.element(contract
                                                            .supplies[i]
                                                                ["price"]
                                                            .toString() +
                                                        " " +
                                                        contract.currency),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    methods.label("Quantity: "),
                                                    methods.element(contract
                                                        .supplies[i]["quantity"]
                                                        .toString()),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    methods.label("Total: "),
                                                    SizedBox(
                                                      width: 25,
                                                    ),
                                                    methods.element(product(
                                                                int.parse(contract
                                                                    .supplies[i]
                                                                        [
                                                                        "quantity"]
                                                                    .toString()),
                                                                double.parse(contract
                                                                    .supplies[i]
                                                                        [
                                                                        "price"]
                                                                    .toString()))
                                                            .toString() +
                                                        " " +
                                                        contract.currency),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              )
                            ]);
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _status(status) {
  if (status == "active") {
    return Container(
      child: Center(
          child: Text(status,
              style: TextStyle(fontSize: 12, color: Colors.white))),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  } else if (status == "draft") {
    return Container(
      child: Text(
        status,
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  } else {
    return Container(
      child: Text(status, style: TextStyle(fontSize: 12, color: Colors.white)),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

double product(int a, double b) {
  double temp = 0;
  while (a != 0) {
    temp += b;
    a--;
  }
  return temp;
}
