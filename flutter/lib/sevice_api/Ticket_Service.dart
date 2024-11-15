import 'dart:convert';

import 'package:flutter_application_4/Ticket/Tapbar/List_Flight.dart';
import 'package:flutter_application_4/model/flight/BookingDto.dart';

import 'package:flutter_application_4/model/flight/FlightResponse.dart';
import 'package:flutter_application_4/model/flight/SearchFlight.dart';
import 'package:flutter_application_4/model/flight/Ticket.dart';
import 'package:flutter_application_4/ticket/input_data/seate/seate_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TicKet_Service {
  final url = "http://localhost:1002/api/v1";
  String baseUrl = "flight";
  String baseurl_assets = "assets";

  Future<FlightResponse?> getFlight(
      int number, SearchFlight searchFlight) async {
    try {
      final response =
          await http.post(Uri.parse("$url/$baseUrl/list?number=$number"),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(searchFlight.toMap()));
      if (response.statusCode == 200) {
        print(response.body);
        return FlightResponse.fromJson(utf8.decode(response.bodyBytes));
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<TickitDto?> createOrder(BookingTickit bookingTickit) async {
    try {
      final response = await http.post(Uri.parse("$url/flight/add"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(bookingTickit.toJson()));
      print(bookingTickit.toJson());

      if (response.statusCode == 200) {
        print(response.body);

        return TickitDto.fromJson(jsonDecode(response.body));
      } else {
        print(response.statusCode);
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  //get assets block
  Future<List<String>?> get_assets_block(
      int flightId, String ticket_type) async {
    try {
      final response = await http.get(Uri.parse(
          "$url/$baseurl_assets/list_assets?flightId=$flightId&ticket_type=$ticket_type"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List) {
          return List<String>.from(data);
        } else {
          return null;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // add assets block
  Future<String?> block_assets(int flightId, String? ticket_type_go,
      String? ticket_type_back, List<String> assets) async {
    try {
      String assets_data = assets.join(",");
      final response = await http.post(Uri.parse(
          "$url/$baseurl_assets/add?flightId=$flightId&ticket_type_go=$ticket_type_go&ticket_type_back=$ticket_type_back&assets=$assets_data"));
      if (response.statusCode == 200) {
        print(response.body);

        return response.body;
      } else {
        return "";
      }
    } catch (e) {
      print(e);
    }
  }

  //delete
  Future<void> delete_assets(int flightId, List<String> assets) async {
    try {
      var assets1 = assets.join(",");
      final response = await http.delete(
          Uri.parse("$url/$baseurl_assets?flightId=$flightId&assets=$assets1"));
      if (response.statusCode == 200) {
        print("$url/$baseurl_assets?flightId=$flightId&assets=$assets1");
        return;
      } else {
        print("loi delete assets");
      }
    } catch (e) {
      print(e);
    }
  }
}
