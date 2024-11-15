import 'dart:convert';
import 'package:http/retry.dart';
import 'package:http/http.dart' as http;

import '../../services/api.dart';

class ApiMarketingReview {
  ApiUrl url = new ApiUrl();

  Future<dynamic> getOccypacyRate(month, year) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl +
              "apikey/marketing-review?month=" +
              month +
              "&year=" +
              year.toString()),
          headers: {
            'Accept': 'application/json',
            // 'Access-Control-Allow-Origin': '*',
            // 'Access-Control-Allow-Headers': '*',
            'X-Authorization': apiKey,
          });
      var jsonData = jsonDecode(data.body);
      return jsonData;
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }

  Future<dynamic> getRevenue(month, year) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl +
              "apikey/revenue?month=" +
              month +
              "&year=" +
              year.toString()),
          headers: {
            'Accept': 'application/json',
            // 'Access-Control-Allow-Origin': '*',
            // 'Access-Control-Allow-Headers': '*',
            'X-Authorization': apiKey,
          });
      var jsonData = jsonDecode(data.body);
      return jsonData;
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }
}
