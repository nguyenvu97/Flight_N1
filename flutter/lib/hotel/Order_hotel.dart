import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/Box_Container/New_Box.dart';
import 'package:flutter_application_4/common/Money.dart';
import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/common/Text_Input.dart';
import 'package:flutter_application_4/Sevice_Api/Gex_Controller/Booking_Getx_Controller.dart';
import 'package:flutter_application_4/Sevice_Api/Gex_Controller/Hotel_Getx_Controller.dart';
import 'package:flutter_application_4/Sevice_Api/Gex_Controller/Login_Get_Controller.dart';
import 'package:flutter_application_4/model/hotel/Hotel.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Order_Hotel extends StatefulWidget {
  Hotel hotel;

  Order_Hotel({super.key, required this.hotel});

  @override
  State<Order_Hotel> createState() => _Order_HotelState();
}

Hotel_Controller hotel_controller = Get.put(Hotel_Controller());
Login_Getx_Controller login_Controller = Get.put(Login_Getx_Controller());

Booking_Getx_Controller booking_Controller = Get.put(Booking_Getx_Controller());
Show_Dia_log showDialog = Get.put(Show_Dia_log());

class _Order_HotelState extends State<Order_Hotel> {
  @override
  void initState() {
    booking_Controller.dataUser(login_Controller.memberData1.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    var number = booking_Controller.numberNight(
        hotel_controller.startTime.value!.day,
        hotel_controller.endTime.value!.day);

    var totelMoney = booking_Controller.total_money(widget.hotel.price);

    return Scaffold(
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              expandedHeight: 250.0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/ks.jpeg",
                        ),
                      )),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text_Data(
                      name: "${widget.hotel.hotelName}",
                      color: Colors.amber,
                      size: 25,
                      maxLine: 1,
                    ),
                  ],
                ),
              ),
              actions: [
                Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white70),
                  child: const Icon(
                    Icons.notifications,
                    size: 30,
                    color: Colors.black,
                  ),
                )
              ],
              leading: Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white70),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  iconSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //! Thong tin Khách san
                    Container(
                      height: media.height * 0.2,
                      width: media.width * 1,
                      margin: EdgeInsets.all(10),
                      child: NewBox(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: media.height * 0.05,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: Text_Data(
                                              name:
                                                  "Khách Sạn ${widget.hotel.stars}⭐️",
                                              color: Colors.black,
                                              size: 20,
                                              maxLine: 1),
                                        )),
                                    Expanded(
                                        child: Container(
                                      child: Center(
                                        child: Text_Data(
                                            name:
                                                "${MoneyFormatter.format(widget.hotel.price)}",
                                            color: Colors.black,
                                            size: 20,
                                            maxLine: 1),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.black, width: 0.2))),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Date_User(hotel_controller.startTime.value,
                                        "Ngày Nhận Phòng"),
                                    Container(
                                      height: media.height * 0.1,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                                  color: Colors.black,
                                                  width: 0.2))),
                                    ),
                                    Date_User(hotel_controller.endTime.value,
                                        "Ngày Trả Phòng")
                                  ],
                                ),
                              )
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              top:
                                  BorderSide(color: Colors.black, width: 0.5))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text_Data(
                                name: "Tóm Tắt Giá",
                                color: Colors.blue,
                                size: 20,
                                maxLine: 1),
                          ),
                          Conten_Price("Bạn Đã Chọn :",
                              "${hotel_controller.numberRoom.value} Phòng ${hotel_controller.numberCustomer.value} Người"),
                          Conten_Price(
                              "Tổng Thời Gian Lưu Trú", "${number} Đêm"),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Text_Data(
                                    name: "Tổng Tiền :",
                                    color: Colors.blue,
                                    size: 20,
                                    maxLine: 1),
                              ),
                              Total_Price("Giá 1 Đêm",
                                  MoneyFormatter.format(widget.hotel.price)),
                              Total_Price("Số Ngày Luu Trú",
                                  "${number.toString()} Đêm"),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text_Data(
                                        name: totelMoney.toString(),
                                        color: Colors.blue,
                                        size: 20,
                                        maxLine: 1),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              top:
                                  BorderSide(color: Colors.black, width: 0.5))),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      width: media.width * 1,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Text_Data(
                              name: "Nhập Thông Tin Chi tiết Của Bạn",
                              color: Colors.black,
                              size: 20,
                              maxLine: 1),
                          SizedBox(
                            height: 10,
                          ),
                          TextFailInput(
                            textName: 'Họ và Tên',
                            controller: booking_Controller.fullName,
                            obscureText: false,
                            color: Colors.black,
                            size: 20,
                          ),
                          TextFailInput(
                            textName: 'Email',
                            controller: booking_Controller.email,
                            obscureText: false,
                            color: Colors.black,
                            size: 20,
                          ),
                          TextFailInput(
                            textName: 'Số Điện Thoại',
                            controller: booking_Controller.phone,
                            obscureText: false,
                            color: Colors.black,
                            size: 20,
                          ),
                          TextFailInput(
                            textName: 'Nhập Địa Chỉ',
                            controller: booking_Controller.address,
                            obscureText: false,
                            color: Colors.black,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (booking_Controller.Checkdata()) {
                          print(widget.hotel.roomId);
                          booking_Controller.addBooking(
                              hotel_controller.startTime.value!,
                              hotel_controller.endTime.value!,
                              int.parse(hotel_controller.numberCustomer.value),
                              int.parse(hotel_controller.numberRoom.value),
                              widget.hotel.category,
                              widget.hotel.hotelName,
                              widget.hotel.roomId,
                              widget.hotel.id);
                          showDialog.showSuccessDialog(
                              context,
                              "Thông Báo",
                              "Quý Khách Đã Đặt Khách Sạn Thành Công \n Cảm ơn Quý Khách",
                              false,
                              null);
                        } else {
                          showDialog.showSuccessDialog(
                              context,
                              "Thông Báo",
                              "Bạn Nhập Thiếu Thông Tin Cần Thiết",
                              false,
                              null);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        height: media.height * 0.07,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blue),
                        child: Center(
                          child: Text_Data(
                              name: "Đặt Ngay (${totelMoney})",
                              color: Colors.white,
                              size: 25,
                              maxLine: 1),
                        ),
                      ),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Container Total_Price(String text, String price) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text_Data(name: text, color: Colors.black, size: 15, maxLine: 1),
          Text_Data(name: price, color: Colors.black, size: 15, maxLine: 1)
        ],
      ),
    );
  }

  Column Conten_Price(String text, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child:
              Text_Data(name: text, color: Colors.black, size: 15, maxLine: 1),
        ),
        Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text_Data(
                    name: data, color: Colors.blue, size: 15, maxLine: 1),
              )
            ],
          ),
        )
      ],
    );
  }

  Expanded Date_User(DateTime? dateTime, String text) {
    return Expanded(
        child: Container(
      child: Column(
        children: [
          Container(
            // margin: EdgeInsets.all(10),
            child: Text_Data(
                name: text, color: Colors.black, size: 20, maxLine: 1),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: Text_Data(
                name: "${dateTime}", color: Colors.black, size: 20, maxLine: 1),
          ),
        ],
      ),
    ));
  }
}
