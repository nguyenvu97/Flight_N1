import 'dart:convert';

import 'package:flutter_application_4/model/hotel/Booking_Hotel.dart';
import 'package:flutter_application_4/model/hotel/Hotel.dart';
import 'package:flutter_application_4/model/hotel/Reviews.dart';
import 'package:flutter_application_4/request_model/Hotel_Request.dart';

import 'package:http/http.dart' as http;

class Hotel_Service {
  static String Url = "http://localhost:1002/api/v1";

  Future<HotelResponse?> search(
      HotelSearchRequest hotelSearchRequest, int sortId) async {
    try {
      final response = await http.post(
        Uri.parse('$Url/hotel/search?sortId=$sortId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(hotelSearchRequest.toJson()),
      );
      print("sortId : $sortId ");
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return HotelResponse.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // ! Reviews Api
  Future<ReviewsResponse?> ListReview(int hotelId, int pageNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$Url/review/hotel?hotelId=$hotelId&pageNumber=$pageNumber'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return ReviewsResponse.fromJson(jsonDecode(response.body));
      } else {
        print("loi me roi");
        return null;
      }
    } catch (err) {
      print(err);
    }
  }

  Future<bool> add_Reviews(Review review) async {
    try {
      final response = await http.post(Uri.parse('$Url/review/add'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(review.toJson()));

      print(response.body);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<Booking_Hotel> addBooking(
      Booking_Hotel booking_hotel, int roomId) async {
    try {
      final response =
          await http.post(Uri.parse('$Url/booking/add?roomId=$roomId'),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: booking_hotel.toJson());

      print(response.statusCode);
      if (response.statusCode == 200) {
        return Booking_Hotel.fromJson(response.body);
      } else {
        throw Exception("loi ko lay dc data");
      }
    } catch (e) {
      print(e);
      throw Exception("loi he thong +");
    }
  }

  //!  Booking Api
}
