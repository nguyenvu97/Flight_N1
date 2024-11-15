import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/App_Colors.dart';
import 'package:flutter_application_4/common/Box_Container/New_Box.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GoAndCallBack extends StatefulWidget {
  const GoAndCallBack({super.key});

  @override
  State<GoAndCallBack> createState() => _GoAndCallBackState();
}

Ticket_Getx_Controller ticket_controller = Get.put(Ticket_Getx_Controller());

class _GoAndCallBackState extends State<GoAndCallBack> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
                color: AppColors.FlightColors,
                borderRadius: BorderRadius.circular(30)),
            height: media.height * 0.15,
            width: media.width * 0.3,
            child: Column(children: [
              Container(
                  height: 50,
                  child: Text_Data(
                      name: "Ngày Đi",
                      color: Colors.black,
                      size: 20,
                      maxLine: 1)),
              GestureDetector(
                onTap: () async {
                  if (!ticket_controller.isSelectFindBy.value) {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    ).then((selectedDate) {
                      setState(() {
                        ticket_controller.timeGo.value = selectedDate;
                      });
                    });
                  } else {
                    final result = await showDateRangePicker(

                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)));
                    if (result != null) {
                      setState(() {
                        ticket_controller.timeGo.value = result.start;
                        ticket_controller.timeCallBack.value = result.end;
                        ticket_controller.checkTime(context);
                      });
                    }
                  }
                },
                child: Center(
                    child: Text_Data(
                        name: ticket_controller.timeGo.value != null
                            ? DateFormat('dd/MM/yyyy')
                                .format(ticket_controller.timeGo.value!)
                            : "+",
                        color: Colors.black,
                        size: 20,
                        maxLine: 1)),
              )
            ])),
        SizedBox(
          height: media.height * 0.07,
        ),
        Obx(
          () => Visibility(
            visible: ticket_controller.isSelectFindBy.value == true,
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.FlightColors,
                  borderRadius: BorderRadius.circular(30)),
              height: media.height * 0.15,
              width: media.width * 0.3,
              child: Container(
                  child: Column(
                children: [
                  SizedBox(
                      height: 50,
                      child: Text_Data(
                          name: "Ngày Về",
                          color: Colors.black,
                          size: 20,
                          maxLine: 1)),
                  GestureDetector(
                    onTap: () async {
                      final result = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(Duration(days: 365)));
                      if (result != null) {
                        setState(() {
                          ticket_controller.timeGo.value = result.start;
                          ticket_controller.timeCallBack.value = result.end;
                          ticket_controller.checkTime(context);
                        });
                      }
                    },
                    child: Center(
                        child: Text_Data(
                            name: ticket_controller.timeCallBack.value != null
                                ? DateFormat('dd/MM/yyyy').format(
                                    ticket_controller.timeCallBack.value!)
                                : "+",
                            color: Colors.black,
                            size: 20,
                            maxLine: 1)),
                  )
                ],
              )),
            ),
          ),
        ),
      ],
    );
  }
}
