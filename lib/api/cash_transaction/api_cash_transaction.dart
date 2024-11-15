import 'dart:convert';
import 'package:http/retry.dart';
import 'package:Season/services/api.dart';
import 'package:http/http.dart' as http;

import '../../models/cash_transaction/model_cash_transaction.dart';

class ApiCashTransaction {
  ApiUrl url = new ApiUrl();

  Future<List<CashTransaction>> getCashTransaction(year) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<CashTransaction> cashTransactions = [];
    try {
      var data = await client.get(
        Uri.parse(
            apiUrl + 'apikey/finances/cash-transactions/' + year.toString()),
        headers: {
          'Accept': 'application/json',
          'content-type': 'application/json',
          'X-Authorization': apiKey,
        },
      );
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        for (var cash in jsonData["data"]) {
          CashTransaction cashTrans = new CashTransaction(
              cash["id"],
              cash["accommodation"],
              cash["account"],
              cash["accounting_plan"],
              cash["ammount"],
              cash["firstNight"],
              cash["lastNight"],
              cash["cash_box"],
              cash["guestFirstName"],
              cash["guestName"],
              cash["created_by_user_id"],
              cash["date"],
              cash["description"],
              cash["ref"],
              cash["status"],
              cash["type"],
              cash["year"],
              cash["created_at"]);
          cashTransactions.add(cashTrans);
        }
      } else {
        //print(data.statusCode);
      }
    } catch (e) {
      client.close();
      print(e);
    }
    // print(cashTransactions);
    return cashTransactions;
  }

  Future<dynamic> getYear() async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    dynamic years = [];
    try {
      var data = await client.get(
        Uri.parse(apiUrl + 'apikey/finances/cash-transactions/all/years'),
        headers: {
          'Accept': 'application/json',
          'content-type': 'application/json',
          'X-Authorization': apiKey,
        },
      );
      if (data.statusCode == 200) {
        years = jsonDecode(data.body);
      }
    } catch (e) {
      client.close();
      print(e);
    }
    return years;
  }

  Future<dynamic> getFormData() async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    dynamic formData = [];
    try {
      var data = await client.get(
        Uri.parse(apiUrl + 'apikey/finances/cash-transactions/getFormData'),
        headers: {
          'Accept': 'application/json',
          'content-type': 'application/json',
          'X-Authorization': apiKey,
        },
      );
      if (data.statusCode == 200) {
        formData = jsonDecode(data.body);
      }
    } catch (e) {
      client.close();
      print(e);
    }
    return formData;
  }

  Future<int> postCashTransaction(formData) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.post(
          Uri.parse(apiUrl + 'apikey/finances/cash-transactions/postData'),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json',
            'X-Authorization': apiKey,
          },
          body: jsonEncode(<String, dynamic>{
            'accommodation_id': formData["accommodation"],
            'booking_id': formData["booking"],
            'currency_id': formData["currency"],
            'accounting_plan_id': formData["accounting_plan"],
            'cash_box_id': formData["cash_box"],
            'created_by_user_id': formData["created_by_user_id"],
            'date': formData["date"],
            'status': formData["status"],
            'type': formData["type"] == "income" ? "IN" : "OUT",
            'ammount': formData["ammount"],
            'account': formData["account"],
            'year': formData["year"],
            'description': formData["description"],
          }));

      return data.statusCode;
    } catch (e) {
      client.close();
      print(e);
      return throw Exception(e);
    }
  }

  Future<OneItemCashTransaction> getOneTransaction(id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    var cashTransaction;
    try {
      var data = await client.get(
        Uri.parse(
            apiUrl + 'apikey/finances/cash-transactions/get/' + id.toString()),
        headers: {
          'Accept': 'application/json',
          'content-type': 'application/json',
          'X-Authorization': apiKey,
        },
      );
      if (data.statusCode == 200) {
        var cash = jsonDecode(data.body);
        OneItemCashTransaction cashTrans = new OneItemCashTransaction(
            cash["id"],
            cash["accommodation_id"],
            cash["booking_id"],
            cash["currency_id"],
            cash["accounting_plan_id"],
            cash["cash_box_id"],
            cash["created_by_user_id"],
            cash["date"],
            cash["status"],
            cash["type"],
            cash["ammount"].toDouble(),
            cash["account"],
            cash["description"]);
        cashTransaction = cashTrans;
      }
    } catch (e) {
      client.close();
      print(e);
    }
    return cashTransaction;
  }

  Future<int> putCashTransaction(formData, id, user) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.put(
          Uri.parse(
              apiUrl + 'apikey/finances/cash-transactions/' + id.toString()),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json',
            'X-Authorization': apiKey,
          },
          body: jsonEncode(<String, dynamic>{
            'accommodation_id': formData["accommodation"],
            'booking_id': formData["booking"],
            'currency_id': formData["currency"],
            'accounting_plan_id': formData["accounting_plan"],
            'cash_box_id': formData["cash_box"],
            'created_by_user_id': user,
            'date': formData["date"],
            'status': formData["status"],
            'type': formData["type"] == "income" ? "IN" : "OUT",
            'ammount': formData["ammount"],
            'account': formData["account"],
            'year': formData["year"],
            'description': formData["description"],
          }));

      return data.statusCode;
    } catch (e) {
      client.close();
      print(e);
      return throw Exception(e);
    }
  }
}
