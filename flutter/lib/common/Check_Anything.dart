import 'package:flutter/material.dart';

class CheckAnything {
  bool isEmailValid(String email) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<bool?> checkEmail(String email) async {
    if (isEmailValid(email)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool?> CheckPassword(String password) async {
    if (password.length < 8) {
      return false;
    }

    // Biểu thức chính quy kiểm tra chữ cái viết hoa ở vị trí đầu tiên và chữ số
    RegExp regex = RegExp(r'^(?=.*[A-Z])(?=.*\d).*$');
    if (!regex.hasMatch(password)) {
      return false;
    }
    return true;
  }

  Future<bool?> checkSexlength(String anyting) async {
    if (anyting.length > 6) {
      return true;
    } else {
      return false;
    }
  }

  bool isPhoneNumberValid(String phone) {
    RegExp phoneRegex =
        RegExp(r'^[0-9]{10}$'); // Kiểm tra xem số điện thoại có 10 chữ số không
    return phoneRegex.hasMatch(phone);
  }
}
