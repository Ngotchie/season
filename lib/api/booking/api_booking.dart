import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:Season/models/booking/model_booking.dart';
import 'package:http/http.dart' as http;
import 'package:Season/services/api.dart';

class ApiBooking {
  ApiUrl url = new ApiUrl();
  Future<List<Booking>> getBookings(range) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<Booking> bookings = [];
    var se = range.split("=>");
    try {
      var data = await client.get(
          Uri.parse(apiUrl + 'apikey/bookings/' + se[0] + '/' + se[1]),
          headers: {
            'Accept': 'application/json',
            'X-Authorization': apiKey,
          });
      // print(data.body);
      var jsonData = jsonDecode(data.body);
      for (var book in jsonData) {
        Booking booking = new Booking(
          book["id"] != null ? book["id"] : 0,
          book["accommodation"] != null ? book["accommodation"] : "",
          book["lastNight"] != null ? book["lastNight"] : "",
          book["firstNight"] != null ? book["firstNight"] : "",
          book["guestFirstName"] != null ? book["guestFirstName"] : "",
          book["guestName"] != null ? book["guestName"] : "",
          book["referer"] != null ? book["referer"] : "",
          book["status"] != null ? book["status"] : 0,
          book['payment_status'] != null ? book['payment_status'] : "",
          book["price"] != null ? book["price"] : 0,
          book["country"] != null ? book["country"] : "",
          book["guestPhone"] != null ? book["guestPhone"] : "",
          book["currency"] != null ? book["currency"] : "",
          book["guestArrivalTime"] != null ? book["guestArrivalTime"] : "",
          book["bookingTime"] != null ? book["bookingTime"] : "",
        );
        bookings.add(booking);
      }
    } catch (e) {
      print(e);
      client.close();
    }
    return bookings;
  }

  Future<List<Booking>> ongoingBookings() async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<Booking> bookings = [];
    try {
      var data = await client
          .get(Uri.parse(apiUrl + 'apikey/bookings/ongoing'), headers: {
        'Accept': 'application/json',
        'X-Authorization': apiKey,
      });
      // print(data.body);
      var jsonData = jsonDecode(data.body);
      for (var book in jsonData) {
        Booking booking = new Booking(
          book["id"] != null ? book["id"] : 0,
          book["accommodation"] != null ? book["accommodation"] : "",
          book["lastNight"] != null ? book["lastNight"] : "",
          book["firstNight"] != null ? book["firstNight"] : "",
          book["guestFirstName"] != null ? book["guestFirstName"] : "",
          book["guestName"] != null ? book["guestName"] : "",
          book["referer"] != null ? book["referer"] : "",
          book["status"] != null ? book["status"] : 0,
          book['payment_status'] != null ? book['payment_status'] : "",
          book["price"] != null ? book["price"] : 0,
          book["country"] != null ? book["country"] : "",
          book["guestPhone"] != null ? book["guestPhone"] : "",
          book["currency"] != null ? book["currency"] : "",
          book["guestArrivalTime"] != null ? book["guestArrivalTime"] : "",
          book["bookingTime"] != null ? book["bookingTime"] : "",
        );
        bookings.add(booking);
      }
    } catch (e) {
      print(e);
      client.close();
    }
    return bookings;
  }

  Future<List<Booking>> futureBookings() async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<Booking> bookings = [];
    try {
      var data = await client
          .get(Uri.parse(apiUrl + 'apikey/bookings/future'), headers: {
        'Accept': 'application/json',
        'X-Authorization': apiKey,
      });
      // print(data.body);
      var jsonData = jsonDecode(data.body);
      for (var book in jsonData) {
        Booking booking = new Booking(
          book["id"] != null ? book["id"] : 0,
          book["accommodation"] != null ? book["accommodation"] : "",
          book["lastNight"] != null ? book["lastNight"] : "",
          book["firstNight"] != null ? book["firstNight"] : "",
          book["guestFirstName"] != null ? book["guestFirstName"] : "",
          book["guestName"] != null ? book["guestName"] : "",
          book["referer"] != null ? book["referer"] : "",
          book["status"] != null ? book["status"] : 0,
          book['payment_status'] != null ? book['payment_status'] : "",
          book["price"] != null ? book["price"] : 0,
          book["country"] != null ? book["country"] : "",
          book["guestPhone"] != null ? book["guestPhone"] : "",
          book["currency"] != null ? book["currency"] : "",
          book["guestArrivalTime"] != null ? book["guestArrivalTime"] : "",
          book["bookingTime"] != null ? book["bookingTime"] : "",
        );
        bookings.add(booking);
      }
    } catch (e) {
      print(e);
      client.close();
    }
    return bookings;
  }

  Future<List<Booking>> newBookings(page, limit) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<Booking> bookings = [];
    try {
      var data = await client.get(
          Uri.parse(apiUrl +
              'apikey/bookings/future?limit=' +
              limit.toString() +
              "&page=" +
              page.toString()),
          headers: {
            'Accept': 'application/json',
            'X-Authorization': apiKey,
          });
      // print(data.body);
      var jsonData = jsonDecode(data.body);
      for (var book in jsonData) {
        Booking booking = new Booking(
          book["id"] != null ? book["id"] : 0,
          book["accommodation"] != null ? book["accommodation"] : "",
          book["lastNight"] != null ? book["lastNight"] : "",
          book["firstNight"] != null ? book["firstNight"] : "",
          book["guestFirstName"] != null ? book["guestFirstName"] : "",
          book["guestName"] != null ? book["guestName"] : "",
          book["referer"] != null ? book["referer"] : "",
          book["status"] != null ? book["status"] : 0,
          book['payment_status'] != null ? book['payment_status'] : "",
          book["price"] != null ? book["price"] : 0,
          book["country"] != null ? book["country"] : "",
          book["guestPhone"] != null ? book["guestPhone"] : "",
          book["currency"] != null ? book["currency"] : "",
          book["guestArrivalTime"] != null ? book["guestArrivalTime"] : "",
          book["bookingTime"] != null ? book["bookingTime"] : "",
        );
        bookings.add(booking);
      }
    } catch (e) {
      print(e);
      client.close();
    }
    return bookings;
  }

  Future<dynamic> getOneBooking(id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client
          .get(Uri.parse(apiUrl + "apikey/booking/" + id.toString()), headers: {
        'Accept': 'application/json',
        'X-Authorization': apiKey,
      });
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        var booking = jsonData;
        OneBooking oneBooking = new OneBooking(
            id,
            booking["referer"] != null ? booking["referer"] : "",
            booking["bookId"] != null ? booking["bookId"] : 0,
            booking["propId"] != null ? booking["propId"] : 0,
            booking["bookingTime"] != null ? booking["bookingTime"] : "",
            booking["firstNight"] != null ? booking["firstNight"] : "",
            booking["lastNight"] != null ? booking["lastNight"] : "",
            booking["numAdult"] != null ? booking["numAdult"] : 0,
            booking["numChild"] != null ? booking["numChild"] : 0,
            booking["guestArriveTime"] != null
                ? booking["guestArriveTime"]
                : "",
            booking["guestTitle"] != null ? booking["guestTitle"] : "",
            booking["guestFirstName"] != null ? booking["guestFirstName"] : "",
            booking["guestName"] != null ? booking["guestName"] : "",
            booking["guestEmail"] != null ? booking["guestEmail"] : "",
            booking["guestPhone"] != null ? booking["guestPhone"] : "",
            booking["guestMobile"] != null ? booking["guestMobile"] : "",
            booking["guestFax"] != null ? booking["guestFax"] : "",
            booking["guestCompagny"] != null ? booking["guestCompagny"] : "",
            booking["guestAddress"] != null ? booking["guestAddress"] : "",
            booking["guestCity"] != null ? booking["guestCity"] : "",
            booking["guestState"] != null ? booking["guestState"] : "",
            booking["guestPostCode"] != null ? booking["guestPostCode"] : "",
            booking["guestCountry"] != null ? booking["guestCountry"] : "",
            booking["guestComments"] != null
                ? Text(booking["guestComments"])
                : Text(""),
            booking["notes"] != null ? Text(booking["notes"]) : Text(""),
            booking["price"] != null ? booking["price"] : 0,
            booking["multiplier"] != null
                ? booking["multiplier"]
                : "Not defined",
            booking["deposit"] != null ? booking["deposit"] : 0,
            booking["tax"] != null ? booking["tax"] : 0,
            booking["commission"] != null ? booking["commission"] : 0,
            booking["currency"] != null ? booking["currency"] : "",
            booking["rateDescription"] != null
                ? Text(booking["rateDescription"])
                : Text(""));
        return oneBooking;
      } else {
        return null;
      }
      // accommodations.add(newAcc);
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }

  Future<dynamic> getMessages(propId, bookId) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var headers = {
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': '*',
        'X-Authorization': apiKey,
      };

      Dio dio = new Dio();
      dio.options.headers["X-Authorization"] = apiKey;
      dio.options.headers["Accept"] = 'application/json';
      var response = await dio.get(
        apiUrl + 'tools/messages/list',
        queryParameters: {
          'bookId': bookId,
          'propId': propId,
        },
      );
      return response.data;
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }

  Future<List<Workflow>> getWorkflow() async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<Workflow> workflows = [];

    try {
      var data = await client
          .get(Uri.parse(apiUrl + 'apikey/bookings/workflow'), headers: {
        'Accept': 'application/json',
        'X-Authorization': apiKey,
      });
      var jsonData = jsonDecode(data.body);
      for (var workflow in jsonData) {
        Workflow wk = new Workflow(
            workflow['id'],
            workflow['accommodation_id'],
            workflow['accommodation'],
            workflow['bookId'],
            workflow['firstNight'],
            workflow['lastNight'],
            workflow["guestFirstName"] != null
                ? workflow["guestFirstName"]
                : "",
            workflow["guestName"] != null ? workflow["guestName"] : "",
            workflow['referer'],
            workflow['status'] == 1 ? 'Confirmed' : 'New',
            workflow['steps']);
        workflows.add(wk);
      }
    } catch (e) {
      print(e);
      client.close();
    }
    return workflows;
  }

  Future<List<WorkflowStep>> getWorkflowSteps(id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<WorkflowStep> steps = [];

    try {
      var data = await client.get(
          Uri.parse(apiUrl + 'apikey/bookings/workflow/steps/' + id.toString()),
          headers: {
            'Accept': 'application/json',
            'X-Authorization': apiKey,
          });
      var jsonData = jsonDecode(data.body);
      for (var step in jsonData) {
        WorkflowStep sp = new WorkflowStep(
          step['id'],
          step['has_alert'],
          step['position'],
          step['long_description'] != null
              ? Text(step['long_description'])
              : Text(""),
          step['short_description'] != null
              ? Text(step['short_description'])
              : Text(""),
          step['name'],
          step['status'],
          step['comment'] != null ? Text(step['comment']) : Text(""),
        );
        steps.add(sp);
      }
    } catch (e) {
      print(e);
      client.close();
    }
    return steps;
  }

  Future<int> sendWorkflowUpdate(id, status, comment) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.put(
          Uri.parse(apiUrl + 'apikey/workflow-steps/update'),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json',
            'X-Authorization': apiKey,
          },
          body: jsonEncode(<String, String>{
            'id': id.toString(),
            'status': status,
            'comment': comment
          }));
      return data.statusCode;
    } catch (e) {
      client.close();
      print(e);
      return throw Exception(e);
    }
  }

  Future<List<Cancellation>> cancellation(year) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<Cancellation> cancellations = [];
    try {
      var data = await client.get(
          Uri.parse(apiUrl + 'apikey/cancellation?year=' + year.toString()),
          headers: {
            'Accept': 'application/json',
            'X-Authorization': apiKey,
          });
      // print(data.body);
      var jsonData = jsonDecode(data.body);
      for (var cancel in jsonData) {
        Cancellation cancellation = new Cancellation(
          cancel["id"] != null ? cancel["id"] : 0,
          cancel["cancellation_date"] != null
              ? cancel["cancellation_date"]
              : "",
          cancel["firstNight"] != null ? cancel["firstNight"] : "",
          cancel["with_penalty"] != null ? cancel["with_penalty"] : false,
          cancel["referer"] != null ? cancel["referer"] : "",
          cancel["internal_name"] != null ? cancel["internal_name"] : "",
          cancel["guestFirstName"] != null ? cancel["guestFirstName"] : "",
          cancel["guestName"] != null ? cancel["guestName"] : "",
          cancel["price"] != null ? cancel["price"] : "0",
          cancel["commission"] != null ? cancel["commission"] : "0",
          cancel["code"] != null ? cancel["code"] : "",
        );
        cancellations.add(cancellation);
      }
    } catch (e) {
      print(e);
      client.close();
    }
    return cancellations;
  }

  Future<dynamic> getOneBookingCancelllation(id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl + "apikey/cancellation/" + id.toString()),
          headers: {
            'Accept': 'application/json',
            'X-Authorization': apiKey,
          });
      if (data.statusCode == 200) {
        return jsonDecode(data.body);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      client.close();
      return e;
    }
  }
}
