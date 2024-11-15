import 'dart:convert';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:Season/homeBottomMenu.dart';
import 'package:Season/services/api.dart';
import 'package:Season/services/user.dart';
import 'package:Season/widgets/operations/pictureCamera.dart';
import '../../models/operation/model_operation.dart';
import '../../api/operation/api_operation.dart';
import 'package:intl/intl.dart';

class DetailsOperation extends StatefulWidget {
  DetailsOperation({Key? key, required this.operation}) : super(key: key);

  final dynamic operation;
  @override
  _DetailsOperationState createState() => _DetailsOperationState();
}

class _DetailsOperationState extends State<DetailsOperation> {
  CurrentUser currentUser = new CurrentUser();
  ApiUrl url = new ApiUrl();
  var user;
  @override
  void initState() {
    super.initState();
    //user = currentUser.getCurrentUser();
    currentUser.getCurrentUser().then((result) {
      //print(result);
      setState(() {
        user = result;
      });
    });
  }

  final apiOp = ApiOperation();

  Future<List<CheckList>> callApiCheckListPerAcc(
      accommodation, type, operation) {
    return apiOp.getCheckListPerAccommodation(accommodation, type, operation);
  }

  Future<int> callApiSendComment(task, comment) {
    return apiOp.sendComment(task, comment);
  }

  Future<int> callApiSendOperationComment(op, agent, comment) {
    return apiOp.sendOperationComment(op, agent, comment);
  }

  Future<int> callApiSendManagerReview(op, comment) {
    return apiOp.sendOperationReview(op, comment);
  }

  Future<int> callApiSendDataValidation(task, status) {
    return apiOp.sendDataValidation(task, status);
  }

  Future<List<Picture>> callApiGetPictures(agent, operation) {
    return apiOp.getOperationPicture(agent, operation);
  }

  @override
  Widget build(BuildContext context) {
    dynamic operation = widget.operation;
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF05A8CF),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => HomeBottomMenu(
                            index: 1,
                          )))
                  .then((_) {
                setState(() {});
              });
            }),
        title: Text(
          "Operation Proceeding",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 2,
          ),
          Container(
            color: Color(0xff04b6e0),
            child: operation.runtimeType == AgentOperation
                ? Center(
                    child: operation.description,
                  )
                : Center(
                    child: Text(
                    "Agent: " + operation.agent,
                    style: TextStyle(color: Colors.white),
                  )),
          ),
          SizedBox(
            height: 2,
          ),
          FutureBuilder(
              future: callApiCheckListPerAcc(operation.accommodationId,
                  operation.typeOperation, operation.idOperation),
              builder: (context, AsyncSnapshot snap) {
                if (snap.data == null) {
                  return Container(
                    child: Center(
                      child: Text("Loading..."),
                    ),
                  );
                } else {
                  var managerReview = operation.runtimeType != AgentOperation
                      ? jsonDecode(operation.managerReview)
                      : [];
                  var agentComment = operation.runtimeType != AgentOperation
                      ? jsonDecode(operation.comment)
                      : [];
                  print(agentComment);
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snap.data.length,
                              itemBuilder: (context, i) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ExpansionTile(
                                      title: Text(
                                        snap.data[i].nameSpace +
                                            "(" +
                                            snap.data[i].checkLists.length
                                                .toString() +
                                            ")",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      children: [
                                        Column(
                                          children: [
                                            for (var check
                                                in snap.data[i].checkLists)
                                              Card(
                                                  child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.white,
                                                    ),
                                                    padding: EdgeInsets.all(10),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          flex: 8,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            child: Text(
                                                                check["task"],
                                                                style:
                                                                    TextStyle()),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(children: [
                                                    if (operation.runtimeType !=
                                                        AgentOperation)
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          if (check["status"] !=
                                                              "archived")
                                                            IconButton(
                                                                icon: Icon(Icons
                                                                    .archive),
                                                                color: Color(
                                                                    0xFF636363),
                                                                onPressed: () {
                                                                  _taskValidation(
                                                                      check[
                                                                          "id"],
                                                                      "archived");
                                                                }),
                                                          Spacer(
                                                            flex: 2,
                                                          ),
                                                          if (check["status"] ==
                                                              "archived")
                                                            Container(
                                                              child: Text(
                                                                check["status"],
                                                              ),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 25,
                                                                      bottom:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                color: Color(
                                                                    0xFFFBD107),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                            ),
                                                          if (check["status"] ==
                                                              "pending")
                                                            Container(
                                                              child: Text(
                                                                check["status"],
                                                              ),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          25),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                color:
                                                                    Colors.grey,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                            ),
                                                          if (check["status"] ==
                                                              "validated")
                                                            Container(
                                                              child: Text(
                                                                check["status"],
                                                              ),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          25),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                color: Colors
                                                                    .green,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                            ),
                                                          if (check["status"] ==
                                                              "unvalidated")
                                                            Container(
                                                              child: Text(
                                                                check["status"],
                                                              ),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          25),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    if (operation.runtimeType ==
                                                        AgentOperation)
                                                      if (check["status"] ==
                                                          "archived")
                                                        Row(
                                                          children: [
                                                            Text(""),
                                                            Spacer(),
                                                            Container(
                                                              child: Text(
                                                                check["status"],
                                                              ),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 25,
                                                                      bottom:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                color: Color(
                                                                    0xFFFBD107),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    if (operation.runtimeType ==
                                                        AgentOperation)
                                                      if (check["status"] !=
                                                          "archived")
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            if (check[
                                                                    "status"] !=
                                                                "validated")
                                                              IconButton(
                                                                  icon: Icon(Icons
                                                                      .check_box_rounded),
                                                                  color: Colors
                                                                      .green,
                                                                  onPressed:
                                                                      () {
                                                                    _taskValidation(
                                                                        check[
                                                                            "id"],
                                                                        "validated");
                                                                  }),
                                                            if (check["status"] !=
                                                                "unvalidated")
                                                              IconButton(
                                                                  icon: Icon(Icons
                                                                      .close_rounded),
                                                                  color: Colors
                                                                      .red,
                                                                  onPressed:
                                                                      () {
                                                                    _taskValidation(
                                                                        check[
                                                                            "id"],
                                                                        "unvalidated");
                                                                  }),
                                                            IconButton(
                                                                icon: Icon(Icons
                                                                    .message_outlined),
                                                                color:
                                                                    Colors.grey,
                                                                onPressed: () {
                                                                  _taskComment(
                                                                      context,
                                                                      check[
                                                                          "id"],
                                                                      check[
                                                                          "comments"]);
                                                                }),
                                                            Spacer(),
                                                            if (check[
                                                                    "status"] ==
                                                                "pending")
                                                              Container(
                                                                child: Text(
                                                                  check[
                                                                      "status"],
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            25),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  color: Colors
                                                                      .grey,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                              ),
                                                            if (check[
                                                                    "status"] ==
                                                                "validated")
                                                              Container(
                                                                child: Text(
                                                                  check[
                                                                      "status"],
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            25),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                              ),
                                                            if (check[
                                                                    "status"] ==
                                                                "unvalidated")
                                                              Container(
                                                                child: Text(
                                                                  check[
                                                                      "status"],
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            25),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  color: Colors
                                                                      .red,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                    if (check["comments"] !=
                                                        null)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                bottom: 5),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Comment: ",
                                                              style: TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic),
                                                            ),
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Expanded(
                                                              child: Card(
                                                                  child: Text(
                                                                check[
                                                                    "comments"],
                                                                style: TextStyle(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                              )),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                  ]),
                                                ],
                                              ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              }),
                          if (operation.runtimeType != AgentOperation)
                            Column(
                              children: [
                                Container(
                                  //height: 200,
                                  child: Card(
                                    margin: EdgeInsets.all(10),
                                    elevation: 10,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          tileColor: Color(0xFFF05A8CF),
                                          title: Text(
                                            "Manager review",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(
                                                Icons.add_circle_outline_sharp,
                                                color: Colors.white,
                                                size: 35),
                                            onPressed: () {
                                              _managerReview(
                                                  context,
                                                  operation.idOperation,
                                                  managerReview);
                                            },
                                          ),
                                        ),
                                        if (operation.managerReview != "[]")
                                          for (var item in managerReview)
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 3),
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  children: [
                                                    Text(item["description"]),
                                                    Text(
                                                      DateFormat(
                                                              'yyyy-MM-dd hh:m')
                                                          .format(DateTime
                                                              .parse(item[
                                                                  "timestamp"])),
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                )),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  //height: 200,
                                  child: Card(
                                    margin: EdgeInsets.all(10),
                                    elevation: 10,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          tileColor: Color(0xFFF05A8CF),
                                          title: Text(
                                            "Agent Comment",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                        if (operation.comment != "[]")
                                          for (var item in agentComment)
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 3),
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  children: [
                                                    Text(item["description"]),
                                                    Text(
                                                      DateFormat(
                                                              'yyyy-MM-dd hh:m')
                                                          .format(DateTime
                                                              .parse(item[
                                                                  "timestamp"])),
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (operation.runtimeType == AgentOperation)
                            Container(
                              //height: 200,
                              child: Card(
                                margin: EdgeInsets.all(10),
                                elevation: 10,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      tileColor: Color(0xFFF05A8CF),
                                      title: Text(
                                        "Operation Comment",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                            Icons.add_circle_outline_sharp,
                                            color: Colors.white,
                                            size: 35),
                                        onPressed: () {
                                          _operationComment(
                                              context, operation.idOperation);
                                        },
                                      ),
                                    ),
                                    if (operation.comment != [])
                                      for (var item in operation.comment)
                                        Container(
                                            padding: EdgeInsets.only(left: 3),
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                              children: [
                                                Text(item["description"]),
                                                Text(
                                                  DateFormat('yyyy-MM-dd hh:m')
                                                      .format(DateTime.parse(
                                                          item["timestamp"])),
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            )),
                                  ],
                                ),
                              ),
                            ),
                          Container(
                            //height: 200,
                            child: Card(
                              margin: EdgeInsets.all(10),
                              elevation: 10,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    tileColor: Color(0xFFF05A8CF),
                                    trailing: IconButton(
                                      icon: Icon(Icons.add_circle_outline_sharp,
                                          color: Colors.white, size: 35),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PictureCamera(
                                                      operation: operation)),
                                        );
                                      },
                                    ),
                                    title: Text(
                                      "Operation pictures",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                  FutureBuilder(
                                      future: callApiGetPictures(
                                          user.id, operation.idOperation),
                                      builder: (context, AsyncSnapshot snap) {
                                        if (snap.data == null) {
                                          return Container(
                                            child: Center(
                                              child: Text("Loading..."),
                                            ),
                                          );
                                        } else {
                                          return snap.data.length == 0
                                              ? Container()
                                              : GridView.builder(
                                                  physics: ScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2),
                                                  itemCount: snap.data.length,
                                                  itemBuilder: (context, i) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            Text(snap.data[i]
                                                                .comment),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                showImageViewer(
                                                                    context,
                                                                    Image.network(url.getUrl() +
                                                                            snap
                                                                                .data[
                                                                                    i]
                                                                                .path)
                                                                        .image,
                                                                    swipeDismissible:
                                                                        false);
                                                              },
                                                              child: Container(
                                                                child: Image
                                                                    .network(
                                                                  url.getUrl() +
                                                                      snap
                                                                          .data[
                                                                              i]
                                                                          .path,
                                                                  width: 300,
                                                                  height: 300,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
        ],
      ),
      drawer: Drawer(),
    );
  }

  _operationComment(context, op) async {
    var _comment;
    // if (comment != "[]") {
    //   _comment = TextEditingController(text: jsonDecode(comment));
    // } else {
    //   _comment = TextEditingController();
    // }
    _comment = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add operation comment'),
            content: TextFormField(
              controller: _comment,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 15,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "your comment..."),
            ),
            actions: <Widget>[
              Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  child: new Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  onPressed: () {
                    _postOperationComment(op, _comment.text);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }

  _managerReview(context, op, review) async {
    var _comment;
    // if (comment != "[]") {
    //   _comment = TextEditingController(text: jsonDecode(comment));
    // } else {
    //   _comment = TextEditingController();
    // }
    _comment = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add review'),
            content: TextFormField(
              controller: _comment,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 15,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Your comment..."),
            ),
            actions: <Widget>[
              Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  child: new Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  onPressed: () {
                    _postReview(op, _comment.text, review);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }

  _taskComment(context, task, comment) async {
    final _comment = TextEditingController(text: comment);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Task comment'),
            content: TextFormField(
              controller: _comment,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 15,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            actions: <Widget>[
              Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  child: new Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  onPressed: () {
                    _postComment(task, _comment.text);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }

  _postOperationComment(op, comment) async {
    var newReview = {
      "agent": user.id,
      "description": comment,
      "timestamp": DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now())
    };
    List<dynamic> jsonData = [];
    // for (var r in comments) {
    //   jsonData.add(r);
    // }
    jsonData.add(newReview);
    var response = await callApiSendOperationComment(op, user.id, comment);
    if (response == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added succefully')),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during add comment')),
      );
    }
  }

  _postReview(op, comment, review) async {
    var newReview = {
      "description": comment,
      "timestamp": DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now())
    };
    List<dynamic> jsonData = [];
    for (var r in review) {
      jsonData.add(r);
    }
    jsonData.add(newReview);
    var response = await callApiSendManagerReview(op, jsonData);
    if (response == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('review added succefully')),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during add review')),
      );
    }
  }

  _postComment(task, comment) async {
    var response = await callApiSendComment(task, comment);
    if (response == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment added succefully')),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during add comment')),
      );
    }
  }

  _taskValidation(task, status) async {
    var response = await callApiSendDataValidation(task, status);
    // print(response);
    if (response == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task updated succefully')),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during task update')),
      );
    }
  }
}
