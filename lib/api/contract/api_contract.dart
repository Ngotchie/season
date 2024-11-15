import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/retry.dart';
import 'package:Season/models/contract/model_contract.dart';
import 'package:Season/services/api.dart';
import 'package:http/http.dart' as http;

class ApiContract {
  ApiUrl url = new ApiUrl();
  Future<List<Contract>> getContracts() async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<Contract> contracts = [];

    try {
      var data = await client.get(
        Uri.parse(apiUrl + 'apikey/contracts'),
        headers: {
          'Accept': 'application/json',
          'content-type': 'application/json',
          'X-Authorization': apiKey,
        },
      );
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        for (var contract in jsonData) {
          contract = Contract(
              contract["id"],
              contract["internal_name"] != null
                  ? contract["internal_name"]
                  : "",
              contract["business_name"] != null
                  ? contract["business_name"]
                  : "",
              contract["first_name"] != null ? contract["first_name"] : "",
              contract["last_name"] != null ? contract["last_name"] : "",
              contract["name"] != null ? contract["name"] : "",
              contract["contract_status"] != null
                  ? contract["contract_status"]
                  : "");
          contracts.add(contract);
        }
      }
    } catch (e) {
      client.close();
      print(e);
    }
    return contracts;
  }

  Future<dynamic> getOneContract(id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl + "apikey/contract/" + id.toString()),
          headers: {
            'Accept': 'application/json',
            'X-Authorization': apiKey,
          });
      if (data.statusCode == 200) {
        var contract = jsonDecode(data.body);
        contract = contract[0];
        var bName =
            contract["business_name"] != null ? contract["business_name"] : "";
        var fName =
            contract["first_name"] != null ? contract["first_name"] : "";
        var lName = contract["last_name"] != null ? contract["last_name"] : "";
        var supplies = jsonDecode(contract["supplies_list"]);
        OneContract cnt = new OneContract(
            contract["id"],
            contract["ref"] != null ? contract["ref"] : "",
            contract["name"] != null ? contract["name"] : "",
            contract["status"] != null ? contract["status"] : "",
            contract["currency"] != null ? contract["currency"] : "",
            contract["accommodation"] != null ? contract["accommodation"] : "",
            bName + "" + fName + " " + lName,
            contract["partner_type"] != null ? contract["partner_type"] : "",
            contract["start_date"] != null ? contract["start_date"] : "",
            contract["end_date"] != null ? contract["end_date"] : "",
            contract["commitment_period_in_months"] != null
                ? contract["commitment_period_in_months"]
                : 0,
            contract["contract_signing_date"] != null
                ? contract["contract_signing_date"]
                : "",
            contract["commission_rate"] != null
                ? contract["commission_rate"]
                : 0,
            contract["guaranteed_deposit"] != null
                ? contract["guaranteed_deposit"]
                : 0,
            contract["cleaning_fees"] != null ? contract["cleaning_fees"] : 0,
            contract["cleaning_fees_for_partner"] != null
                ? contract["cleaning_fees_for_partner"]
                : 0.0,
            contract["travelers_deposit"] != null
                ? contract["travelers_deposit"]
                : 0,
            contract["emergency_envelope"] != null
                ? contract["emergency_envelope"]
                : 0,
            contract["supplies_base_price"] != null
                ? contract["supplies_base_price"]
                : 0,
            contract["bank_details"] != null
                ? Text(contract["bank_details"])
                : Text(""),
            contract["payment_date"] != null ? contract["payment_date"] : "",
            contract["breakfast_included"] != null
                ? contract["breakfast_included"]
                : false,
            contract["supplies_managed_by"] != null
                ? contract["supplies_managed_by"]
                : "",
            contract["retraction_delay"] != null
                ? contract["retraction_delay"]
                : 0,
            contract["cleaning_duration"] != null
                ? contract["cleaning_duration"]
                : 0,
            contract["termination_notice_duration"] != null
                ? contract["termination_notice_duration"]
                : 0,
            contract["reservation_notice_duration"] != null
                ? contract["reservation_notice_duration"]
                : 0,
            contract["partner_booking_range"] != null
                ? contract["partner_booking_range"]
                : 0,
            contract["special_clauses"] != null
                ? Text(contract["special_clauses"])
                : Text(""),
            supplies);

        return cnt;
      } else {
        return null;
      }
    } catch (e) {
      return e;
    }
  }
}
