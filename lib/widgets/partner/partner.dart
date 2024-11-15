import 'package:flutter/material.dart';
import 'package:Season/api/partner/api_partner.dart';
import 'package:Season/models/partner/model_partner.dart';
import 'package:Season/widgets/methods.dart';

import '../../homeBottomMenu.dart';

class PartnerWidget extends StatefulWidget {
  const PartnerWidget({Key? key, required this.user}) : super(key: key);
  final user;
  @override
  _PartnerWidgetState createState() => _PartnerWidgetState();
}

class _PartnerWidgetState extends State<PartnerWidget> {
  final apiPart = ApiPartner();
  Future<List<Partner>> getPartners() {
    return apiPart.getPartners();
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
          "PARTNERS",
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
                  future: getPartners(),
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
                                  hintText: 'Search partner',
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
                                      return snapshot.data[i].firstName
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
                                                  .contains(filter)
                                          ? ListTile(
                                              onTap: () {
                                                showPartner(context,
                                                    snapshot.data[i].id);
                                              },
                                              title: Text(
                                                snapshot.data[i].businessName +
                                                    " " +
                                                    snapshot.data[i].firstName +
                                                    " " +
                                                    snapshot.data[i].lastName,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(snapshot
                                                      .data[i].address1 +
                                                  " " +
                                                  snapshot.data[i].address3 +
                                                  " " +
                                                  snapshot.data[i].city +
                                                  ""),
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
                                                    : Text("PO",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                              ))
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

  showPartner(context, id) {
    Future<dynamic> callApiPart(id) {
      return apiPart.getOnePartner(id);
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
                        future: callApiPart(id),
                        builder: (context, AsyncSnapshot snap) {
                          var partner = snap.data;
                          if (snap.data == null) {
                            return Container(
                              child: Center(
                                child: Text("Loading..."),
                              ),
                            );
                          } else {
                            return Column(
                              children: [
                                Row(children: <Widget>[
                                  methods.label("Reference: "),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  methods.element(partner.ref),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ]),
                                Row(children: <Widget>[
                                  methods.label("Gender: "),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  methods.element(
                                      partner.genre == "f" ? "Female" : "Male"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ]),
                                Row(children: <Widget>[
                                  methods.label("Type entity: "),
                                  SizedBox(
                                    width: 0,
                                  ),
                                  methods.element(partner.type),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ]),
                                Row(children: <Widget>[
                                  methods.label("Status: "),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  methods.element(partner.status),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ]),
                                partner.businessName != null
                                    ? Row(children: <Widget>[
                                        methods.label("Name: "),
                                        SizedBox(
                                          width: 22,
                                        ),
                                        methods.element(partner.businessName),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ])
                                    : Row(children: <Widget>[
                                        methods.label("Name: "),
                                        SizedBox(
                                          width: 22,
                                        ),
                                        methods.element(partner.firstName +
                                            " " +
                                            partner.firstName),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ]),
                                partner.surname != null
                                    ? Row(children: <Widget>[
                                        methods.label("Surname: "),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        methods.element(partner.surname),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ])
                                    : Container(),
                                Row(
                                  children: [
                                    methods.label("Email: "),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    methods.elementText(partner.email),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("Country: "),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    methods.element(partner.address3),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("Address: "),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    methods.elementAdresseMap(partner.address1 +
                                        ", " +
                                        partner.address3 +
                                        ", " +
                                        partner.city),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("City: "),
                                    SizedBox(
                                      width: 35,
                                    ),
                                    methods.element(partner.city),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("State: "),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    methods.element(partner.state),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("Fix line number: "),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    methods.element(partner.fixLineNumber),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("Mobile phone number: "),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    methods.element(partner.mobilePhoneNumber),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("Other phone number: "),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    methods.element(partner.otherPhoneNumber),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("Web site: "),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    methods.elementHyperLink(partner.website),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods.label("Comment: "),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    methods.elementText(partner.comment),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    methods
                                        .label("Preferred Means of Contact: "),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    methods.element(
                                        partner.preferredMeansOfConctact),
                                    SizedBox(
                                      height: 10,
                                    ),
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
      },
    );
  }
}
