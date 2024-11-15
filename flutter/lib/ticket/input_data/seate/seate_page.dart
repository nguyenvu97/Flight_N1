import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/App_Colors.dart';
import 'package:flutter_application_4/common/Box_Container/app_bar.dart';
import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/model/flight/FlightResponse.dart';

import 'package:flutter_application_4/sevice_api/gex_controller/Ariport_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:flutter_application_4/ticket/input_data/seate/choose_seats.dart';

import 'package:get/get.dart';

class Seats_page extends StatefulWidget {
  const Seats_page({super.key});

  @override
  State<Seats_page> createState() => _Seats_pageState();
}

Ticket_Getx_Controller ticket_controller = Get.put(Ticket_Getx_Controller());

Ariport_Controller ariport_controller = Get.put(Ariport_Controller());

Show_Dia_log show_dia_log1 = Get.put(Show_Dia_log());

class _Seats_pageState extends State<Seats_page> {
  GlobalKey<AnimatedListState> list_key = GlobalKey();
  List<Widget> body = <Widget>[].obs;

  void data() {
    body.clear();
    var customer = ticket_controller.customer_input;
    if (ticket_controller.isSelectFindBy.value) {
      final flightGo = ticket_controller.flightGo.value;
      final flightBack = ticket_controller.flightBack.value;
      body.add(build_seats(flightGo!, flightBack!));
      list_key.currentState?.insertItem(body.length - 1);
    } else {
      final flightGo = ticket_controller.flightGo.value;

      body.add(build_seats(flightGo, null));
      list_key.currentState?.insertItem(body.length - 1);
    }
  }

  List<String> allSeats_go = [];
  List<String> allSeats_back = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      data();
    });
  }

  @override
  void dispose() {
    allSeats_go.clear();
    allSeats_back.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Obx(
      () => AnimatedList(
        padding: const EdgeInsets.all(8),
        key: list_key,
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

  Widget build_seats(Flight? flightGo, Flight? flightBack) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (flightGo != null) ...[
            if (flightGo.flights == null)
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                seats(
                  to_city: " ${flightGo.fromCity} ---> ",
                  from_city: "${flightGo.toCity}",
                ),
                show_seats(
                    from_city: flightGo.toCity,
                    to_city: flightGo.fromCity,
                    flight_go: flightGo,
                    choose: true),
              ])
            else ...[
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                seats(
                  to_city: "${flightGo.fromCity} ---> ",
                  from_city: "${flightGo.flights!.first.fromCity}",
                ),
                show_seats(
                    from_city: flightGo.flights!.first.toCity,
                    to_city: flightGo.toCity,
                    flight_go: flightGo,
                    choose: true),
              ]),
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                seats(
                  to_city: "${flightGo.flights!.first.fromCity} ---> ",
                  from_city: "${flightGo.flights!.first.toCity}",
                ),
                show_seats(
                    flight_go: flightGo.flights!.first,
                    from_city: flightGo.flights!.first.toCity,
                    to_city: flightGo.flights!.first.fromCity,
                    choose: false)
              ]),
            ],
          ],
          Visibility(
            visible: ticket_controller.isSelectFindBy.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (ticket_controller.flightBack.value != null)
                  if (ticket_controller.flightBack.value!.flights == null)
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          seats(
                            to_city:
                                " ${ticket_controller.flightBack.value!.fromCity} ---> ",
                            from_city:
                                "${ticket_controller.flightBack.value!.toCity}",
                          ),
                          show_seats(
                              flight_back: flightBack,
                              from_city:
                                  ticket_controller.flightBack.value!.toCity,
                              to_city:
                                  ticket_controller.flightBack.value!.fromCity,
                              choose: true),
                        ])
                  else
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          seats(
                            to_city:
                                "${ticket_controller.flightBack.value!.fromCity} ---> ",
                            from_city:
                                "${ticket_controller.flightBack.value!.flights!.first.fromCity}",
                          ),
                          show_seats(
                              flight_back: flightBack,
                              from_city: ticket_controller
                                  .flightBack.value!.flights!.first.fromCity,
                              to_city:
                                  ticket_controller.flightBack.value!.fromCity,
                              choose: true)
                        ]),
                if (ticket_controller.flightBack.value?.flights != null &&
                    ticket_controller.flightBack.value!.flights!.isNotEmpty)
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    seats(
                      to_city:
                          "${ticket_controller.flightBack.value!.toCity} ---> ",
                      from_city:
                          "${ticket_controller.flightBack.value!.flights!.first.toCity}",
                    ),
                    show_seats(
                        flight_back: flightBack!.flights!.first,
                        from_city: ticket_controller
                            .flightBack.value!.flights!.first.toCity,
                        to_city: ticket_controller.flightBack.value!.toCity,
                        choose: false)
                  ]),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget show_seats({
    required String to_city,
    required String from_city,
    Flight? flight_go,
    Flight? flight_back,
    required bool choose,
  }) {
    void taskSeatsInListMap() {
      if (flight_back == null) {
        for (var flightSeatsMap in ticket_controller.listOfFlightSeatsMaps) {
          if (flight_go != null && flightSeatsMap.containsKey(flight_go.id)) {
            var list_customer = flightSeatsMap[flight_go.id];
            if (list_customer != null && list_customer.isNotEmpty) {
              for (var setas in list_customer) {
                allSeats_go.add(setas.flight_go_seats!.value);
              }
            }
          }
        }

        // Cập nhật biến hiển thị ghế đã chọn
        if (choose) {
          ticket_controller.seats_flight_father.value = allSeats_go.isNotEmpty
              ? "Ghế đã chọn: ${allSeats_go.join(', ')}"
              : "Chọn ghế";
          allSeats_go = [];
        } else {
          ticket_controller.seats_flight_child.value = allSeats_go.isNotEmpty
              ? "Ghế đã chọn: ${allSeats_go.join(', ')}"
              : "Chọn ghế";
          allSeats_go = [];
        }
      } else {
        for (var flightSeatsMap
            in ticket_controller.listOfFlightBackSeatsMaps) {
          if (flight_back != null &&
              flightSeatsMap.containsKey(flight_back.id)) {
            var list_customer = flightSeatsMap[flight_back.id];
            if (list_customer != null && list_customer.isNotEmpty) {
              for (var setas in list_customer) {
                allSeats_back.add(setas.flight_back_seats!.value);
              }
            }
          }
        }

        // Cập nhật biến hiển thị ghế đã chọn
        if (choose) {
          ticket_controller.seats_flight_father_back.value =
              allSeats_back.isNotEmpty
                  ? "Ghế đã chọn: ${allSeats_back.join(', ')}"
                  : "Chọn ghế";
          allSeats_back = [];
        } else {
          ticket_controller.seats_flight_child_back.value =
              allSeats_back.isNotEmpty
                  ? "Ghế đã chọn: ${allSeats_back.join(', ')}"
                  : "Chọn ghế";
          allSeats_back = [];
        }
      }
    }

    taskSeatsInListMap();

    return GestureDetector(
      onTap: () async {
        if (ticket_controller.customer_input.length ==
            (ticket_controller.customer.value +
                ticket_controller.children.value)) {
          flight_back == null
              ? await assets_controller.check_assets_block(flight_go!.id, null)
              : await assets_controller.check_assets_block(
                  null, flight_back.id);

          showModalBottomSheet(
            isScrollControlled: true,
            isDismissible: false,
            enableDrag: false,
            context: context,
            builder: (context) {
              return AnimatedContainer(
                height: 870,
                width: 430,
                duration: const Duration(milliseconds: 200),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      app_bar(
                        title: Text_Data(
                          name: "Chọn ghế | $to_city ------> $from_city",
                          color: AppColors.textColor,
                          size: 15,
                          maxLine: 1,
                        ),
                      ),
                      choose_seats(
                        flight_go: flight_go,
                        flight_back: flight_back,
                        choose: choose,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          show_dia_log1.showSuccessDialog(context, "Thông Báo",
              "Quý Khách hãy nhập đủ thông tin", false, null);
        }
      },
      child: Obx(
        () => Row(
          children: [
            const Icon(Icons.add_circle_outline, color: Colors.brown),
            const SizedBox(width: 5),
            Text_Data(
              color: Colors.brown,
              name: flight_back == null
                  ? choose
                      ? "${ticket_controller.seats_flight_father.value}"
                      : "${ticket_controller.seats_flight_child.value}"
                  : choose
                      ? "${ticket_controller.seats_flight_father_back.value}"
                      : "${ticket_controller.seats_flight_child_back.value}",
              size: 15,
              maxLine: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class seats extends StatelessWidget {
  seats({super.key, required this.to_city, required this.from_city});
  final String to_city;
  final String from_city;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            child: Row(
              children: [
                Text_Data(
                    name: to_city, color: Colors.black, size: 15, maxLine: 1),
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
