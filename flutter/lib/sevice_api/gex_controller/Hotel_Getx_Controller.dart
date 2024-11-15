import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/LoadingUtils.dart';
import 'package:flutter_application_4/common/Not_Found.dart';
import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/model/hotel/Category.dart';
import 'package:flutter_application_4/model/hotel/Hotel.dart';
import 'package:flutter_application_4/model/hotel/Reviews.dart';
import 'package:flutter_application_4/request_model/Hotel_Request.dart';
import 'package:flutter_application_4/sevice_api/Hotel_Service.dart';


import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';

class Hotel_Controller extends GetxController {
  var address = 'Hà Nội'.obs; // Observable string
  TextEditingController addressController = TextEditingController();

  final categories =
      CategoryType.values.map((e) => e.toString().split('.').last).toList().obs;

  var selectedCategory = 'Standard'.obs;

  final number = List.generate(30, (index) => (index + 1).toString()).obs;
  var numberRoom = '1'.obs;
  var numberCustomer = '2'.obs;

  var checkTime = true.obs;

  var startTime = Rx<DateTime?>(null);
  var endTime = Rx<DateTime?>(null);

  Show_Dia_log showController = Get.put(Show_Dia_log());

  bool Check_Time(BuildContext context) {
    if (startTime.value == null && endTime.value == null) {
      showController.showSuccessDialog(
          context, "Thông báo", "Hãy Điền đầy đủ thông tin ", false, null);
      return false;
    }
    if (startTime.value!.isAfter(endTime.value!)) {
      showController.showSuccessDialog(
          context, "Thông báo", "Bạn Hãy Xác Nhận Lại Thông Tin ", false, null);
      return false;
    }

    return true;
  }

  final Map<int, String> sortOptions = {
    1: 'Giá Tiền Từ Cao Đến Thấp',
    2: 'Giá Tiền Từ Thấp Đến Cao',
    3: 'Top Sao Và Giá Rẻ',
    4: 'Top Reviews',
    5: 'Top Reviews Và Giá Thấp',
  }.obs;

  final RxList<String> filterStart = ['5⭐️', '4⭐️', '3⭐️', '2⭐️', '1⭐️'].obs;

  final RxInt _selectedOptionIndex = (0).obs;

  int get selectedOptionIndex => _selectedOptionIndex.value;

  void updateSelection(int index) {
    if (_selectedOptionIndex.value == index) {
      _selectedOptionIndex.value = 0;
    } else {
      _selectedOptionIndex.value = index;
    }
  }

//
  RxInt selectedSortOption = 0.obs;

  RxDouble minMoney = 0.00.obs;
  RxDouble maxMoney = 5000000.00.obs;

  var provinces = <String>[
    "Hà Nội",
    "Quảng Ninh",
    "Bắc Giang",
    "Bắc Ninh",
    "Hải Dương",
    "Hưng Yên",
    "Thái Bình",
    "Hà Nam",
    "Thừa Thiên Huế",
    "Đà Nẵng",
    "Quảng Nam",
    "Quảng Ngãi",
    "Bình Định",
    "Phú Yên",
    "Khánh Hòa",
    "Ninh Thuận",
    "Đồng Nai",
    "Bà Rịa - Vũng Tàu",
    "TP. Hồ Chí Minh",
    "Cần Thơ"
  ].obs;

  var pageNumber = 0.obs;
// !! Hotel Service

  Hotel_Service hotel_service = Hotel_Service();
  var isLoading = false.obs;

  Rx<HotelResponse?> hotelResponse = Rx<HotelResponse?>(null);

  final RxList<Hotel> hotel = <Hotel>[].obs;

  final RxList<Hotel> hotels = <Hotel>[].obs;

  void loadMoreHotels() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      // Nếu không có dữ liệu mới hoặc trang hiện tại không hợp lệ thì không làm gì
      if (pageNumber.value < 0) {
        isLoading.value = false;
        return;
      }

      var newHotels = await dataTest();

      if (newHotels.isNotEmpty) {
        hotels.addAll(newHotels);

        if (newHotels.length < 10) {
          pageNumber.value =
              -1; // Đặt số trang không hợp lệ để ngừng tải thêm dữ liệu
        } else {
          pageNumber.value += 1;
        }
      }
    } catch (e) {
      print("Error loading hotels: $e");
    } finally {
      isLoading.value = false;
    }
  }

  var isLoadData = true.obs;
  Future<List<Hotel>> dataTest() async {
    try {
      String formattedStartDate =
          DateFormat('yyyy-MM-dd').format(startTime.value!);
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(endTime.value!);
      HotelSearchRequest hotelSearchRequest = HotelSearchRequest(
          address: address.value,
          numberPeople: int.tryParse(numberCustomer.value),
          numberRoom: int.tryParse(numberRoom.value),
          categoryType: selectedCategory.value,
          minMoney: minMoney.value,
          maxMoney: maxMoney.value,
          startHotel: _selectedOptionIndex.value,
          pageSize: 10,
          pageNumber: pageNumber.value,
          startTime: formattedStartDate,
          endTime: formattedEndDate);
      hotelResponse.value = await hotel_service.search(
          hotelSearchRequest, selectedSortOption.value);
      print(hotelSearchRequest);

      if (hotelResponse != null && hotelResponse.value != null) {
        hotel.value = hotelResponse.value!.content;
        isLoadData.value = false;

        return hotel; // Return the content directly
      } else {
        print("Error: No response from server");

        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

// !!!! Review_Service

  var reviewsPageNumber = 0.obs;

  var isLoadingReviews = false.obs;

  final RxList<Review> reviews = <Review>[].obs;
  final RxList<Review> listReviews = <Review>[].obs;

  void loadMoreReviews(int hotelId) async {
    if (isLoadingReviews.value) return;

    isLoadingReviews.value = true;

    try {
      // Nếu không có dữ liệu mới hoặc trang hiện tại không hợp lệ thì không làm gì
      if (reviewsPageNumber.value < 0) {
        isLoadingReviews.value = false;
        return;
      }

      var newReviews = await getListReview(hotelId, reviewsPageNumber.value);

      if (newReviews.isNotEmpty) {
        listReviews.addAll(newReviews);

        if (newReviews.length < 10) {
          reviewsPageNumber.value =
              -1; // Đặt số trang không hợp lệ để ngừng tải thêm dữ liệu
        } else {
          reviewsPageNumber.value += 1;
        }
      }
    } catch (e) {
      print("Error loading hotels: $e");
    } finally {
      isLoadingReviews.value = false;
    }
  }

  Rx<ReviewsResponse?> reviewResponse = Rx<ReviewsResponse?>(null);

  Future<List<Review>> getListReview(int hotelId, int pageNumber) async {
    try {
      final reviewResponse =
          await hotel_service.ListReview(hotelId, pageNumber);
      if (reviewResponse != null) {
        reviews.value = reviewResponse.content;
        return reviews;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  var rating = 0.0.obs;
  var kq = false.obs;
  TextEditingController reviewsController = TextEditingController();
  Future<bool> add(int hotelId) async {
    Review review = Review(
      hotelId: hotelId,
      email: "nguyenkhacvu199@Gmail.com",
      comment: reviewsController.value.text,
      rating: rating.value,
      customerId: 1,
      time: DateTime.now(),
    );
    try {
      final response = await hotel_service.add_Reviews(review);
      if (response != null) {
        kq.value = response;
        return kq.value;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
  //!

  void resetData() {
    hotels.clear(); // Clear old data
    resetPageNumber(); // Reset page number
  }

  void resetDataOnMoreSearch() {
    _selectedOptionIndex.value = 0;
    RxDouble minMoney = 0.00.obs;
    RxDouble maxMoney = 5000000.00.obs;
    selectedSortOption.value = 0;
    resetData();
  }

  void resetPageNumber() {
    pageNumber.value = 0;
  }

  @override
  void onInit() {
    super.onInit();
    addressController.addListener(() {
      address.value =
          addressController.text; // Update observable when text changes
    });
  }

  @override
  void onClose() {
    addressController.dispose();
    super.onClose();
  }

  // ! data for hotelDetails

  List<Map<String, dynamic>> gridItems = [
    {
      'text': 'Khách Sạn',
      'imagePath': 'assets/khachsan.jpeg',
      'icon': Icons.wifi
    },
    {
      'text': 'Hành Lý Ký Gửi',
      'imagePath': 'assets/hanhly3.jpeg',
      'icon': Icons.bus_alert_outlined
    },
    {
      'text': 'Chọn Chỗ Ngồi',
      'imagePath': 'assets/shit.jpeg',
      'icon': Icons.no_transfer
    },
    {
      'text': 'Phòng Chờ Thương Gia',
      'imagePath': 'assets/phongcho.png',
      'icon': Icons.park
    },
    {'text': 'Quà tặng', 'imagePath': 'assets/gif.jpeg', 'icon': Icons.park},
    {'text': 'Đặt Xe', 'imagePath': 'assets/texi1.jpeg', 'icon': Icons.park},
  ].obs;

  final Map<String, List<String>> countriesAndCities = {
    'Vietnam': ['Hanoi', 'Ho Chi Minh City', 'Da Nang'],
    'Thailand': ['Bangkok', 'Chiang Mai', 'Phuket'],
  }.obs;
}
