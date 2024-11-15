import 'package:flutter/material.dart';

import 'package:flutter_application_4/common/App_Colors.dart';
import 'package:flutter_application_4/common/Box_Container/app_bar.dart';
import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/model/flight/FlightResponse.dart';

import 'package:flutter_application_4/sevice_api/gex_controller/Ariport_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:flutter_application_4/ticket/input_data/badge/choose_luggage.dart';

import 'package:get/get.dart';

class App_Bar_Seats_Bag extends StatefulWidget {
  App_Bar_Seats_Bag({
    super.key,
  });

  @override
  State<App_Bar_Seats_Bag> createState() => _App_Bar_Seats_BagState();
}

Ticket_Getx_Controller ticket_controler = Get.put(Ticket_Getx_Controller());

Ariport_Controller ariport_controller = Get.put(Ariport_Controller());

Show_Dia_log show_dia_log1 = Get.put(Show_Dia_log());

class _App_Bar_Seats_BagState extends State<App_Bar_Seats_Bag> {
 
  List<Flight?> list_flight = [];


  
 GlobalKey<AnimatedListState> list_key_badge = GlobalKey();
  List<Widget> body = <Widget>[].obs;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      data();
    });
  }
  void data() {
      body.clear();
    if (ticket_controler.isSelectFindBy.value) {
      final flightGo = ticket_controller.flightGo.value;
      final flightBack = ticket_controller.flightBack.value;
      body.add(build_badge(flightGo!, flightBack!));
      list_key_badge.currentState?.insertItem(body.length - 1);
    } else {
      final flightGo = ticket_controller.flightGo.value;
      body.add(build_badge(flightGo!, null));
      list_key_badge.currentState?.insertItem(body.length - 1);
      
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      padding: const EdgeInsets.all(8),
      key: list_key_badge,
      initialItemCount: body.length,
      itemBuilder: (context, index, animation) {
        return SlideTransition(
          position: animation
              .drive(Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))),
          child: body[index],
        );
      },
    );
  }

  Widget build_badge(
    Flight flight_go,
    Flight? flight_back,
  ) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            !ticket_controler.isSelectFindBy.value
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      address(
                        from_city: ariport_controller.endCountry.value,
                        to_city: ariport_controller.startCountry.value,
                      ),
                      show_badge(
                        to_city: ariport_controller.startCountry.value,
                        from_city: ariport_controller.endCountry.value,
                        flight_go: flight_go.id,
                        choose: true,
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          address(
                            from_city: ariport_controller.endCountry.value,
                            to_city: ariport_controller.startCountry.value,
                          ),
                          show_badge(
                            to_city: ariport_controller.startCountry.value,
                            from_city: ariport_controller.endCountry.value,
                            flight_go: flight_go.id,
                            choose: true,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          address(
                            from_city: ariport_controller.startCountry.value,
                            to_city: ariport_controller.endCountry.value,
                          ),
                          show_badge(
                              to_city: ariport_controller.startCountry.value,
                              from_city: ariport_controller.endCountry.value,
                              flight_back: flight_back!.id,
                              choose: false),
                        ],
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  GestureDetector show_badge({
    required String to_city,
    required String from_city,
    required bool choose,
    int? flight_go,
    int? flight_back,
  }) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (ticket_controller.customer_input.length ==
            (ticket_controller.customer.value +
                ticket_controller.children.value)) {
          showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (context) {
                return AnimatedContainer(
                  height: media.height * 0.53,
                  width: media.width * 1,
                  duration: const Duration(microseconds: 200),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      app_bar(
                        title: Text_Data(
                            name: "Hành lý | ${to_city} ${from_city}",
                            color: AppColors.textColor,
                            size: 15,
                            maxLine: 1),
                      ),
                      SizedBox(
                        height: media.height * 0.35,
                        child: Choose_Luggage(
                          flight_go: flight_go,
                          flight_back: flight_back,
                        ),
                      ),
                      const Divider(),
                      Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text_Data(
                                name: choose
                                    ? "Tổng Tiền : ${AppColors.formatCurrency(ticket_controller.sum_badge_go.value)}"
                                    : "Tổng Tiền : ${AppColors.formatCurrency(ticket_controller.sum_badge_back.value)}",
                                // : "Tổng Tiền : ${AppColors.formatCurrency(ticket_controller.sumMoneyBadge(2)!)}",
                                color: Colors.blue,
                                size: 15,
                                maxLine: 1),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 50,
                                width: 430,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(20)),
                                alignment: Alignment.center,
                                child: Text_Data(
                                    name: "Xác nhận ",
                                    color: Colors.black,
                                    size: 20,
                                    maxLine: 1),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        } else {
          show_dia_log1.showSuccessDialog(context, "Thông Báo",
              "Quý Khách hãy nhập đủ thông tin ", false, null);
        }
      },
      child: Row(
        children: [
          Icon(
            Icons.add_circle_outline,
            color: Colors.brown,
          ),
          SizedBox(
            width: 5,
          ),
          Text_Data(
            color: Colors.brown,
            name: choose
                ? ticket_controler.sum_badge_go.value <= 0
                    ? 'Thêm hành lý'
                    : "Tổng Tiền : ${ticket_controler.sum_badge_go.value}"
                : ticket_controler.sum_badge_back.value <= 0
                    ? 'Thêm hành lý'
                    : "Tổng Tiền : ${ticket_controler.sum_badge_back.value}",
            size: 15,
            maxLine: 1,
          ),
        ],
      ),
    );
  }
}

class address extends StatelessWidget {
  address({
    super.key,
    required this.to_city,
    required this.from_city,
  });
  final String to_city;
  final String from_city;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            child: Row(
              children: [
                Text_Data(
                    name: to_city, color: Colors.black, size: 15, maxLine: 1),
                Text(" ---------> "),
                Text_Data(
                    name: from_city, color: Colors.black, size: 15, maxLine: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
