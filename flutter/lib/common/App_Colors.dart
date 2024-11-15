import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  static Color primaryColor = Color(0xFF6200EE); // Màu chính
  static Color secondaryColor = Color(0xFF03DAC5); // Màu phụ

  static Color textColor = Color(0xFF000000); // Màu văn bản chính
  static Color errorColor = Color(0xFFB00020);
  static Color FlightColors = Colors.lightBlue.shade200;
  static Color econdaryFlightColors = Colors.white.withOpacity(0.8);

  static double Business_Money = 2;
  static double Economy_Money = 1.5;
  static double child_discount = 0.25;
  static double badge_money = 500000;
  static String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}";
  static String regex = (r'^[0-9]+$');

  static String formatCurrency(double? amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫', // Biểu tượng tiền tệ
    );
    return formatCurrency.format(amount);
  }

  static double money_to_bage = 500000;
  static bool? checkemail(String email) {
    RegExp regExp = RegExp(emailRegex);
    return regExp.hasMatch(email);
  }

  static bool? checkPhone(String phone) {
    if (phone.length >= 10 && phone.length < 11) {
      RegExp regExp = RegExp(regex);
      return regExp.hasMatch(phone);
    }
      return false;
  }
}
