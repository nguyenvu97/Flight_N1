import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/Box_Container/app_bar.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ariport_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:flutter_application_4/ticket/pay/List_Show_Details/Show_Details_Price.dart';

import 'package:get/get.dart';

import 'List_Show_Details/Show_Details_Flight.dart';

import 'List_Show_Details/Show_list_customer.dart';

class List_Details_Customer extends StatefulWidget {
  const List_Details_Customer({super.key});

  @override
  State<List_Details_Customer> createState() => _List_Details_CustomerState();
}

Ariport_Controller ariport_controller = Get.put(Ariport_Controller());
Ticket_Getx_Controller ticket_controler = Get.put(Ticket_Getx_Controller());
List<Show_Details> data = [
  Show_Details(
      icon: Icon(Icons.flight),
      text: "Thông tin chuyến bay",
      icon1: Icon(Icons.more)),
  Show_Details(
      icon: Icon(Icons.attach_money),
      text: "Chi Tiết Giá",
      icon1: Icon(Icons.more)),
  Show_Details(
      icon: Icon(Icons.person),
      text: "Thông tin khách hàng",
      icon1: Icon(Icons.more))
];

class _List_Details_CustomerState extends State<List_Details_Customer> {
  var body = <Widget>[].obs;
  late GlobalKey<AnimatedListState> list_key_data_customer = GlobalKey();
  void add_data() {
    body.clear();
    data.asMap().forEach((index, element) {
      body.add(buildData(element, index));
      list_key_data_customer.currentState?.insertItem(body.length - 1);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      add_data();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return AnimatedList(
      key: list_key_data_customer,
      initialItemCount: body.length,
      itemBuilder: (context, index, animation) {
        return SlideTransition(
          position:
              animation.drive(Tween(begin: Offset(1, 0), end: Offset(0, 0))),
          child: body[index],
        );
      },
    );
  }

  Widget buildData(Show_Details show_details, int index) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: false,
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 800,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: const Show_Details_Flight(),
                      ),
                    ],
                  ),
                );
              });
        }
        if (index == 1) {
          showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: false,
              context: context,
              builder: (context) {
                return Container(
                  height: 700,
                  child: Column(
                    children: [
                      app_bar(
                          title: Text_Data(
                              name: "Chi tiết giá ",
                              color: Colors.black,
                              size: 15,
                              maxLine: 1)),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: const Show_Details_Price(),
                      ),
                    ],
                  ),
                );
              });
        }
        if (index == 2) {
          showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: true,
              context: context,
              builder: (context) {
                return Container(
                  height: 600,
                  child: Column(
                    children: [
                      app_bar(
                          title: Text_Data(
                              name: "Thông tin khách hàng",
                              color: Colors.black,
                              size: 15,
                              maxLine: 1)),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 500,
                        child: Show_List_Curtomer(),
                      ),
                    ],
                  ),
                );
              });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 50,
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.black))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  show_details.icon,
                  Text_Data(
                      name: show_details.text,
                      color: Colors.black,
                      size: 15,
                      maxLine: 1)
                ],
              ),
            ),
            const Icon(Icons.more_horiz_outlined)
          ],
        ),
      ),
    );
  }
}

class Show_Details {
  Icon icon;
  String text;
  Icon icon1;
  Show_Details({required this.icon, required this.text, required this.icon1});
}
