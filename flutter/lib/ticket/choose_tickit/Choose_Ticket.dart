import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/App_Colors.dart';

import 'package:flutter_application_4/common/Box_Container/New_Box.dart';
import 'package:flutter_application_4/common/ButtonNavigator.dart';
import 'package:flutter_application_4/common/Not_Found.dart';
import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/model/flight/FlightResponse.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ariport_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Pay_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:flutter_application_4/sevice_api/Ticket_Service.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/assets_block_Controller.dart';
import 'package:flutter_application_4/ticket/findby_ticket/Choose_Customer_Child.dart';
import 'package:flutter_application_4/ticket/findby_ticket/Find_By_Ticket.dart';
import 'package:flutter_application_4/ticket/findby_ticket/Show_Menu.dart';
import 'package:flutter_application_4/ticket/input_data/Infomation_Customer.dart';
import 'package:flutter_application_4/ticket/pay/Payment_Tickit.dart';
import 'package:flutter_application_4/ticket/tapbar/Custom_TabBar_Round_trip.dart';
import 'package:flutter_application_4/ticket/tapbar/Customer_TapBar_One_Way.dart';
import 'package:flutter_application_4/ticket/tapbar/List_Flight.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';

import 'package:intl/intl.dart';

class Chooseflight extends StatefulWidget {
  Chooseflight({
    super.key,
  });

  @override
  State<Chooseflight> createState() => _ChooseflightState();
}

class _ChooseflightState extends State<Chooseflight>
    with SingleTickerProviderStateMixin {
  List<DateTime> futureDates = [];
  List<String> formattedFutureDates = [];
  //! impost Getx Here
  Ariport_Controller ariport_controller = Get.put(Ariport_Controller());
  Ticket_Getx_Controller ticket_controler = Get.put(Ticket_Getx_Controller());
  Pay_Controller pay_controller = Get.put(Pay_Controller());
  Show_Dia_log show_dia_log = Get.put(Show_Dia_log());
  Assets_Block_Controller assets_controller =
      Get.put(Assets_Block_Controller());
  //!

  DateTime parseDate(String dateString) {
    List<String> dateParts = dateString.split('-');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);
    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    @override
    void initState() {
      super.initState();
    }

    @override
    void dispose() {
      super.dispose();
    }

    void showAboutDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Xác nhận"),
            content: Text("Bạn có chắc chắn muốn hủy không?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng hộp thoại
                },
                child: Text("Không"),
              ),
              TextButton(
                onPressed: () {
                  if (ticket_controller.activeStep.value == 0) {
                    // Step 0: Just close the current dialog and reset
                    Navigator.of(context).pop();
                    ticket_controller.clean();
                    Navigator.of(context).pop();
                  } else if (ticket_controller.activeStep.value == 1) {
                    // Step 1: Reset, delete flight assets, and navigate back
                    ticket_controller.clean();
                    ticket_controller.activeStep.value = 0;
                    assets_controller.delete_assets_flightId();
                    Navigator.of(context).pop();
                  } else if (ticket_controller.activeStep.value == 2) {
                    // Step 2: Reset payment, delete flight assets, and navigate back
                    pay_controller.selectedPaymentIndex.value = -1;
                    ticket_controller.clean();
                    ticket_controller.activeStep.value = 0;
                    assets_controller.delete_assets_flightId();
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Có"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Obx(
        () => Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ticket_controler.isSelectFindBy.value
                      ? "assets/ios.png"
                      : "assets/ios2.jpg"),
                  fit: BoxFit.cover)),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: true,
                      leading: IconButton(
                          onPressed: () {
                            setState(() {
                              showAboutDialog(context);
                            });
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                      title: Text_Data(
                          name: "Vé Máy Bay",
                          color: Colors.black,
                          size: 20,
                          maxLine: 1),
                      actions: [],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: ticket_controler.isSelectFindBy.value
                                  ? AppColors.econdaryFlightColors
                                  : ticket_controler.isSelectFindBy.value
                                      ? AppColors.econdaryFlightColors
                                      : AppColors.FlightColors,
                            ),
                            height: 70,
                            child: IconStepper(
                              enableNextPreviousButtons: false,
                              steppingEnabled: false,
                              stepRadius: 20,
                              stepColor: ticket_controler.isSelectFindBy.value
                                  ? AppColors.econdaryFlightColors
                                  : AppColors.FlightColors,
                              lineLength: 20,
                              activeStepBorderPadding: 0,
                              icons: const [
                                Icon(
                                  Icons.airplanemode_active,
                                  size: 8,
                                ),
                                Icon(
                                  Icons.person,
                                  size: 8,
                                ),
                                Icon(
                                  Icons.payment,
                                  size: 8,
                                ),
                              ],
                              activeStep: ticket_controler.activeStep.value,
                              onStepReached: (index) {
                                setState(() {
                                  index = ticket_controler.activeStep.value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(() => headerText()),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Returns the header text based on the activeStep.
  Widget headerText() {
    DateTime now = DateTime.now();
    List<String> formattedFutureDates = List.generate(
        365,
        (index) =>
            DateFormat('dd/MM/yyyy').format(now.add(Duration(days: index))));

    if (ticket_controler.activeStep.value == 0) {
      if (ticket_controler.isSelectFindBy.value) {
        // Chuyến đi vòng
        return HeardFlightRoute(formattedFutureDates);
      } else {
        // Chuyến đi một chiều
        return HeardFlightRoute1(formattedFutureDates,
            Customer_TapBar_One_Way(key: UniqueKey()), false);
      }
    } else if (ticket_controler.activeStep.value == 1) {
      return const InfoCustomer();
    } else {
      return const Pay();
    }
  }

  String displayMessage() {
    if (ticket_controler.customer <= 0 && ticket_controler.children > 0) {
      return '${ticket_controler.children} trẻ em';
    } else if (ticket_controler.customer > 0 &&
        ticket_controler.children <= 0) {
      return '${ticket_controler.customer} người lớn';
    } else
      return '${ticket_controler.customer} người lớn và ${ticket_controler.children} trẻ em';
  }

//!  Time Flight
  Widget HeardFlightRoute(
    List<String> formattedFutureDates,
  ) {
    if (ticket_controler.isRouterGoAndBack.value) {
      return HeardFlightRoute1(
          formattedFutureDates,
          CustomTabBar(
            key: UniqueKey(),
          ),
          true);
    } else {
      return HeardFlightRoute1(
          formattedFutureDates,
          CustomTabBar(
            key: UniqueKey(),
          ),
          false);
    }
  }

  bool? checkChooseFlight(Flight? flight) {
    if (flight != null) {
      return true;
    } else {
      show_dia_log.showSuccessDialog(
          context, " Thông Báo ", "Hãy chọn chuyến bay", false, null);
      return false;
    }
  }

  //!  ONE_Way

  Widget HeardFlightRoute1(
      List<String> formattedFutureDates, Widget widget, bool? check) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: ticket_controler.isSelectFindBy.value
                  ? AppColors.econdaryFlightColors
                  : AppColors.FlightColors,
              borderRadius: BorderRadius.circular(20)),
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: formattedFutureDates.length,
            itemBuilder: (context, index) {
              String date = formattedFutureDates[index];
              DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      ticket_controler.isRouterGoAndBack.value
                          ? ticket_controler.timeGo.value = parsedDate
                          : ticket_controler.timeCallBack.value = parsedDate;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 60,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.5, color: Colors.transparent)),
                          alignment: Alignment.center,
                          child: Text_Data(
                              name: date,
                              color: Colors.black,
                              size: 15,
                              maxLine: 1)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ticket_controler.isSelectFindBy.value
                ? AppColors.econdaryFlightColors
                : AppColors.FlightColors,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                  height: 100, child: Icon(Icons.airplanemode_active)),
              SizedBox(
                height: 100,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text_Data(
                        name: ticket_controler.isRouterGoAndBack.value
                            ? DateFormat("yyyy-MM-dd").format(
                                ticket_controler.timeGo.value ?? DateTime.now())
                            : DateFormat("yyyy-MM-dd")
                                .format(ticket_controler.timeCallBack.value!),
                        color: Colors.black,
                        size: 15,
                        maxLine: 1,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text_Data(
                        name: !ticket_controler.isSelectFindBy.value
                            ? '${ariport_controller.startCountry.value} -------> ${ariport_controller.endCountry.value}'
                            : ticket_controler.isRouterGoAndBack.value
                                ? "${ariport_controller.startCountry.value} -------> ${ariport_controller.endCountry.value} "
                                : " ${ariport_controller.endCountry.value} -------> ${ariport_controller.startCountry.value} ",
                        color: Colors.black,
                        size: 15,
                        maxLine: 1,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text_Data(
                          name: displayMessage(),
                          color: Colors.black,
                          size: 15,
                          maxLine: 1,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          height: 500,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 450, child: widget),
            ],
          ),
        ),
        // ma giam gia
        Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ticket_controler.isSelectFindBy.value
                ? AppColors.econdaryFlightColors
                : AppColors.FlightColors,
          ),
          child: BottomNavigator(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (check == true) {
                    if (checkChooseFlight(ticket_controler.flightGo.value) ==
                        true) {
                      ticket_controler.isRouterGoAndBack.value = false;
                    }
                  } else {
                    if (ticket_controler.isRouterGoAndBack.value == false) {
                      if (checkChooseFlight(
                              ticket_controler.flightBack.value) ==
                          true) {
                        ticket_controler.activeStep.value = 1;
                      }
                    } else {
                      if (checkChooseFlight(ticket_controler.flightGo.value) ==
                          true) {
                        ticket_controler.activeStep.value = 1;
                      }
                    }
                  }
                });
              },
              child: Text_Data(
                name: "Tiếp tục ",
                color: Colors.black,
                size: 20,
                maxLine: 1,
              ),
            ),
          ),
        )
      ],
    );
  }
}

//! dia diem di so nguoi *
