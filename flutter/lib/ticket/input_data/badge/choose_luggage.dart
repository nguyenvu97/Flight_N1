

import 'package:flutter/material.dart';

import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/common/Text_Data.dart';


import 'package:flutter_application_4/model/flight/Customer_Ticket.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ariport_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Choose_Luggage extends StatefulWidget {
  final int? flight_go;
  final int? flight_back;

  Choose_Luggage({super.key, this.flight_back, this.flight_go});

  @override
  State<Choose_Luggage> createState() => Choose_luggageState();
}

Ticket_Getx_Controller ticket_controller = Get.find();
Ariport_Controller ariport_controller = Get.find();
Show_Dia_log show_dia_log1 = Get.find();

class Choose_luggageState extends State<Choose_Luggage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      data();
    });
    super.initState();
  }

  List<Widget> body = <Widget>[].obs;
  GlobalKey<AnimatedListState> list_key_luggage = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedList(
        key: list_key_luggage,
        initialItemCount: body.length,
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: animation
                .drive(Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))),
            child: body[index],
          );
        },
      ),
    );
  }

  void data() {
    var data = ticket_controller.customer_input;
    for (int index = 0; index < data.length; index++) {
      var item = data[index];
      body.add(builder_bag(item, index));
      list_key_luggage.currentState?.insertItem(body.length - 1);
    }
  }

  Widget builder_bag(Customer_Ticket customer_ticket, int index) {
    String formatCurrency(double amount) {
      final formatCurrency = NumberFormat.currency(
        locale: 'vi_VN',
        symbol: '₫', // Biểu tượng tiền tệ
      );
      return formatCurrency.format(amount);
    }

    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text_Data(
              name: "Hành Khách ${customer_ticket.full_name}",
              color: Colors.black,
              size: 15,
              maxLine: 1,
            ),
            const SizedBox(height: 20),
            Text_Data(
              name: "0-50 Lbs/0-23 kgs",
              color: Colors.black,
              size: 10,
              maxLine: 1,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text_Data(
                      name: formatCurrency(ticket_controller.moneybadge.value),
                      color: Colors.blue,
                      size: 20,
                      maxLine: 1,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              if (widget.flight_back == null) {
                                if (customer_ticket.badge_go!.value > 0) {
                                  customer_ticket.badge_go =
                                      customer_ticket.badge_go! - 1;
                                  ticket_controller.customer_input[index] =
                                      customer_ticket;

                                  ticket_controller.sumMoneyBadge(1);
                                }
                              } else {
                                if (customer_ticket.badge_back!.value > 0) {
                                  customer_ticket.badge_back =
                                      customer_ticket.badge_back! - 1;

                                  ticket_controller.customer_input[index] =
                                      customer_ticket;
                                  ticket_controller.sumMoneyBadge(2);
                                }
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text_Data(
                              name: widget.flight_back == null
                                  ? "${customer_ticket.badge_go}"
                                  : "${customer_ticket.badge_back}",
                              color: Colors.blue,
                              size: 15,
                              maxLine: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () {
                              if (widget.flight_back == null) {
                                customer_ticket.badge_go!.value =
                                    customer_ticket.badge_go!.value + 1;

                                ticket_controller.customer_input[index] =
                                    customer_ticket;
                                ticket_controller.sumMoneyBadge(1);
                              } else {
                                customer_ticket.badge_back =
                                    customer_ticket.badge_back! + 1;

                                ticket_controller.customer_input[index] =
                                    customer_ticket;
                                ticket_controller.sumMoneyBadge(2);
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
