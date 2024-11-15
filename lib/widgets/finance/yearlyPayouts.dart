import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Season/homeBottomMenu.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:http/http.dart' show get;
import 'package:path_provider/path_provider.dart';

import '../../api/finance/api_finance.dart';
import '../../models/finance/model_finance.dart';
import '../../services/api.dart';

class YearlyPayoutWidget extends StatefulWidget {
  const YearlyPayoutWidget({Key? key, required this.user}) : super(key: key);
  final user;
  @override
  State<YearlyPayoutWidget> createState() => _YearlyPayoutWidgetState();
}

class _YearlyPayoutWidgetState extends State<YearlyPayoutWidget> {
  TextEditingController searchController = new TextEditingController();
  String filter = "";
  bool isLoading = false;

  @override
  void initState() {
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    super.initState();
  }

  int _seletedPage = 0;
  bool change = false;
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> loadPdfFromUrl(contract, year) async {
    ApiUrl url = new ApiUrl();
    String apiUrl = url.getUrl();
    var link = apiUrl +
        'tools/document/download?document=DOC00006&object=' +
        contract.toString() +
        '&year=' +
        year +
        '&save=true';
    var response = await get(Uri.parse(link));
    var data = response.bodyBytes;
    //Create a new PDF document
    PdfDocument document = PdfDocument(inputBytes: data);
    //Save and launch the document
    final List<int> bytes = document.save() as List<int>;
    //Dispose the document.
    document.dispose();

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/Flutter_Succinctly.pdf');
    await file.writeAsBytes(bytes, flush: true);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //Open the fine.
    OpenFile.open('$path/Flutter_Succinctly.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final apiFinance = new ApiFinance();
    Future<dynamic> getYearlyPayouts(filter) {
      return apiFinance.getYearlyPayouts(filter);
    }

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
                MaterialPageRoute(builder: (_) => HomeBottomMenu(index: 2)));
          },
        ),
        title: Text("YEARLY PAYOUT REPORTS",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topRight,
                  width: 300,
                  height: 45,
                  child: Padding(
                    padding: new EdgeInsets.all(5.0),
                    child: new TextField(
                      onChanged: (value) {
                        setState(() {
                          filter = value.toLowerCase();
                        });
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Divider(
                    height: 1,
                    thickness: 2,
                    indent: 10,
                    endIndent: 0,
                    color: Colors.grey,
                  ),
                ),
                FutureBuilder(
                    future: getYearlyPayouts(filter),
                    builder: (context, AsyncSnapshot snap) {
                      List<String> accommodations = [];
                      List<String> years = [];
                      if (snap.data == null) {
                        return Container(
                          child: Center(
                            child: Text("Loading..."),
                          ),
                        );
                      } else {
                        if (snap.data.length > 0)
                          snap.data.forEach((key, values) {
                            accommodations.add(key);
                            values.forEach((item) {
                              if (!years.contains(item['year']))
                                years.add(item['year']);
                            });
                          });
                        years.sort((a, b) => a.compareTo(b));
                        _pageController =
                            PageController(initialPage: years.length - 1);
                        if (!change) _seletedPage = years.length - 1;
                        return snap.data.length > 0
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            for (int i = 0;
                                                i < years.length;
                                                i++)
                                              TabButton(
                                                title: years[i],
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      constraints: BoxConstraints(
                                          minHeight: 100,
                                          minWidth: double.infinity,
                                          maxHeight: MediaQuery.of(context)
                                              .size
                                              .height),
                                      child: PageView(
                                        onPageChanged: (int page) {
                                          setState(() {
                                            _seletedPage = page;
                                          });
                                        },
                                        controller: _pageController,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          for (var i = 0; i < years.length; i++)
                                            yearlyReports(
                                                context,
                                                accommodations,
                                                snap.data,
                                                years[i]),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Center(
                                  child: Text("Noting to display"),
                                ));
                      }
                    })
              ],
            )),
      ),
    );
  }

  Widget yearlyReports(context, accommodations, data, year) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: accommodations.length,
        itemBuilder: (context, i) {
          var payouts =
              data[accommodations[i]].where((i) => i['year'] == year).toList();
          return payouts.length > 0
              ? ExpansionTile(
                  leading: TextButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Load data...'),
                            duration: Duration(seconds: 30),
                          ),
                        );
                        loadPdfFromUrl(payouts[0]["contract_id"], year);
                      },
                      child: Icon(
                        Icons.download,
                        size: 20,
                        color: Colors.black,
                      )),
                  title: Text(accommodations[i]),
                  children: [
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: payouts.length,
                        itemBuilder: (context, j) {
                          return payouts[j]['year'] == year
                              ? GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 150,
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
                                            child: Row(children: [
                                          Text(
                                            "Rental income " +
                                                payouts[j]['offer'] +
                                                " " +
                                                DateFormat.MMMM('en_US').format(
                                                    DateTime.parse(payouts[j]
                                                        ['period_start'])),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ])),
                                        SizedBox(height: 15),
                                        Flexible(
                                            child: Row(children: [
                                          Text("Amount: "),
                                          Text(
                                            payouts[j]['amount'].toString() +
                                                " " +
                                                payouts[j]['code'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ])),
                                        SizedBox(height: 15),
                                        Flexible(
                                            child: Row(
                                          children: [
                                            Text("Payment date: "),
                                            Text(
                                              payouts[j]['payout_date'] != null
                                                  ? DateFormat('dd.MM.yyyy')
                                                      .format(DateTime.parse(
                                                          payouts[j]
                                                              ['payout_date']))
                                                  : "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                        SizedBox(height: 15),
                                        Flexible(
                                            child: Row(children: [
                                          Text("Payment method: "),
                                          Text(
                                            "Bank transfert",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ])),
                                      ],
                                    ),
                                  ))
                              : Container();
                        })
                  ],
                )
              : Container();
        });
  }
}
