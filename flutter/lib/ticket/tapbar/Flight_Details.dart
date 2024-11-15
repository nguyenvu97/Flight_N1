import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_4/common/Text_Data.dart';

import 'package:flutter_application_4/model/flight/FlightResponse.dart';

class Flight_Details extends StatefulWidget {
  String departureTime;
  DateTime departure;
  String durationString;
  Flight flight;
  String arrivalTime;
  DateTime arrival;
  bool isRouterGoAndBack;
  String data_time_Waite;
  String stratTime;
  DateTime startTime1;
  String durationString1;
  String endTime;
  DateTime endTime1;
  Flight_Details(
      {super.key,
      required this.arrival,
      required this.arrivalTime,
      required this.departure,
      required this.departureTime,
      required this.durationString,
      required this.isRouterGoAndBack,
      required this.flight,
      required this.data_time_Waite,
      required this.durationString1,
      required this.endTime,
      required this.endTime1,
      required this.startTime1,
      required this.stratTime});

  @override
  State<Flight_Details> createState() => _Flight_DetailsState();
}

class _Flight_DetailsState extends State<Flight_Details> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      height: media.height * 0.55,
      width: media.width * 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text_Data(
                name: "Chuyến bay A", color: Colors.blue, size: 15, maxLine: 1),
          ),
          flight_details(
              widget.departureTime,
              widget.departure,
              widget.durationString,
              widget.flight,
              widget.arrivalTime,
              widget.arrival),
          if (widget.flight.flights != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text_Data(
                      name: widget.data_time_Waite,
                      color: Colors.red,
                      size: 15,
                      maxLine: 1),
                ),
                const Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text_Data(
                      name: "Chuyến bay B",
                      color: Colors.blue,
                      size: 15,
                      maxLine: 1),
                ),
                flight_details(
                    widget.stratTime,
                    widget.startTime1,
                    widget.durationString1,
                    widget.flight.flights!.first,
                    widget.endTime,
                    widget.endTime1),
              ],
            ),
        ],
      ),
    );
  }

  Container flight_details(
      String departureTime,
      DateTime departure,
      String durationString,
      Flight flight,
      String arrivalTime,
      DateTime arrival) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Column(
            children: [
              Text_Data(
                  name:
                      "${departureTime} ${departure.hour.toString()}H${departure.minute.toString()}M",
                  color: Colors.black,
                  size: 15,
                  maxLine: 1),
              Text_Data(
                  name: flight.fromCity,
                  color: Colors.black,
                  size: 15,
                  maxLine: 1),
              SizedBox(
                height: 20,
              ),
              Text_Data(
                  name: durationString,
                  color: Colors.black,
                  size: 15,
                  maxLine: 1),
              SizedBox(
                height: 10,
              ),
              Text_Data(
                  name: flight.code,
                  color: Colors.black,
                  size: 15,
                  maxLine: 1),
              SizedBox(
                height: 20,
              ),
              Text_Data(
                  name: widget.isRouterGoAndBack
                      ? "${arrivalTime.toString()} ${arrival.hour.toString()}H${arrival.minute.toString()}M"
                      : "${arrivalTime.toString()} ${arrival.hour.toString()}H${arrival.minute.toString()}M",
                  color: Colors.black,
                  size: 15,
                  maxLine: 1),
              Text_Data(
                  name: flight.toCity,
                  color: Colors.black,
                  size: 15,
                  maxLine: 1),
            ],
          ),
        ],
      ),
    );
  }
}
