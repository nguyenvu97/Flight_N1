import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/LoadingUtils.dart';
import 'package:flutter_application_4/hotel/Filter_Data_DropDown.dart';
import 'package:flutter_application_4/hotel/Hotel_Details.dart';

import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class Filter_Hotel extends StatefulWidget {
  RxDouble min_money;
  RxDouble max_money;

  Filter_Hotel({super.key, required this.max_money, required this.min_money});

  @override
  State<Filter_Hotel> createState() => _Filter_HotelState();
}

class _Filter_HotelState extends State<Filter_Hotel> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      height: media.height * 0.5,
      child: Column(
        children: [
          AppBar(
            title: Text(
              "Chọn Lọc",
              style: GoogleFonts.headlandOne(color: Colors.black),
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)),
            ],
          ),
          Container(
            height: media.height * 0.41,
            width: media.width * 0.8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 0.5, color: Colors.black)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Ngân sách của bạn (mỗi đêm)",
                    style: GoogleFonts.headlandOne(color: Colors.black),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Obx(
                        () => Text(
                          '\$${widget.min_money.value}' +
                              "-" +
                              '\$${widget.max_money.value}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                FlutterSlider(
                  values: [widget.min_money.value, widget.max_money.value],
                  rangeSlider: true,
                  max: 6000000,
                  min: 0,
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    widget.min_money.value = lowerValue;
                    widget.max_money.value = upperValue;
                  },
                ),
                Container(
                  width: media.width * 0.8,
                  height: 250,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 0.5, color: Colors.black))),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                "Xếp Hạng chỗ nghỉ ",
                                style: GoogleFonts.headlandOne(
                                    color: Colors.black),
                              ),
                            ),
                            Obx(() => Container(
                                  height:
                                      media.height * 0.22, // Giới hạn chiều cao
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(
                                        hotel_controller.filterStart.length,
                                        (index) {
                                          final int value = hotel_controller
                                                  .filterStart.length -
                                              index;
                                          final bool isSelected =
                                              hotel_controller
                                                      .selectedOptionIndex ==
                                                  value;

                                          return GestureDetector(
                                            onTap: () {
                                              hotel_controller.updateSelection(
                                                  isSelected ? 0 : value);
                                              print(hotel_controller
                                                  .selectedOptionIndex);
                                            },
                                            child: Container(
                                              color: isSelected
                                                  ? Colors.blue[100]
                                                  : Colors.white10,
                                              child: ListTile(
                                                title: Text(hotel_controller
                                                    .filterStart[index]),
                                                trailing: isSelected
                                                    ? Icon(Icons.check_circle,
                                                        color: Colors.blue)
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      )),
                      Container(
                          height: media.height * 0.24,
                          decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: Colors.black, width: 0.5)),
                          )),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.all(10),
                        child: filter_data(
                            label_Text: "Danh Mục",
                            listData: hotel_controller.categories,
                            value1: hotel_controller.selectedCategory),
                      )),
                    ],
                  ),
                ),
                // tim kiem theo loai phong
                // tim kiem theo cac sao tro len
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              hotel_controller.resetData();

              LoadingUtils.show();

              // Thực hiện điều hướng và ẩn overlay sau khi chuyển trang hoàn tất
              Future.delayed(Duration(seconds: 2), () {
                hotel_controller.loadMoreHotels();
                LoadingUtils.hide();
              });
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: 50,
              width: media.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 0.5, color: Colors.black),
              ),
              child: Center(
                child: Text(
                  "Tìm",
                  style: GoogleFonts.headlandOne(color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
