import 'package:flutter/material.dart';
import 'package:Season/services/api.dart';
import '../../models/accommodation/model_accommodation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert';
import 'dart:async';

class ApiAccommodation {
  ApiUrl url = new ApiUrl();

  Future<dynamic> getOneAccommodations(id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    try {
      var data = await client.get(
          Uri.parse(apiUrl + "apikey/hostings/accommodation/" + id.toString()),
          headers: {
            'Accept': 'application/json',
            'X-Authorization': apiKey,
          });
      if (data.statusCode == 200) {
        var jsonData = jsonDecode(data.body);
        var accomodation = jsonData["data"];
        AccommodationEntity acc = AccommodationEntity(
            accomodation["id"],
            accomodation["ref"] != null ? accomodation["ref"] : "",
            accomodation["status"] != null ? accomodation["status"] : "",
            accomodation["internal_name"] != null
                ? accomodation["internal_name"]
                : "",
            accomodation["external_name"] != null
                ? accomodation["external_name"]
                : "",
            accomodation["other_name"] != null
                ? accomodation["other_name"]
                : "",
            accomodation["type_accommodation"] != null
                ? accomodation["type_accommodation"]
                : "",
            accomodation["checkin_method"] != null
                ? accomodation["checkin_method"]
                : "",
            accomodation["entire_place"] != null
                ? accomodation["entire_place"]
                : false,
            accomodation["capacity"] != null ? accomodation["capacity"] : 0,
            accomodation["area"] != null ? accomodation["area"] : 0,
            accomodation["floor_number"] != null
                ? accomodation["floor_number"]
                : 0,
            accomodation["door_number"] != null
                ? accomodation["door_number"]
                : "",
            accomodation["has_elevator"] != null
                ? accomodation["has_elevator"]
                : false,
            accomodation["self_checkin"] != null
                ? accomodation["self_checkin"]
                : false,
            accomodation["description"] != null
                ? Text(accomodation["description"])
                : Text(""),
            accomodation["details"] != null
                ? Text(accomodation["details"])
                : Text(""),
            accomodation["access_instruction_fr"] != null
                ? Text(accomodation["access_instruction_fr"])
                : Text(""),
            accomodation["latitude"] != null ? accomodation["latitude"] : 0,
            accomodation["longitude"] != null ? accomodation["longitude"] : 0,
            accomodation["photos"] != null ? accomodation["photos"] : "",
            accomodation["mail_box_location"] != null
                ? Text(accomodation["mail_box_location"])
                : Text(""),
            accomodation["mail_box_number"] != null
                ? accomodation["mail_box_number"]
                : "",
            accomodation["mail_boxe_name"] != null
                ? accomodation["mail_boxe_name"]
                : "",
            accomodation["address1"] != null ? accomodation["address1"] : "",
            accomodation["address2"] != null ? accomodation["address2"] : "",
            accomodation["address3"] != null ? accomodation["address3"] : "",
            accomodation["state"] != null ? accomodation["state"] : "",
            accomodation["country_id"] != null ? accomodation["country_id"] : 0,
            accomodation["city"] != null ? accomodation["city"] : "",
            accomodation["zip"] != null ? accomodation["zip"] : "",
            accomodation["access_instruction_to_the_building"] != null
                ? Text(accomodation["access_instruction_to_the_building"])
                : Text(""),
            accomodation["access_instruction_to_the_apartment"] != null
                ? Text(accomodation["access_instruction_to_the_apartment"])
                : Text(""),
            accomodation["building_management_compagny_details"] != null
                ? Text(accomodation["building_management_compagny_details"])
                : Text(""),
            accomodation["elevator_management_compagny_details"] != null
                ? Text(accomodation["elevator_management_compagny_details"])
                : Text(""),
            accomodation["heading_transport"] != null
                ? Text(accomodation["heading_transport"])
                : Text(""),
            accomodation["public_transport_nearby"] != null
                ? Text(accomodation["public_transport_nearby"])
                : Text(""),
            accomodation["energy_line_identifiere"] != null
                ? Text(accomodation["energy_line_identifiere"])
                : Text(""),
            accomodation["access_instruction_en"] != null
                ? Text(accomodation["access_instruction_en"])
                : Text(''),
            accomodation["checkout_instructions_en"] != null
                ? Text(accomodation["checkout_instructions_en"])
                : Text(""),
            accomodation["checkout_instructions_fr"] != null
                ? Text(accomodation["checkout_instructions_fr"])
                : Text(""),
            accomodation["coffee_machine_type"] != null
                ? Text(accomodation["coffee_machine_type"])
                : Text(""),
            accomodation["currency"] != null ? accomodation["currency"] : "",
            accomodation["disable_acces"] != null
                ? accomodation["disable_acces"]
                : false,
            accomodation["hotplatesystem"] != null
                ? Text(accomodation["hotplatesystem"])
                : Text(""),
            accomodation["pricing_plan"] != null
                ? Text(accomodation["pricing_plan"])
                : Text(""),
            accomodation["profile_selection"] != null
                ? accomodation["profile_selection"]
                : "",
            accomodation["telecomLine_identifiere"] != null
                ? Text(accomodation["telecomLine_identifiere"])
                : Text(""),
            accomodation["trash_location"] != null
                ? Text(accomodation["trash_location"])
                : Text(""),
            accomodation["wifi_identifiers"] != null
                ? Text(accomodation["wifi_identifiers"])
                : Text(""),
            accomodation["hosting_platforms"] != null
                ? accomodation["hosting_platforms"]
                : null,
            accomodation["special_equipment"] != null
                ? Text(accomodation["special_equipment"])
                : Text(""),
            accomodation["advantage_for_traveler"] != null
                ? Text(accomodation["advantage_for_traveler"])
                : Text(""));
        return acc;
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

  Future<List<ShortDataAccommodation>> getAccommodations() async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<ShortDataAccommodation> accommodations = [];
    try {
      var data = await client.get(
          Uri.parse(apiUrl + "apikey/hostings/accommodation/shortlist"),
          headers: {
            'Accept': 'application/json',
            'content-type': 'application/json',
            'X-Authorization': apiKey,
          });
      var jsonData = jsonDecode(data.body);
      // print(jsonData);
      for (var accomodation in jsonData) {
        ShortDataAccommodation newAcc = ShortDataAccommodation(
          accomodation["id"],
          accomodation["ref"] != null ? accomodation["ref"] : "",
          accomodation["status"] != null ? accomodation["status"] : "",
          accomodation["internal_name"] != null
              ? accomodation["internal_name"]
              : "",
          accomodation["external_name"] != null
              ? accomodation["external_name"]
              : "",
          accomodation["address1"] != null ? accomodation["address1"] : "",
          accomodation["address2"] != null ? accomodation["address2"] : "",
          accomodation["address3"] != null ? accomodation["address3"] : "",
          accomodation["city"] != null ? accomodation["city"] : "",
        );
        accommodations.add(newAcc);
      }
    } catch (e) {
      print(e);
      client.close();
    }
    //print(accommodations);
    return accommodations;
  }

  Future<List<SpaceAccommodationEntity>> spacesAccommodation(id) async {
    String apiUrl = url.getApiUrl();
    String apiKey = url.getKey();
    var client = RetryClient(http.Client());
    List<SpaceAccommodationEntity> spacesAccommodation = [];
    try {
      var data = await client.get(
          Uri.parse(apiUrl + 'hostings/accommodation_space/' + id.toString()),
          headers: {
            'Accept': 'application/json',
            'X-Authorization': apiKey,
          });
      //print(data.body);
      var jsonData = jsonDecode(data.body);
      for (var space in jsonData["data"]) {
        SpaceAccommodationEntity sp = new SpaceAccommodationEntity(
          space["name"] != null ? space["name"] : "",
          space["nb_double_bed"] != null ? space["nb_double_bed"] : 0,
          space["nb_heater"] != null ? space["nb_heater"] : 0,
          space["size"] != null ? space["size"] : 0,
          space["heigh"] != null ? double.parse(space["heigh"]) : 0,
          space["type_space"] != null ? space["type_space"] : "",
          space["nb_air_conditioner"] != null ? space["nb_air_conditioner"] : 0,
          space["nb_air_crib"] != null ? space["nb_crib"] : 0,
          space["nb_double_air_mattress"] != null
              ? space["nb_double_air_mattress"]
              : 0,
          space["nb_double_sofa_bed"] != null ? space["nb_double_sofa_bed"] : 0,
          space["nb_extra_large_bed"] != null ? space["nb_extra_large_bed"] : 0,
          space["nb_hammock"] != null ? space["nb_hammock"] : 0,
          space["nb_large_bed"] != null ? space["nb_large_bed"] : 0,
          space["nb_single_air_mattress"] != null
              ? space["nb_single_air_mattress"]
              : 0,
          space["nb_single_bed"] != null ? space["nb_single_bed"] : 0,
          space["nb_single_floor_mattress"] != null
              ? space["nb_single_floor_mattress"]
              : 0,
          space["nb_double_floor_mattress"] != null
              ? space["nb_double_floor_mattress"]
              : 0,
          space["nb_single_sofa_bed"] != null ? space["nb_single_sofa_bed"] : 0,
          space["nb_sofa"] != null ? space["nb_sofa"] : 0,
          space["nb_toddler_bled"] != null ? space["nb_toddler_bed"] : 0,
          space["nb_water_bed"] != null ? space["nb_water_bed"] : 0,
          space["nb_medium_bed"] != null ? space["nb_medium_bed"] : 0,
          space["nb_travel_cot"] != null ? space["nb_travel_cot"] : 0,
          space["nb_folder_bed"] != null ? space["nb_folder_bed"] : 0,
        );
        spacesAccommodation.add(sp);
      }
    } catch (e) {
      print(e);
      client.close();
    }
    //print(spacesAccommodation);
    return spacesAccommodation;
  }
}
