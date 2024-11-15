import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/LoadingUtils.dart';
import 'package:flutter_application_4/common/Not_Found.dart';
import 'package:flutter_application_4/hotel/Filter_Data_DropDown.dart';
import 'package:flutter_application_4/hotel/Hotel_HomePage.dart';
import 'package:flutter_application_4/Sevice_Api/Gex_Controller/Hotel_Getx_Controller.dart';

import 'package:get/get.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Search_hotel extends StatefulWidget {
  bool open_show;
  Search_hotel({
    super.key,
    required this.open_show,
  });

  @override
  State<Search_hotel> createState() => _Search_hotelState();
}

void navigateToNotFound(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Not_Found()),
  );
}

Hotel_Controller hotel_controller = Get.put(Hotel_Controller());

class _Search_hotelState extends State<Search_hotel> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.white10,
          leading: Container(),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 20),
              height: 30,
              width: 30,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  )),
            )
          ],
          title: Text(
            "Tìm Kiếm ",
            style: GoogleFonts.headlandOne(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 90,
          width: 400,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: filter_data(
              label_Text: "Bạn Muốn Đi Đâu",
              listData: hotel_controller.provinces,
              value1: hotel_controller.address),
        ),
        Column(
          children: [
            Container(
              height: 90,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: filter_data(
                        label_Text: "Danh Mục",
                        listData: hotel_controller.categories,
                        value1: hotel_controller.selectedCategory),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: filter_data(
                        label_Text: "Số Người",
                        listData: hotel_controller.number,
                        value1: hotel_controller.numberCustomer),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: filter_data(
                        label_Text: "Số Phòng",
                        listData: hotel_controller.number,
                        value1: hotel_controller.numberRoom),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 400,
                    height: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 0.5, color: Colors.black)),
                    child: GestureDetector(
                      onTap: () async {
                        final result = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(Duration(days: 365)));
                        if (result != null) {
                          setState(() {
                            hotel_controller.startTime.value = result.start;
                            hotel_controller.endTime.value = result.end;
                            hotel_controller.checkTime.value = false;
                          });
                        }
                      },
                      child: Obx(
                        () => Center(
                          child: Text(
                            hotel_controller.checkTime.value
                                ? "Chọn Thời Gian Đi vs Thời Gian Về"
                                : "Ngày đi ${DateFormat('dd/MM/yyyy').format(hotel_controller.startTime.value!)}" +
                                    " - Ngày về ${DateFormat('dd/MM/yyyy').format(hotel_controller.endTime.value!)}",
                            maxLines: 1,
                            style: GoogleFonts.headlandOne(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                if (hotel_controller.Check_Time(
                  context,
                )) {
                  LoadingUtils.show();

                  // Thực hiện điều hướng và ẩn overlay sau khi chuyển trang hoàn tất
                  Future.delayed(Duration(seconds: 2), () {
                    if (widget.open_show) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Hotel_HomePage()));
                      LoadingUtils.hide();
                    } else {
                      hotel_controller.resetDataOnMoreSearch();

                      LoadingUtils.show();

                      // Thực hiện điều hướng và ẩn overlay sau khi chuyển trang hoàn tất
                      Future.delayed(Duration(seconds: 2), () {
                        hotel_controller.loadMoreHotels();
                        LoadingUtils.hide();
                      });
                      Navigator.pop(context);
                    }
                  });
                }
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 0.5),
                    color: Colors.yellow),
                child: Center(
                  child: Text(
                    "TÌm",
                    style: GoogleFonts.headlandOne(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
