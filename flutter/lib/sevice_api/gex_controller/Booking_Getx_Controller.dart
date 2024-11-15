import 'package:flutter/material.dart';
import 'package:flutter_application_4/model/hotel/Booking_Hotel.dart';
import 'package:flutter_application_4/model/hotel/MemberData.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Hotel_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Login_Get_Controller.dart';
import 'package:flutter_application_4/sevice_api/Hotel_Service.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Booking_Getx_Controller extends GetxController {
  final TextEditingController email = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();

  var number = 0.obs;

  var number_Night = 0.obs;

  var totalMoney = 0.0.obs;

  Hotel_Service hotel_service = Hotel_Service();

  Rx<Booking_Hotel?> booking_hotel = Rx<Booking_Hotel?>(null);

  Future<void> addBooking(
      DateTime checkInDate,
      DateTime checkOutDate,
      int numberPeople,
      int quantityRoom,
      String roomCategory,
      String hotelName,
      int roomId,
      int hotelId) async {
    try {
      String formattedStartDate = DateFormat('yyyy-MM-dd').format(checkInDate);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(checkOutDate);

      Booking_Hotel booking_hotel = Booking_Hotel(
          stayNight: number_Night.value,
          checkInDate: formattedStartDate,
          checkOutDate: formattedEndDate,
          numberPeople: numberPeople,
          totalPrice: totalMoney.value,
          quantityRoom: quantityRoom,
          userName: fullName.text,
          email: email.text,
          phoneNumber: phone.text,
          roomCategory: roomCategory,
          hotelName: hotelName,
          hotelId: hotelId,
          roomId: roomId);
      print(booking_hotel.toJson());
      final data = await hotel_service.addBooking(booking_hotel, roomId);
      if (data != null) {
        booking_hotel = data;
      } else {
        print("loi me roi");
      }
    } catch (e) {
      print(e);
    }
  }

  int numberNight(int startTime, int endTime) {
    number_Night.value = endTime - startTime - 1;
    return endTime - startTime - 1;
  }

  double total_money(double price) {
    totalMoney.value = number_Night.value * price;
    return number_Night.value * price;
  }

  void dataUser(MemberData? memberData) {
    if (memberData != null) {
      email.text = memberData.sub!;
      fullName.text = memberData.name;
      address.text = memberData.address;
      phone.text = memberData.phone;
    }
  }

  bool Checkdata() {
    if (email.text.isEmpty ||
        address.text.isEmpty ||
        address.text.isEmpty ||
        fullName.text.isEmpty) {
      return false;
    }
    return true;
  }
}
