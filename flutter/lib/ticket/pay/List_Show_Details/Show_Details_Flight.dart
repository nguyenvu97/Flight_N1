import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/model/flight/Ticket.dart';
import 'package:flutter_application_4/ticket/tapbar/Flight_Details.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../sevice_api/gex_controller/Ticket_Getx.Controller.dart';

class Show_Details_Flight extends StatefulWidget {
  const Show_Details_Flight({super.key});

  @override
  State<Show_Details_Flight> createState() => _Show_Details_FlightState();
}

late AnimationController _controller;
late Animation<Offset> _animation;
Ticket_Getx_Controller ticket_controller = Get.put(Ticket_Getx_Controller());

class _Show_Details_FlightState extends State<Show_Details_Flight>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation =
        Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(_controller);
    _controller.forward();
  }

  var tickit_data = ticket_controller.tickitDto.value;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return AnimatedContainer(
        height: media.height * 0.75,
        duration: Duration(milliseconds: 200),
        child: SlideTransition(
          position: _animation,
          child: buider_flight(context),
        ));
  }

  Widget buider_flight(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final flight = tickit_data!.flightsGo;
    final flightBack = tickit_data!.flightsBack;

    DateTime departure = DateTime.parse(flight.departureTime.toString());
    DateTime arrival = DateTime.parse(flight.arrivalTime.toString());

    Duration duration = arrival.difference(departure);
    String departureTime = DateFormat("yyyy-MM-dd").format(departure);
    String arrivalTime = DateFormat("yyyy-MM-dd").format(arrival);

    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);
    String durationString = "${hours} tiếng ${minutes} phút";

    DateTime endTime1;
    String endTime;
    DateTime startTime1;
    String startTime;
    Duration duration1;
    String durationString1;
    Duration timeWait;
    String dataTimeWait;

    if (flight.flights != null && flight.flights!.isNotEmpty) {
      endTime1 = DateTime.parse(flight.flights!.first.arrivalTime.toString());
      endTime = DateFormat("yyyy-MM-dd").format(endTime1);

      startTime1 =
          DateTime.parse(flight.flights!.first.departureTime.toString());
      startTime = DateFormat("yyyy-MM-dd").format(startTime1);

      duration1 = endTime1.difference(startTime1);
      int hours1 = duration1.inHours.remainder(24);
      int minutes1 = duration1.inMinutes.remainder(60);
      durationString1 = "${hours1} tiếng ${minutes1} phút";

      timeWait = startTime1.difference(arrival);
      int days = timeWait.inDays;
      int hours2 = timeWait.inHours.remainder(24);
      int minutes2 = timeWait.inMinutes.remainder(60);

      dataTimeWait = days <= 0
          ? "Thời gian chờ: ${hours2} tiếng ${minutes2} phút"
          : "Thời gian chờ: ${days} ngày ${hours2} tiếng ${minutes2} phút";
    } else {
      durationString1 = "";
      dataTimeWait = "";
      endTime1 = DateTime.now(); // Hoặc giá trị mặc định khác
      endTime = DateFormat("yyyy-MM-dd").format(endTime1);
      startTime1 = DateTime.now(); // Hoặc giá trị mặc định khác
      startTime = DateFormat("yyyy-MM-dd").format(startTime1);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
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
            Text_Data(
                name: "Chiều đi", color: Colors.black, size: 15, maxLine: 1),
            Flight_Details(
              arrival: arrival,
              arrivalTime: arrivalTime,
              departure: departure,
              departureTime: departureTime,
              durationString: durationString,
              flight: ticket_controller.flightGo.value!,
              isRouterGoAndBack: ticket_controller.isRouterGoAndBack.value,
              data_time_Waite: dataTimeWait,
              durationString1: durationString1,
              endTime: endTime,
              endTime1: endTime1,
              startTime1: startTime1,
              stratTime: startTime,
            ),
            flightBack != null ? build_flight_back() : Container(),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: media.height * 0.05,
                width: media.width * 1,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: Text_Data(
                    name: "Xác nhận",
                    color: Colors.black,
                    size: 15,
                    maxLine: 1),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget build_flight_back() {
    final flightBack = tickit_data!.flightsBack;

    DateTime departure = DateTime.parse(flightBack!.departureTime.toString());
    DateTime arrival = DateTime.parse(flightBack.arrivalTime.toString());

    Duration duration = arrival.difference(departure);
    String departureTime = DateFormat("yyyy-MM-dd").format(departure);
    String arrivalTime = DateFormat("yyyy-MM-dd").format(arrival);

    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);
    String durationString = "${hours} tiếng ${minutes} phút";

    DateTime endTime1;
    String endTime;
    DateTime startTime1;
    String startTime;
    Duration duration1;
    String durationString1;
    Duration timeWait;
    String dataTimeWait;

    if (flightBack.flights != null && flightBack.flights!.isNotEmpty) {
      endTime1 =
          DateTime.parse(flightBack.flights!.first.arrivalTime.toString());
      endTime = DateFormat("yyyy-MM-dd").format(endTime1);

      startTime1 =
          DateTime.parse(flightBack.flights!.first.departureTime.toString());
      startTime = DateFormat("yyyy-MM-dd").format(startTime1);

      duration1 = endTime1.difference(startTime1);
      int hours1 = duration1.inHours.remainder(24);
      int minutes1 = duration1.inMinutes.remainder(60);
      durationString1 = "${hours1} tiếng ${minutes1} phút";

      timeWait = startTime1.difference(arrival);
      int days = timeWait.inDays;
      int hours2 = timeWait.inHours.remainder(24);
      int minutes2 = timeWait.inMinutes.remainder(60);

      dataTimeWait = days <= 0
          ? "Thời gian chờ: ${hours2} tiếng ${minutes2} phút"
          : "Thời gian chờ: ${days} ngày ${hours2} tiếng ${minutes2} phút";
    } else {
      durationString1 = "";
      dataTimeWait = "";
      endTime1 = DateTime.now(); // Hoặc giá trị mặc định khác
      endTime = DateFormat("yyyy-MM-dd").format(endTime1);
      startTime1 = DateTime.now(); // Hoặc giá trị mặc định khác
      startTime = DateFormat("yyyy-MM-dd").format(startTime1);
    }
    return Column(
      children: [
        Text_Data(name: "Chiều về", color: Colors.black, size: 15, maxLine: 1),
        Flight_Details(
          arrival: arrival,
          arrivalTime: arrivalTime,
          departure: departure,
          departureTime: departureTime,
          durationString: durationString,
          flight: ticket_controller.flightGo.value!,
          isRouterGoAndBack: ticket_controller.isRouterGoAndBack.value,
          data_time_Waite: dataTimeWait,
          durationString1: durationString1,
          endTime: endTime,
          endTime1: endTime1,
          startTime1: startTime1,
          stratTime: startTime,
        ),
      ],
    );
  }
}
