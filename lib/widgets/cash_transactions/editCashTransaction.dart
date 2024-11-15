import 'package:flutter/material.dart';
import 'package:Season/api/cash_transaction/api_cash_transaction.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:Season/models/cash_transaction/model_cash_transaction.dart';

class EditCashTransaction extends StatefulWidget {
  const EditCashTransaction({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  _EditCashTransactionState createState() => _EditCashTransactionState();
}

class _EditCashTransactionState extends State<EditCashTransaction> {
  ApiCashTransaction apiCash = ApiCashTransaction();
  var currentCash;
  @override
  void initState() {
    super.initState();
    getCashTransaction(widget.id).then((result) {
      setState(() {
        currentCash = result;
        accommodationValue = currentCash.accommodationId;
        bookingValue = currentCash.bookingId;
        accountingPlanValue = currentCash.accountingPlanId;
        currencyValue = currentCash.currencyId;
        cashBoxValue = currentCash.cashBoxId;
        transactionTypeValue = currentCash.type == 'IN' ? 'income' : 'outcome';
        statusValue = currentCash.status;
        amountController.text = currentCash.ammount.toString();
        dateController.text = currentCash.date;
        descriptionController.text = currentCash.description;
        accountController.text = currentCash.account;
      });
    });
  }

  Future<Object> getCashTransaction(id) {
    return apiCash.getOneTransaction(id);
  }

  Future<dynamic> getFormData() {
    return apiCash.getFormData();
  }

  var response = new Map();
  //TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  List<String> listType = ['income', 'outcome'];
  List<String> listStatus = ['pending', 'confirmed', 'cancelled'];
  int? accommodationValue;
  int? bookingValue;
  int? accountingPlanValue;
  int? currencyValue;
  int? cashBoxValue;
  String transactionTypeValue = '';
  String statusValue = '';

  final format = DateFormat("yyyy-MM-dd");

  // set the formkey for validation
  var _formkey = GlobalKey<FormState>();

  var amountController = TextEditingController();
  var dateController = TextEditingController();
  var descriptionController = TextEditingController();
  var accountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var accommodations = [];
    var bookings = [];
    var currencies = [];
    var cashBoxes = [];
    var accountingPlans = [];

    return Scaffold(
        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF05A8CF),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Edit Cash Transaction",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: FutureBuilder(
            future: getFormData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data != null) {
                accommodations = [];
                for (var item in snapshot.data[0]) {
                  FormAccommodation acc = new FormAccommodation(
                      item["id"], item["ref"], item["internal_name"]);
                  accommodations.add(acc);
                }
                bookings = [];
                for (var item in snapshot.data[1]) {
                  FormBooking bkg = new FormBooking(
                      item["id"],
                      "${DateTime.parse(item["firstNight"]).year}-${DateTime.parse(item["firstNight"]).month}-${DateTime.parse(item["firstNight"]).day}",
                      item["guestFirsName"] != null
                          ? item["guestFirsName"]
                          : "",
                      item["guestName"] != null ? item["guestName"] : "",
                      "${DateTime.parse(item["lastNight"]).year}-${DateTime.parse(item["lastNight"]).month}-${DateTime.parse(item["lastNight"]).day}",
                      item["referer"]);
                  bookings.add(bkg);
                }
                currencies = [];
                for (var item in snapshot.data[4]) {
                  FormCurrency c =
                      new FormCurrency(item["id"], item["code"], item["name"]);
                  currencies.add(c);
                }
                cashBoxes = [];
                for (var item in snapshot.data[2]) {
                  FormCashBoxes ch =
                      new FormCashBoxes(item["id"], item["name"]);
                  cashBoxes.add(ch);
                }
                accountingPlans = [];
                for (var item in snapshot.data[3]) {
                  FormAccountingPlan accPl =
                      new FormAccountingPlan(item["id"], item["name"]);
                  accountingPlans.add(accPl);
                }
                //print(accommodations.length);
                final accommodationField = DropdownButtonFormField(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Choose accommodation...",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  //key: UniqueKey(),
                  onChanged: (newValue) {
                    setState(() {
                      accommodationValue = newValue as int;
                    });
                    //print(accommodations.length);
                  },
                  items: accommodations.map<DropdownMenuItem<int>>((item) {
                    return DropdownMenuItem(
                      value: item.id,
                      child: Text(
                        item.ref.toString() +
                            "-" +
                            item.internalName.toString(),
                      ),
                    );
                  }).toList(),
                  value: accommodationValue,
                );
                final bookingField = DropdownButtonFormField(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Choose booking...",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  value: bookingValue,
                  items: bookings.map<DropdownMenuItem<int>>((item) {
                    return DropdownMenuItem(
                      value: item.id,
                      child: Text(item.referer.toString() +
                          "-" +
                          item.guestName +
                          " " +
                          item.guestFirstName +
                          "-" +
                          item.firstNight +
                          "->" +
                          item.lastNight),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      bookingValue = newValue as int;
                    });
                  },
                );
                final cashBoxField = DropdownButtonFormField(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Choose cash box...",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  value: cashBoxValue,
                  items: cashBoxes.map<DropdownMenuItem<int>>((item) {
                    return DropdownMenuItem(
                      value: item.id,
                      child: Text(
                        item.name.toString(),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      cashBoxValue = newValue as int;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Cash box can\'t be empty';
                    }
                    return null;
                  },
                );
                final accountingPlanField = DropdownButtonFormField(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Choose accounting plan...",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  value: accountingPlanValue,
                  items: accountingPlans.map<DropdownMenuItem<int>>((item) {
                    return DropdownMenuItem(
                      value: item.id,
                      child: Text(
                        item.name.toString(),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      accountingPlanValue = newValue as int;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Accounting plan can\'t be empty';
                    }
                    return null;
                  },
                );
                final amountField = TextFormField(
                  obscureText: false,
                  //style: style,
                  keyboardType: TextInputType.number,
                  controller: amountController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: "Transaction amount...",
                    // prefix: Text('*'),
                    // prefixStyle: TextStyle(color: Colors.red, inherit: false),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Transaction amount can\'t be empty';
                    }
                    return null;
                  },
                );
                final currencyField = DropdownButtonFormField(
                  // hint: Text("Choose currency..."),
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Choose currency",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  value: currencyValue,
                  items: currencies.map<DropdownMenuItem<int>>((item) {
                    return DropdownMenuItem(
                      value: item.id,
                      child: Text(
                        item.name.toString() + "(" + item.code.toString() + ")",
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      currencyValue = newValue as int;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Currency can\'t be empty';
                    }
                    return null;
                  },
                );
                final typeTransactionField = DropdownButtonFormField(
                  value: transactionTypeValue,
                  decoration: InputDecoration(
                    labelText: "Choose Transaction Type",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      transactionTypeValue = newValue!;
                    });
                  },
                  items: listType.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value.toString(),
                      ),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Transaction type can\'t be empty';
                    }
                    return null;
                  },
                );
                final dateFormField = DateTimeField(
                    format: format,
                    controller: dateController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      labelText: "Choose date...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                    validator: null);
                final statusField = DropdownButtonFormField(
                  value: statusValue,
                  decoration: InputDecoration(
                    labelText: "Choose the transaction status",
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      statusValue = newValue!;
                    });
                  },
                  items:
                      listStatus.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value.toString(),
                      ),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Transaction status can\'t be empty';
                    }
                    return null;
                  },
                );
                final descriptionField = TextFormField(
                  obscureText: false,
                  //style: style,
                  minLines: 5,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    labelText: "Transaction description...",
                    // prefix: Text('*'),
                    // prefixStyle: TextStyle(color: Colors.red, inherit: false),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  validator: null,
                );
                final accountField = TextFormField(
                  obscureText: false,
                  //style: style,
                  keyboardType: TextInputType.text,
                  controller: accountController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    labelText: "Transaction account...",
                    // prefix: Text('*'),
                    // prefixStyle: TextStyle(color: Colors.red, inherit: false),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  validator: null,
                );
                return Form(
                  key: _formkey,
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(12.0),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.grey.shade100,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          accommodationField,
                          SizedBox(
                            height: 20,
                          ),
                          bookingField,
                          SizedBox(
                            height: 20,
                          ),
                          cashBoxField,
                          SizedBox(
                            height: 20,
                          ),
                          accountingPlanField,
                          SizedBox(
                            height: 20,
                          ),
                          amountField,
                          SizedBox(
                            height: 20,
                          ),
                          currencyField,
                          SizedBox(
                            height: 20,
                          ),
                          typeTransactionField,
                          SizedBox(
                            height: 20,
                          ),
                          dateFormField,
                          SizedBox(
                            height: 20,
                          ),
                          statusField,
                          SizedBox(
                            height: 20,
                          ),
                          descriptionField,
                          SizedBox(
                            height: 20,
                          ),
                          accountField,
                          SizedBox(
                            height: 20,
                          ),
                          new ElevatedButton(
                              child: new Text('Save'),
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  this.response["accommodation"] =
                                      accommodationValue;
                                  this.response["booking"] = bookingValue;
                                  this.response["currency"] = currencyValue;
                                  this.response["accounting_plan"] =
                                      accountingPlanValue;
                                  this.response["cash_box"] = cashBoxValue;
                                  this.response["date"] = dateController.text;
                                  this.response["status"] = statusValue;
                                  this.response["type"] = transactionTypeValue;
                                  this.response["ammount"] =
                                      amountController.text;
                                  this.response["account"] =
                                      accountController.text;
                                  this.response["year"] =
                                      DateTime.parse(dateController.text).year;
                                  this.response["description"] =
                                      descriptionController.text;
                                  _putData(response);
                                  // print(this.response.toString());
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  child: Center(
                    child: Text("Loading data...",
                        style: TextStyle(fontSize: 16, color: Colors.blue)),
                  ),
                );
              }
            }));
  }

  _putData(formData) async {
    var resp = await apiCash.putCashTransaction(
        formData, widget.id, currentCash.createdByUserId);
    if (resp == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cash transaction editing succefully')),
      );
      //Navigator.pop(context);
      Navigator.pushNamed(context, '/cashTransaction');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during edit cash transaction')),
      );
    }
  }
}
