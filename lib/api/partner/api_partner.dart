import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:Season/models/partner/model_partner.dart';
import 'package:Season/services/api.dart';
import 'package:http/http.dart' as http;

class ApiPartner {
  ApiUrl url = new ApiUrl();
  Future<List<Partner>> getPartners() async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<Partner> partners = [];

    try {
      var data = await client.get(
        Uri.parse(apiUrl + 'apikey/partners'),
        headers: {
          'Accept': 'application/json',
          'content-type': 'application/json',
          'X-Authorization': apiKey,
        },
      );
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        for (var partner in jsonData) {
          partner = Partner(
              partner["id"],
              partner["business_name"] != null ? partner["business_name"] : "",
              partner["first_name"] != null ? partner["first_name"] : "",
              partner["last_name"] != null ? partner["last_name"] : "",
              partner["address1"] != null && partner["address1"] != ""
                  ? partner["address1"] + ","
                  : "",
              partner["address2"] != null && partner["address2"] != ""
                  ? partner["address2"]
                  : "",
              partner["address3"] != null && partner["address3"] != ""
                  ? partner["address3"] + ","
                  : "",
              partner["city"] != null ? partner["city"] : "");
          partners.add(partner);
        }
      }
    } catch (e) {
      client.close();
      print(e);
    }
    return partners;
  }

  Future<dynamic> getOnePartner(id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());

    try {
      var data = await client.get(
          Uri.parse(apiUrl + "hostings/partner/" + id.toString()),
          headers: {
            'Accept': 'application/json',
            // 'Access-Control-Allow-Origin': '*',
            // 'Access-Control-Allow-Headers': '*',
            'X-Authorization': apiKey,
          });
      if (data.statusCode == 200) {
        var partner = jsonDecode(data.body);
        OnePartner part = new OnePartner(
            partner["id"],
            partner["ref"] != null ? partner["ref"] : "",
            partner["genre"] != null ? partner["genre"] : "",
            partner["legal_status"] != null ? partner["legal_status"] : "",
            partner["status"] != null ? partner["status"] : "",
            partner["business_name"] != null ? partner["business_name"] : "",
            partner["first_name"] != null ? partner["first_name"] : "",
            partner["last_name"] != null ? partner["last_name"] : "",
            partner["address1"] != null ? partner["address1"] : "",
            partner["address2"] != null ? partner["address2"] : "",
            partner["address3"] != null ? partner["address3"] : "",
            partner["city"] != null ? partner["city"] : "",
            partner["surname"] != null ? partner["surname"] : "",
            partner["bank_details"] != null
                ? Text(partner["bank_details"])
                : Text(""),
            partner["email"] != null ? Text(partner["email"]) : Text(""),
            partner["fixed_line_number"] != null
                ? partner["fixed_line_number"]
                : "",
            partner["mobile_phone_number"] != null
                ? partner["mobile_phone_number"]
                : "",
            partner["other_phone_number"] != null
                ? partner["other_phone_number"]
                : "",
            partner["website"] != null ? partner["website"] : "",
            partner["preferred_means_of_contact"] != null
                ? partner["preferred_means_of_contact"]
                : "",
            partner["type"] != null ? partner["type"] : "",
            partner["conctact_name"] != null ? partner["conctact_name"] : "",
            partner["state"] != null ? partner["state"] : "",
            partner["entity_type"] != null ? partner["entity_type"] : "",
            partner["comment"] != null ? Text(partner["comment"]) : Text(""),
            partner["nature"] != null ? partner["nature"] : "");
        return part;
      } else {
        return null;
      }
    } catch (e) {
      return e;
    }
  }
}
