// import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Season/appBar.dart';
import 'package:Season/models/accommodation/model_accommodation.dart';
import '../../api/accommodation/api_accommodation.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../drawer.dart';

class Accomodation extends StatefulWidget {
  const Accomodation({Key? key, required this.user}) : super(key: key);
  final user;
  @override
  _AccomodationState createState() => _AccomodationState();
}

class _AccomodationState extends State<Accomodation> {
  final apiAcc = ApiAccommodation();

  Future<dynamic> callApiAcc(id) {
    return apiAcc.getOneAccommodations(id);
  }

  Future<List<ShortDataAccommodation>> callApiListAcc() {
    return apiAcc.getAccommodations();
  }

  Future<List<SpaceAccommodationEntity>> callApiSpcAcc(id) {
    return apiAcc.spacesAccommodation(id);
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
    double width = MediaQuery.of(context).size.width * 0.6;
    return Scaffold(
      appBar: appBar("ACCOMMODATIONS", context, 0, null),
      drawer: drawer(widget.user, context),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              FutureBuilder(
                  future: callApiListAcc(),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
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
                                    hintText: 'Search accommodation',
                                    contentPadding: EdgeInsets.fromLTRB(
                                        10.0, 10.0, 10.0, 10.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0)),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) {
                                  return snapshot.data[i].ref
                                              .toString()
                                              .toLowerCase()
                                              .contains(filter) ||
                                          snapshot.data[i].internalName
                                              .toString()
                                              .toLowerCase()
                                              .contains(filter)
                                      ? GestureDetector(
                                          onTap: () {
                                            showAccommodation(widget.user,
                                                context, snapshot.data[i]);
                                          },
                                          child: Container(
                                            height: 70,
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
                                            padding: EdgeInsets.all(2),
                                            child: Row(
                                              children: <Widget>[
                                                Column(
                                                  children: [
                                                    Flexible(
                                                      child: Container(
                                                        width: 100,
                                                        height: 50,
                                                        child: Center(
                                                            child: Text(snapshot
                                                                .data[i].ref)),
                                                        // child: Image(
                                                        //   image: NetworkImage(
                                                        //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                                                        // )
                                                      ),
                                                    ),
                                                    Flexible(
                                                        child: Container(
                                                            child: Center(
                                                      child: _status(snapshot
                                                          .data[i].status),
                                                    )))
                                                  ],
                                                ),
                                                Flexible(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(2.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            snapshot.data[i]
                                                                .internalName,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                // color: Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          width: width,
                                                          child: Text(
                                                            snapshot.data[i]
                                                                    .adresse1 +
                                                                ", " +
                                                                snapshot.data[i]
                                                                    .adresse2 +
                                                                ", " +
                                                                snapshot.data[i]
                                                                    .adresse3,
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              // color: Colors.grey[500],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      : Container();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

showAccommodation(user, context, accomodation) {
  final apiAcc = ApiAccommodation();
  Future<List<SpaceAccommodationEntity>> callApiSpcAcc(id) {
    return apiAcc.spacesAccommodation(id);
  }

  Future<dynamic> callApiAcc(id) {
    return apiAcc.getOneAccommodations(id);
  }

  var chMethodController = TextEditingController();
  var chInFrMethodController = TextEditingController();
  var chInEnMethodController = TextEditingController();
  var chOutFrMethodController = TextEditingController();
  var chOutEnMethodController = TextEditingController();
  var wifiIdentifierController = TextEditingController();
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
                  children: <Widget>[
                    FutureBuilder(
                        future: callApiAcc(accomodation.id),
                        builder: (context, AsyncSnapshot snap) {
                          if (snap.data == null) {
                            return Container(
                              child: Center(
                                child: Text("Loading..."),
                              ),
                            );
                          } else {
                            var accomodation = snap.data;
                            chMethodController.text =
                                accomodation.checkingMethod != ""
                                    ? allWordsCapitilize(accomodation
                                        .checkingMethod
                                        .replaceAll(RegExp('_'), ' '))
                                    : "";
                            chInFrMethodController.text =
                                accomodation.accessInstructionFr.data;
                            chInEnMethodController.text =
                                accomodation.accessInstructionEn.data;
                            chOutFrMethodController.text =
                                accomodation.checkoutInstructionFr.data;
                            chOutEnMethodController.text =
                                accomodation.checkoutInstructionEn.data;
                            wifiIdentifierController.text =
                                accomodation.wifiIdentifiers.data;
                            // print(accomodation);
                            return Column(children: <Widget>[
                              ExpansionTile(
                                title: Text(
                                  "Accommodation Description",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    _label("Reference: "),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    _element(accomodation.ref),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    _label("Status: "),
                                    SizedBox(
                                      width: 45,
                                    ),
                                    _element(allWordsCapitilize(
                                        accomodation.status)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]),
                                  Row(
                                    children: <Widget>[
                                      _label("Internal Name: "),
                                      _element(accomodation.internalName),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _label("External Name: "),
                                      _element(accomodation.externalName),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _label("Type: "),
                                      SizedBox(
                                        width: 55,
                                      ),
                                      _element(allWordsCapitilize(
                                          accomodation.typeAccommodation)),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _label("Entire Palace: "),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      _element(accomodation.entirePlace
                                          ? "True"
                                          : "False"),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _label("Capacity: "),
                                      SizedBox(
                                        width: 35,
                                      ),
                                      _element(
                                          accomodation.capacity.toString()),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _label("Area(m²): "),
                                      SizedBox(
                                        width: 35,
                                      ),
                                      _element(accomodation.area.toString()),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _label("Floor Number: "),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      _element(
                                          accomodation.floorNumber.toString()),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _label("Door Number: "),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      _element(accomodation.doorNumber),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _label("Has Elevator: "),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      _element(accomodation.hasElevator
                                          ? "True"
                                          : "False"),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _label("Desabled Acces: "),
                                      _element(accomodation.hasElevator
                                          ? "True"
                                          : "False"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _label("Description: "),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      _elementText(accomodation.description),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _label("Détails: "),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      _elementText(accomodation.details),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _label("Special equipment: "),
                                      _elementText(
                                          accomodation.specialEquipment),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _label("Advantage for traveler: "),
                                      _elementText(
                                          accomodation.advantageForTraveler),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              ExpansionTile(
                                title: Text(
                                  "Checks Instructions",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      _elementCheck("Check-in Method",
                                          chMethodController, context),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _elementCheck("Check-in Instructions-Fr",
                                          chInFrMethodController, context),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _elementCheck("Check-in Instructions-EN",
                                          chInEnMethodController, context),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _elementCheck("Check-out Instructions-FR",
                                          chOutFrMethodController, context),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      _elementCheck("Check-out Instructions-EN",
                                          chOutEnMethodController, context),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              if (user.role[0] == "admin")
                                ExpansionTile(
                                  title: Text(
                                    "Location and other informations",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        _label("Address: "),
                                        _elementAdresseMap(
                                            accomodation.adresse1 +
                                                " " +
                                                accomodation.adresse2 +
                                                ", " +
                                                accomodation.adresse3),
                                        TextButton(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                      text: accomodation
                                                              .adresse1 +
                                                          " " +
                                                          accomodation
                                                              .adresse2 +
                                                          ", " +
                                                          accomodation
                                                              .adresse3))
                                                  .then((value) {
                                                //only if ->
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text('Copied')),
                                                );
                                              });
                                            },
                                            child: Icon(
                                              Icons.copy,
                                              size: 20,
                                              color: Colors.black,
                                            )),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Geolocalisation: "),
                                        _element("Lat: " +
                                            accomodation.latitude.toString()),
                                        _element("Long: " +
                                            accomodation.longitude.toString()),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Mailbox Name: "),
                                        _element(accomodation.mailBoxeName),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Mailbox Number: "),
                                        _element(accomodation.mailBoxNumber),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Mailbox Location: "),
                                        _elementText(
                                            accomodation.mailBoxLocation),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Heating System: "),
                                        _elementText(
                                            accomodation.headingSystem),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Public Transport Nearby: "),
                                        _elementText(
                                            accomodation.publicTransportNearby),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Energie Line Identifier: "),
                                        _elementText(
                                            accomodation.energyLineIdentifiere),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Telecom Line Identifier: "),
                                        _elementText(accomodation
                                            .telecomLineIdentifiere),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Hotplate System: "),
                                        _elementText(
                                            accomodation.hotplatesystem),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Coffee Machine Type: "),
                                        _elementText(
                                            accomodation.coffeeMachineType),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Wifi Identifiers: "),
                                        _elementText(
                                            accomodation.wifiIdentifiers),
                                        TextButton(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                      text: accomodation
                                                          .wifiIdentifiers
                                                          .data))
                                                  .then((value) {
                                                //only if ->
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text('Copied')),
                                                );
                                              });
                                            },
                                            child: Icon(
                                              Icons.copy,
                                              size: 20,
                                              color: Colors.black,
                                            )),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Trash Location: "),
                                        _elementText(
                                            accomodation.transactionLocation),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Profil Selection Level: "),
                                        _element(accomodation.profilSelection),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        _label("Photos: "),
                                        _elementHyperLink(accomodation.photos),
                                        TextButton(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                      text:
                                                          accomodation.photos))
                                                  .then((value) {
                                                //only if ->
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text('Copied')),
                                                );
                                              });
                                            },
                                            child: Icon(
                                              Icons.copy,
                                              size: 20,
                                              color: Colors.black,
                                            )),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              if (user.role[0] == "admin")
                                ExpansionTile(
                                  title: Text(
                                    "Pricing Plan",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: [
                                    accomodation.pricingPlan,
                                    TextButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                                  text: accomodation
                                                      .pricingPlan.data))
                                              .then((value) {
                                            //only if ->
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text('Copied')),
                                            );
                                          });
                                        },
                                        child: Icon(
                                          Icons.copy,
                                          size: 20,
                                          color: Colors.black,
                                        )),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              if (user.role[0] == "admin")
                                ExpansionTile(
                                  title: Text(
                                    "Hosting Platforms",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        for (var host in accomodation.hosting)
                                          ExpansionTile(
                                              title: Container(
                                                child: Text(
                                                  host["platform"]["name"],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    _label("Account Name: "),
                                                    _element(host["account"]
                                                        ["account_name"]),
                                                    SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    _label("Listing status: "),
                                                    _element(allWordsCapitilize(
                                                        host[
                                                            "listing_status"])),
                                                    SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    _label(
                                                        "Listing Reference "),
                                                    host["listing_ref"] != null
                                                        ? _element(
                                                            host["listing_ref"])
                                                        : Text(""),
                                                    SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    _label("Payment Handler: "),
                                                    host["payment_managed_by"] !=
                                                            null
                                                        ? _element(
                                                            allWordsCapitilize(host[
                                                                "payment_managed_by"]))
                                                        : Text(""),
                                                    SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                ),
                                              ])
                                      ],
                                    )
                                  ],
                                ),
                              ExpansionTile(
                                title: Text(
                                  "Spaces",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: <Widget>[
                                  FutureBuilder(
                                      future: callApiSpcAcc(accomodation.id),
                                      builder: (context, AsyncSnapshot snap) {
                                        if (snap.data == null) {
                                          return Container(
                                            child: Center(
                                              child: Text("Loading..."),
                                            ),
                                          );
                                        } else {
                                          return Center(
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: snap.data.length,
                                              itemBuilder: (context, i) {
                                                return Card(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(
                                                        children: [
                                                          _label("Name: "),
                                                          _element(snap
                                                              .data[i].name),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(children: [
                                                        _label("Type: "),
                                                        SizedBox(
                                                          width: 7,
                                                        ),
                                                        _element(
                                                            snap.data[i].type),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ]),
                                                      Row(
                                                        children: [
                                                          _label("Size(m²): "),
                                                          _element(snap
                                                              .data[i].size
                                                              .toString()),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      if (snap.data[i].heigh !=
                                                          0)
                                                        Row(
                                                          children: [
                                                            _label(
                                                                "Heigh(m): "),
                                                            _element(snap
                                                                .data[i].heigh
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbAirConditioner >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Air Condionner: "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbHeater
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbHeater >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Heater: "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbHeater
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbSingleBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Single Beds(90): "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbSingleBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbDoubleBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Double Beds(140): "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbDoubleBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbLargeBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Large Beds(160): "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbLargeBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbExtraLargeBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Extra Large Beds(180): "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbExtraLargeBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbSingleSofaBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Sofa Beds: "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbSingleSofaBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbDoubleSofaBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number Double Sofa Beds: "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbDoubleSofaBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i].nbSofa >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number Sofa: "),
                                                            _element(snap
                                                                .data[i].nbSofa
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbSingleFloorMattress >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Single Floor Mattress: "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbSingleFloorMattress
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbDoubleFloorMattress >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Double Floor Mattress: "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbDoubleFloorMattress
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbSingleAirMattress >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Single Air Mattress: "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbSingleAirMattress
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbDoubleAirMattress >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Double Air Mattress: "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbDoubleAirMattress
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i].nbCrib >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Cribs: "),
                                                            _element(snap
                                                                .data[i].nbCrib
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbToddlerBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Toddler Beds: "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbToddlerBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbWaterBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Water Beds: "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbWaterBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbHammock >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Hammocks: "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbHammock
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbHammock >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Travel Cot: "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbTravelCot
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        ),
                                                      if (snap.data[i]
                                                              .nbFolderBed >
                                                          0)
                                                        Row(
                                                          children: [
                                                            _labelFlex(
                                                                "Number of Folder Bed: "),
                                                            _element(snap
                                                                .data[i]
                                                                .nbFolderBed
                                                                .toString()),
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      })
                                ],
                              ),
                              ExpansionTile(
                                title: Text(
                                  "Sleeping Arrangement",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: [
                                  FutureBuilder(
                                      future: callApiSpcAcc(accomodation.id),
                                      builder: (context, AsyncSnapshot snap) {
                                        if (snap.data == null) {
                                          return Container(
                                            child: Center(
                                              child: Text("Loading..."),
                                            ),
                                          );
                                        } else {
                                          num doubleBeds = 0;
                                          num singleBed = 0;
                                          num kidBed = 0;

                                          for (var item in snap.data) {
                                            doubleBeds = doubleBeds +
                                                item.nbDoubleAirMattress +
                                                item.nbDoubleBed +
                                                item.nbDoubleFloorMattress +
                                                item.nbDoubleSofaBed +
                                                item.nbExtraLargeBed +
                                                item.nbLargeBed +
                                                item.nbWaterBed +
                                                item.nbMediumnBed;
                                            singleBed = singleBed +
                                                item.nbHammock +
                                                item.nbSingleAirMattress +
                                                item.nbSingleBed +
                                                item.nbSingleFloorMattress +
                                                item.nbSingleSofaBed +
                                                item.nbSofa;
                                            kidBed = kidBed +
                                                item.nbCrib +
                                                item.nbToddlerBed;
                                          }
                                          return Column(
                                            children: [
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Row(
                                                    children: [
                                                      Text(doubleBeds
                                                          .toString()),
                                                      Text(" double bed(s)"),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Image.asset(
                                                        "assets/images/double.png",
                                                        height: 40,
                                                        width: 60,
                                                      )
                                                    ],
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          singleBed.toString()),
                                                      Text(" single bed(s)"),
                                                      SizedBox(
                                                        width: 27,
                                                      ),
                                                      Image.asset(
                                                        "assets/images/simple.png",
                                                        height: 40,
                                                        width: 50,
                                                      )
                                                    ],
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Row(
                                                    children: [
                                                      Text(kidBed.toString()),
                                                      Text(" kid bed(s)"),
                                                      SizedBox(
                                                        width: 52,
                                                      ),
                                                      Image.asset(
                                                        "assets/images/kind.png",
                                                        height: 40,
                                                        width: 40,
                                                      )
                                                    ],
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          );
                                        }
                                      })
                                ],
                              ),
                            ]);
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

Widget _label(label) {
  return Flexible(
      child: Text(
    label,
    style: TextStyle(fontSize: 12, color: Colors.grey),
  ));
}

Widget _labelFlex(label) {
  return Flexible(
      flex: 2,
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ));
}

Widget _element(elt) {
  return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          elt,
        ),
      ));
}

Widget _elementText(elt) {
  return Flexible(
      flex: 2, child: Padding(padding: const EdgeInsets.all(8.0), child: elt));
}

Widget _elementCheck(label, controller, context) {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.black87, minimumSize: Size(5, 5),
    // padding: EdgeInsets.symmetric(horizontal: 1.0),
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.all(Radius.circular(2.0)),
    // ),
  );
  return Flexible(
      child: Container(
    padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
    child: TextFormField(
      obscureText: false,
      //style: style,
      readOnly: true,
      minLines: 1,
      maxLines: 20,
      keyboardType: TextInputType.multiline,
      controller: controller,
      decoration: InputDecoration(
        icon: Container(
            width: 20,
            child: TextButton(
                style: flatButtonStyle,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: controller.text))
                      .then((value) {
                    //only if ->
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied')),
                    );
                  });
                },
                child: Icon(
                  Icons.copy,
                  size: 20,
                )
                // Column(
                //   children: [Icon(Icons.copy), Text("Copy")],
                // ),
                )),
        // prefixIconConstraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
        isCollapsed: true,
        contentPadding: EdgeInsets.fromLTRB(5, 20, 5, 10),
        labelText: label,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
  ));
}

Widget _elementTextCopy(controller, context) {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.black87, minimumSize: Size(5, 5),
    // padding: EdgeInsets.symmetric(horizontal: 1.0),
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.all(Radius.circular(2.0)),
    // ),
  );

  return controller.text != ""
      ? Flexible(
          child: Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
          child: TextFormField(
            obscureText: false,
            //style: style,
            readOnly: true,
            minLines: 1,
            maxLines: 20,
            keyboardType: TextInputType.multiline,
            controller: controller,
            decoration: InputDecoration(
              icon: Container(
                  width: 16,
                  child: TextButton(
                      style: flatButtonStyle,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: controller.text))
                            .then((value) {
                          //only if ->
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied')),
                          );
                        });
                      },
                      child: Icon(
                        Icons.copy,
                        size: 20,
                      ))),
              isCollapsed: true,
              contentPadding: EdgeInsets.fromLTRB(5, 20, 5, 10),
              labelStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ))
      : Container();
}

Widget _elementHyperLink(elt) {
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

Widget _elementAdresseMap(elt) {
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
                  "https://www.google.com/maps/search/?api=1&query=" + elt;
              final url = Uri.parse(googleUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(
                  url,
                );
              }
            },
        ),
      ),
    ),
  );
}

Widget _status(status) {
  if (status == "exploiting") {
    return Container(
      child: Text(status, style: TextStyle(fontSize: 10, color: Colors.white)),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  } else if (status == "prospecting") {
    return Container(
      child: Text(
        status,
        style: TextStyle(fontSize: 10, color: Colors.white),
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
      child: Text(status, style: TextStyle(fontSize: 10, color: Colors.white)),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

String allWordsCapitilize(String str) {
  return str.toLowerCase().split(' ').map((word) {
    String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
    return word[0].toUpperCase() + leftText;
  }).join(' ');
}
