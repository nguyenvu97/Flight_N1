

import 'package:flutter/material.dart';
import 'package:flutter_application_4/model/flight/User.dart';
import 'package:flutter_application_4/model/hotel/MemberData.dart';
import 'package:flutter_application_4/sevice_api/Login_Register_Service.dart';

import 'package:get/get.dart';

class Login_Getx_Controller extends GetxController {
  final TextEditingController email = TextEditingController();
  final TextEditingController passWorld = TextEditingController();
  final TextEditingController aliases = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  var token = ''.obs;
  var refreshToken = ''.obs;

  Login_Register_service login_Service = Login_Register_service();

  var registerOk = false.obs;

  Future<bool> register() async {
    User user = User(
        email: email.text,
        password: passWorld.text,
        fullName: fullName.text,
        address: address.text,
        phone: phone.text,
        aliases: aliases.text);
    final response = await login_Service.Register(user);
    try {
      if (response) {
        registerOk.value = response;
        return registerOk.value;
      }
      return registerOk.value;
    } catch (e) {
      print(e);
      return registerOk.value;
    }
  }

  Future<bool?> login() async {
    final response = await login_Service.login(email.text, passWorld.text);

    try {
      if (response != null) {
        token.value = response.accessToken;
        refreshToken.value = response.refreshToken;
        decode();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during login: $e');

      throw e;
    }
  }

  final Rx<MemberData?> memberData1 = Rx<MemberData?>(null);

  Future<MemberData> decode() async {
    print(token.value);
    final response = await login_Service.decode(token.value);
    try {
      if (response != null) {
        final memberData = MemberData(
            exp: response.exp,
            id: response.id,
            sub: response.sub,
            iat: response.iat,
            role: response.role,
            aliases: response.aliases,
            address: response.address,
            name: response.name,
            phone: response.phone);
        print(memberData);
        memberData1.value = memberData;

        return memberData;
      } else {
        throw Exception("Invalid response from server");
      }
    } catch (e) {
      print('Error during login: $e');
      throw e;
    }
  }
}
