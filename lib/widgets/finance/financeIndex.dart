import 'package:flutter/material.dart';
import 'package:Season/widgets/finance/paymentOders.dart';
import 'package:Season/widgets/finance/payouts.dart';
import 'package:Season/widgets/finance/yearlyPayouts.dart';

import '../../appBar.dart';
import '../../drawer.dart';
import '../cash_transactions/cashTransaction.dart';
import 'monthlyReport.dart';

class FinanceIndexWidget extends StatefulWidget {
  const FinanceIndexWidget({Key? key, required this.user}) : super(key: key);
  final user;
  @override
  _FinanceIndexWidgetState createState() => _FinanceIndexWidgetState();
}

class _FinanceIndexWidgetState extends State<FinanceIndexWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar("FINANCES", context, 1, widget.user),
        drawer: drawer(widget.user, context),
        body: SingleChildScrollView(
          child: Center(
              child: Container(
            padding: EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.money,
                      color: Colors.white,
                    ),
                    label: Text('Payment Orders',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14.0)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFFBD107)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PaymentOrderWidget()));
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.monetization_on_outlined,
                        color: Colors.white),
                    label: Text('Monthly Reports',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14.0)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF05A8CF)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  MonthlyReportWidget(user: widget.user)));
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.attach_money, color: Colors.white),
                    label: Text('Payouts               ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14.0)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF8B1FA9)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PayoutWidget(user: widget.user)));
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.euro_sharp, color: Colors.white),
                    label: Text('Cash Transactions',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14.0)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFF37540)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  CashTransactionWidget(user: widget.user)));
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.payments_outlined, color: Colors.white),
                    label: Text('Yearly Payouts Reports',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14.0)),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF54bf31)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  YearlyPayoutWidget(user: widget.user)));
                    },
                  ),
                ),
              ],
            ),
          )),
        ));
  }
}
