import 'package:flutter/material.dart';
import 'package:Season/api/cash_transaction/api_cash_transaction.dart';
import 'package:Season/homeBottomMenu.dart';
import '../../models/cash_transaction/model_cash_transaction.dart';

import 'addCashTransaction.dart';
import 'editCashTransaction.dart';

class CashTransactionWidget extends StatefulWidget {
  const CashTransactionWidget({Key? key, required this.user}) : super(key: key);
  final user;
  @override
  _CashTransactionWidgetState createState() => _CashTransactionWidgetState();
}

class _CashTransactionWidgetState extends State<CashTransactionWidget> {
  int _seletedPage = 0;
  bool change = false;
  var years = [];
  int i = -1;
  int j = 0;
  bool editCashTrans = false;
  bool addCashTrans = false;
  final apiCash = ApiCashTransaction();
  late PageController _pageController;
  // final ScrollController _scrollController = ScrollController();
  void _changePage(int pageNum) {
    setState(() {
      _seletedPage = pageNum;
      _pageController.animateToPage(pageNum,
          duration: Duration(microseconds: 1000),
          curve: Curves.fastLinearToSlowEaseIn);
    });
  }

  @override
  void initState() {
    super.initState();
    apiCash.getYear().then((result) {
      setState(() {
        years = result;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    editCashTrans = widget.user.permissions.contains("edit cash transaction");
    addCashTrans = widget.user.permissions.contains("add cash transaction");
    // print(years);
    _pageController = PageController(initialPage: years.length - 1);
    if (!change) _seletedPage = years.length - 1;
    return Scaffold(
      // appBar: appBar("CASH TRANSACTION", context, 2, widget.user),
      // drawer: drawer(widget.user, context),
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF05A8CF),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            //onPressed: () => Navigator.pop(context),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => HomeBottomMenu(index: 2)))),
        title: Row(
          children: [
            Text(
              'Cash Transaction',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Container(
              height: 40,
              width: 35,
              margin: EdgeInsets.only(left: 20),
              child: addCashTrans
                  ? FloatingActionButton(
                      backgroundColor: Colors.white,
                      mini: true,
                      child: Icon(Icons.add),
                      foregroundColor: Colors.blue,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddCashTransaction()));
                      })
                  : Text(""),
            )
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 1),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = years.length - 1; i > 0; i--)
                              TabButton(
                                title: years[i]["year"],
                                pageNumber: i,
                                selectedPage: _seletedPage,
                                onPressed: () {
                                  change = true;
                                  _changePage(i);
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      constraints: BoxConstraints(
                          minHeight: 100,
                          minWidth: double.infinity,
                          maxHeight: MediaQuery.of(context).size.height),
                      child: PageView(
                        onPageChanged: (int page) {
                          setState(() {
                            _seletedPage = page;
                          });
                        },
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var i = years.length - 1; i > 0; i--)
                            cashMonth(
                                years[i]["year"].toString(), editCashTrans),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget cashMonth(year, editPermission) {
  final apiCash = ApiCashTransaction();
  Future<List<CashTransaction>> callApiCash(year) {
    return apiCash.getCashTransaction(year);
  }

  List<CashTransaction> jan = [],
      feb = [],
      mar = [],
      april = [],
      may = [],
      june = [],
      july = [],
      aug = [],
      sep = [],
      oct = [],
      nov = [],
      dec = [];

  sortBymonth(cashTransactions) {
    for (var cash in cashTransactions) {
      int month = DateTime.parse(cash.date).month;
      switch (month) {
        case 1:
          jan.add(cash);
          break;
        case 2:
          feb.add(cash);
          break;
        case 3:
          mar.add(cash);
          break;
        case 4:
          april.add(cash);
          break;
        case 5:
          may.add(cash);
          break;
        case 6:
          june.add(cash);
          break;
        case 7:
          july.add(cash);
          break;
        case 8:
          aug.add(cash);
          break;
        case 9:
          sep.add(cash);
          break;
        case 10:
          oct.add(cash);
          break;
        case 11:
          nov.add(cash);
          break;
        case 12:
          dec.add(cash);
          break;
        default:
      }
    }
  }

  return Column(children: [
    Expanded(
      child: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                new BoxShadow(
                  color: Colors.grey.shade100,
                ),
              ],
            ),
            child: FutureBuilder(
                future: callApiCash(year),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    //var newMap = groupBy(snapshot.data, (obj) => obj['release_date']);
                    sortBymonth(snapshot.data);
                    return Column(
                      children: [
                        ExpansionTile(
                          title: Text("December"),
                          children: [cashMonthDisplay(dec, editPermission)],
                        ),
                        ExpansionTile(
                          title: Text("November"),
                          children: [cashMonthDisplay(nov, editPermission)],
                        ),
                        ExpansionTile(
                          title: Text("October"),
                          children: [cashMonthDisplay(oct, editPermission)],
                        ),
                        ExpansionTile(
                          title: Text("September"),
                          children: [cashMonthDisplay(sep, editPermission)],
                        ),
                        ExpansionTile(
                          title: Text("August"),
                          children: [cashMonthDisplay(aug, editPermission)],
                        ),
                        ExpansionTile(
                          title: Text("July"),
                          children: [cashMonthDisplay(july, editPermission)],
                        ),
                        ExpansionTile(
                          title: Text("June"),
                          children: [cashMonthDisplay(june, editPermission)],
                        ),
                        ExpansionTile(
                          title: Text("May"),
                          children: [cashMonthDisplay(may, editPermission)],
                        ),
                        ExpansionTile(
                          title: Text("April"),
                          children: [cashMonthDisplay(april, editPermission)],
                        ),
                        ExpansionTile(
                          title: Text("March"),
                          children: [cashMonthDisplay(mar, editPermission)],
                        ),
                        ExpansionTile(
                          title: Text("February"),
                          children: [cashMonthDisplay(feb, editPermission)],
                        ),
                        ExpansionTile(
                          title: Text("January"),
                          children: [cashMonthDisplay(jan, editPermission)],
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: Text("Loading..."),
                      ),
                    );
                  }
                })),
      ),
    ),
  ]);
}

Widget cashMonthDisplay(data, editPermission) {
  return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () {
            showCashTransaction(data[i], context, editPermission);
          },
          child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                new BoxShadow(
                  color: Colors.white,
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      // crossAxisAlignment:
                      //     CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 40,
                          children: [
                            // Padding(
                            //   padding:
                            //       EdgeInsets.fromLTRB(
                            //           0, 0, 24, 0),
                            // child:
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(2),
                              margin: EdgeInsets.only(
                                  left: 40), //symmetric(horizontal: 1.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade500,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                data[i].type,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: data[i].type == "IN"
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets
                            //           .fromLTRB(
                            //       24, 0, 24, 0),
                            //   child:
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade200,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                data[i].amount != null
                                    ? data[i].amount.toString() + " EUR"
                                    : "",
                              ),
                            ),
                            // ),
                            // Padding(
                            //   padding:
                            //       EdgeInsets.fromLTRB(
                            //           24, 0, 0, 0),
                            //   child:
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade500,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                data[i].status,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: data[i].status == "confirmed"
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Date: "),
                            Text(data[i].date != null ? data[i].date : ""),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Cash Box: "),
                            Text(
                                data[i].cashBox != null ? data[i].cashBox : ""),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Category: "),
                            Text(data[i].accountingPlan != null
                                ? data[i].accountingPlan
                                : ""),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}

void showCashTransaction(cash, context, editPermission) {
  showDialog(
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Reference: "),
                            Container(
                                margin: EdgeInsets.only(left: 45.0, right: 0.0),
                                child: Text(cash.ref))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Accommodation: "),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                                child: Text(cash.accommodation != null
                                    ? cash.accommodation
                                    : ""),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Booking: "),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.only(left: 50.0, right: 0.0),
                                child: Text(cash.guestName != null
                                    ? cash.guestName +
                                        " " +
                                        cash.guestFirstName +
                                        " (" +
                                        cash.firstNight +
                                        " -> " +
                                        cash.lastNight +
                                        ")"
                                    : ""),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Cash Box: "),
                            Flexible(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(left: 45.0, right: 0.0),
                                    child: Text(cash.cashBox))),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Accounting Plan: "),
                            Flexible(
                                child: Container(
                                    margin:
                                        EdgeInsets.only(left: 0.0, right: 0.0),
                                    child: Text(cash.accountingPlan))),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Amount: "),
                            Container(
                                margin: EdgeInsets.only(left: 50.0, right: 0.0),
                                child: Text(cash.amount.toString() + " EUR")),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Type: "),
                            Flexible(
                              child: Container(
                                  margin:
                                      EdgeInsets.only(left: 70.0, right: 0.0),
                                  child: Text(cash.type)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Date: "),
                            Container(
                                margin: EdgeInsets.only(left: 70.0, right: 0.0),
                                child: Text(cash.date)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Status: "),
                            Container(
                                margin: EdgeInsets.only(left: 60.0, right: 0.0),
                                child: Text(cash.status)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Description: "),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.only(left: 30.0, right: 0.0),
                                child: Text(
                                  cash.description,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Account: "),
                            Flexible(
                              child: Container(
                                  margin:
                                      EdgeInsets.only(left: 50.0, right: 0.0),
                                  child: Text(cash.account)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: editPermission
                                ? ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  EditCashTransaction(
                                                      id: cash.id)));
                                    },
                                    child: Text("Edit"))
                                : Text(""))
                      ],
                    ),
                  ),
                ))));
      });
}

class TabButton extends StatefulWidget {
  const TabButton(
      {Key? key,
      required this.title,
      required this.pageNumber,
      required this.selectedPage,
      required this.onPressed})
      : super(key: key);
  final String title;
  final int pageNumber;
  final int selectedPage;
  final VoidCallback onPressed;

  @override
  _TabButtonState createState() => _TabButtonState();
}

class _TabButtonState extends State<TabButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: Duration(microseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
            color: widget.selectedPage == widget.pageNumber
                ? Colors.blue.shade300
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4)),
        padding: EdgeInsets.symmetric(
            vertical: widget.selectedPage == widget.pageNumber ? 8 : 4,
            horizontal: widget.selectedPage == widget.pageNumber ? 15 : 7),
        margin: EdgeInsets.symmetric(
            vertical: widget.selectedPage == widget.pageNumber ? 5 : 0,
            horizontal: widget.selectedPage == widget.pageNumber ? 8 : 2),
        child: Text(
          widget.title,
          style: TextStyle(),
        ),
      ),
    );
  }
}
