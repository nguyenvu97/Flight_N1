import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_application_4/model/hotel/Reviews.dart';
import 'package:http/http.dart' as http;

class Review_Service {
  static String Url = "http://localhost:1002/api/v1";
  Future<ReviewsResponse?> ListReview(int hotelId, int pageNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$Url/review/hotel?hotelId=$hotelId&pageNumber=&pageNumber'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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

  Future<String?> add_Reviews(Review review) async {
    try {
      final response = await http.post(Uri.parse('$Url/review/add'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(review.toJson()));
      if (response.statusCode == 200) {
        return "ok";
      } else {
        return "not Ok";
      }
    } catch (err) {
      print(err);
    }
  }
}
