import 'dart:convert';

import 'package:flutter_application_4/model/flight/User.dart';
import 'package:flutter_application_4/model/hotel/AuthTokens.dart';
import 'package:flutter_application_4/model/hotel/MemberData.dart';
import 'package:http/http.dart' as http;

class Login_Register_service {
  static String URL = "http://localhost:1001/api/v1";

  Future<AuthTokens?> login(String email, String password) async {
    try {
      final response = await http.post(Uri.parse("$URL/login"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          }));

      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        AuthTokens authTokens = AuthTokens.fromJson(data);
        return authTokens;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> Register(User user) async {
    try {
      final response = await http.post(Uri.parse("$URL/register"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({user.toJson()}));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<MemberData> decode(String token) async {
    try {
      final response = await http
          .get(Uri.parse("$URL/decode"), headers: {'Authorization': '$token'});

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body) as Map<String, dynamic>;

        MemberData memberData = MemberData.fromMap(decodedData);
        return memberData;
      }
      throw Exception("loi me token roi");
    } catch (e) {
      print(e);
      throw Exception("loi me token roi");
    }
  }
}
