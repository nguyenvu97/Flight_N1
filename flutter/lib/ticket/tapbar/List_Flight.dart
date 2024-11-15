

import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/model/flight/FlightResponse.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ariport_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:flutter_application_4/ticket/findby_ticket/Choose_Customer_Child.dart';
import 'package:flutter_application_4/ticket/findby_ticket/Find_By_Ticket.dart';
import 'package:flutter_application_4/ticket/tapbar/Flight_Details.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';

class ListFlight extends StatefulWidget {
  const ListFlight({super.key});

  @override
  State<ListFlight> createState() => ListFlightState();
}

//! import getX here
Ticket_Getx_Controller ticket_controler = Get.put(Ticket_Getx_Controller());
Ariport_Controller ariport_controller = Get.put(Ariport_Controller());
Show_Dia_log show_dia_log = Get.put(Show_Dia_log());

class ListFlightState extends State<ListFlight> {
  RxList<Widget> body = <Widget>[].obs;
  late GlobalKey<AnimatedListState> list_key_flight = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addData();
    });
    super.initState();
  }

  void checkFlight(int data) async {
    if (data <= 0) {
      show_dia_log.showSuccessDialog(context, "Thông Báo",
          "Hiện tại không cho chuyến bay", true, FindByTicket());
      return;
    }
  }

  void addData() async {
    body.clear();
    var data = await ticket_controler.flightData();
    if (!ticket_controler.error.value) {
      show_dia_log.showSuccessDialog(context, "Thông Báo",
          "Hiện tại không cho chuyến bay", true, FindByTicket());
      return;
    }
    if (data == null) return;

    if (!ticket_controler.isSelectFindBy.value && data.flight_go != null) {
      data.flight_go!.forEach((flight) {
        body.add(builderFlight(flight));
        list_key_flight.currentState?.insertItem(body.length - 1);
      });
    } else {
      if (!ticket_controler.isRouterGoAndBack.value &&
          data.flight_back != null &&
          data.flight_back!.isNotEmpty) {
        data.flight_back!.forEach((flight) {
          body.add(builderFlight(flight));
          list_key_flight.currentState?.insertItem(body.length - 1);
        });
      } else {
        data.flight_go!.forEach((flight) {
          body.add(builderFlight(flight));
          list_key_flight.currentState?.insertItem(body.length - 1);
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedList(
        key: list_key_flight,
        initialItemCount: body.length,
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position:
                animation.drive(Tween(begin: Offset(1, 0), end: Offset(0, 0))),
            child: body[index],
          );
        },
      ),
    );
  }

  Widget builderFlight(Flight flight) {
    DateTime departure = DateTime.parse(flight.departureTime);
    DateTime arrival = DateTime.parse(flight.arrivalTime);
    Duration duration = arrival.difference(departure);
    String departureTime = DateFormat("yyyy-MM-dd").format(departure);
    String arrivalTime = DateFormat("yyyy-MM-dd").format(arrival);

    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);

    String durationString = "${hours}tiếng ${minutes}phút";
    DateTime endTime1;
    String endTime;
    DateTime startTime1;
    String stratTime;
    Duration duration1;
    int hours1;
    int minutes1;
    String durationString1;
    Duration time_wait;
    String data_time_Waite;

    if (flight.flights != null && flight.flights!.isNotEmpty) {
      endTime1 = DateTime.parse(flight.flights!.first.arrivalTime);
      endTime = DateFormat("yyyy-MM-dd").format(endTime1);
      startTime1 = DateTime.parse(flight.flights!.first.departureTime);
      stratTime = DateFormat("yyyy-MM-dd").format(startTime1);
      duration1 = endTime1.difference(startTime1);

      hours1 = duration1.inHours.remainder(24);
      minutes1 = duration1.inMinutes.remainder(60);
      durationString1 = "${hours1}tiếng ${minutes1}phút";
      time_wait = startTime1.difference(arrival);
      int day = time_wait.inDays;
      int hours2 = time_wait.inHours.remainder(24);
      int minutes2 = time_wait.inMinutes.remainder(60);
      data_time_Waite = day <= 0
          ? "Thời gian chờ : ${hours2}tiếng ${minutes2}phút "
          : "Thời gian chờ : ${day}ngày ${hours2}tiếng ${minutes2}phút";
    } else {
      durationString1 = "";
      data_time_Waite = "";
      endTime1 = DateTime.now(); // or any default value
      endTime = DateFormat("yyyy-MM-dd").format(endTime1);
      startTime1 = DateTime.now(); // or any default value
      stratTime = DateFormat("yyyy-MM-dd").format(startTime1);
    }

    return ListTile(
      title: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1, color: Colors.black)),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text_Data(
                              name: departureTime.toString(),
                              color: Colors.black,
                              size: 15,
                              maxLine: 1),
                          Text_Data(
                              name:
                                  "${departure.hour.toString()}H${departure.minute.toString()}M",
                              color: Colors.black,
                              size: 15,
                              maxLine: 1),
                          Text_Data(
                              name: ticket_controler.isRouterGoAndBack.value
                                  ? ariport_controller.startCountry.value
                                  : ariport_controller.endCountry.value,
                              color: Colors.black,
                              size: 15,
                              maxLine: 1)
                        ]),
                  )),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            child: Row(
                              children: [
                                Text("-----------"),
                                Icon(Icons.airplanemode_on)
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Text_Data(
                              name: flight.flights != null
                                  ? "${flight.code} /${flight.flights!.first.code}"
                                  : flight.code,
                              color: Colors.black,
                              size: 12,
                              maxLine: 1,
                            ),
                          ),
                        ]),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text_Data(
                              name: flight.flights != null &&
                                      flight.flights!.isNotEmpty
                                  ? ticket_controler.isRouterGoAndBack.value
                                      ? endTime.toString()
                                      : stratTime.toString()
                                  : ticket_controler.isRouterGoAndBack.value
                                      ? arrivalTime.toString()
                                      : departureTime.toString(),
                              color: Colors.black,
                              size: 15,
                              maxLine: 1),
                          Text_Data(
                              name: flight.flights != null &&
                                      flight.flights!.isNotEmpty
                                  ? "${endTime1.hour.toString()}H${endTime1.minute.toString()}M"
                                  : "${arrival.hour.toString()}H${arrival.minute.toString()}M",
                              color: Colors.black,
                              size: 15,
                              maxLine: 1),
                          Text_Data(
                              name: ticket_controler.isRouterGoAndBack.value
                                  ? ariport_controller.endCountry.value
                                  : ariport_controller.startCountry.value,
                              color: Colors.black,
                              size: 15,
                              maxLine: 1),
                        ]),
                  )),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text_Data(
                      name: flight.flights != null && flight.flights!.isNotEmpty
                          ? "Giá vé: ${ticket_controler.formatCurrency(flight.basePrice + flight.flights!.first.basePrice)} "
                          : "Giá vé: ${ticket_controler.formatCurrency(flight.basePrice)}",
                      color: Colors.black,
                      size: 15,
                      maxLine: 1,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (!ticket_controller.isSelectFindBy.value) {
                          ticket_controler.flightGo.value = flight;
                        } else {
                          ticket_controler.isRouterGoAndBack.value
                              ? ticket_controler.flightGo.value = flight
                              : ticket_controler.flightBack.value = flight;
                        }
                        // print(ticket_controler.flightBack.value!.airline);
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                            border: Border.all(
                              width: 1,
                              color: !ticket_controller.isSelectFindBy.value
                                  ? flight == ticket_controler.flightGo.value
                                      ? Colors.red
                                      : Colors.black
                                  : ticket_controler.isRouterGoAndBack.value
                                      ? flight ==
                                              ticket_controler.flightGo.value
                                          ? Colors.red
                                          : Colors.black
                                      : flight ==
                                              ticket_controler.flightBack.value
                                          ? Colors.red
                                          : Colors.black,
                            )),
                        alignment: Alignment.center,
                        child: Text_Data(
                            name: "Chọn",
                            color: !ticket_controller.isSelectFindBy.value
                                ? ticket_controler.flightGo.value == flight
                                    ? Colors.red
                                    : Colors.black
                                : ticket_controler.isRouterGoAndBack.value
                                    ? ticket_controler.flightGo.value == flight
                                        ? Colors.red
                                        : Colors.black
                                    : ticket_controler.flightBack.value ==
                                            flight
                                        ? Colors.red
                                        : Colors.black,
                            size: 10,
                            maxLine: 1),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 600,
                          child: Column(
                            children: [
                              AppBar(
                                actions: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const  Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ))
                                ],
                                backgroundColor: Colors.white12,
                                automaticallyImplyLeading: false,
                                leading: null,
                                title: Text_Data(
                                    name: "Chi tiết chuyến bay ",
                                    color: Colors.black,
                                    size: 20,
                                    maxLine: 1),
                              ),
                              Flight_Details(
                                arrival: arrival,
                                arrivalTime: arrivalTime,
                                departure: departure,
                                departureTime: departureTime,
                                durationString: durationString,
                                flight: flight,
                                isRouterGoAndBack:
                                    ticket_controler.isRouterGoAndBack.value,
                                data_time_Waite: data_time_Waite,
                                durationString1: durationString1,
                                endTime: endTime,
                                endTime1: endTime1,
                                startTime1: startTime1,
                                stratTime: stratTime,
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text_Data(
                            name: "Chi tiết chuyến bay",
                            color: Colors.black,
                            size: 12,
                            maxLine: 1),
                        Icon(Icons.arrow_drop_down)
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
