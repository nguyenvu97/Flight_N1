import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/App_Colors.dart';
import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/home/Home_page.dart';
import 'package:flutter_application_4/home/Menu_Main_Home.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Pay_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:flutter_application_4/ticket/pay/List_Choose_Customer.dart';
import 'package:flutter_application_4/ticket/pay/List_Show_Details/Show_Details_Flight.dart';

import 'package:get/get.dart';

import 'List_Show_Details/List_Payment.dart';

class Pay extends StatefulWidget {
  const Pay({super.key});

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> openContainerAnimation;
  late Tween<double> openContainerTween;

  final Ticket_Getx_Controller ticketController =
      Get.put(Ticket_Getx_Controller());
  final Pay_Controller payController = Get.put(Pay_Controller());
  final Show_Dia_log show_dia_log = Get.put(Show_Dia_log());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    openContainerTween = Tween<double>(begin: 0.0, end: 100);
    openContainerAnimation = openContainerTween.animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
  
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    var tickit_data = ticketController.tickitDto.value;

    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        child: Container(
          height: media.height * 1,
          width: media.width * 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: openContainerAnimation,
                builder: (BuildContext context, Widget? child) {
                  return AnimatedContainer(
                    height: !payController.isOpenContai.value
                        ? media.height * 0.4
                        : media.height * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ticketController.isSelectFindBy.value
                          ? AppColors.econdaryFlightColors
                          : AppColors.FlightColors,
                    ),
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text_Data(
                                      name: "Tổng Cộng : ",
                                      color: AppColors.textColor,
                                      size: 15,
                                      maxLine: 1),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text_Data(
                                        name:
                                            "${AppColors.formatCurrency(tickit_data?.totalTicket ?? 0.0)}",
                                        color: AppColors.textColor,
                                        size: 30,
                                        maxLine: 1),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text_Data(
                                      name: "Chi tiết",
                                      color: Colors.black,
                                      size: 15,
                                      maxLine: 1),
                                  Obx(
                                    () => IconButton(
                                      onPressed: () {
                                        payController.isOpenContai.value =
                                            !payController.isOpenContai.value;
                                        if (payController.isOpenContai.value) {
                                          animationController.forward();
                                        } else {
                                          animationController.reverse();
                                        }
                                      },
                                      icon: payController.isOpenContai.value
                                          ? const Icon(
                                              Icons.arrow_drop_down_circle,
                                              size: 25,
                                              color: Colors.black)
                                          : const Icon(
                                              Icons.arrow_drop_up_sharp,
                                              size: 25,
                                              color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text_Data(
                                name: ariport_controller.startCountry.value,
                                color: Colors.black,
                                size: 15,
                                maxLine: 1),
                            Column(
                              children: [
                                const SizedBox(
                                  child: Text("------------------>"),
                                ),
                                if (ticketController.flightBack.value != null)
                                  const SizedBox(
                                    child: Text("<------------------"),
                                  )
                              ],
                            ),
                            Text_Data(
                                name: ariport_controller.endCountry.value,
                                color: Colors.black,
                                size: 15,
                                maxLine: 1)
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Flexible(child: List_Details_Customer())
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ticketController.isSelectFindBy.value
                          ? AppColors.econdaryFlightColors
                          : AppColors.FlightColors),
                  height: media.height * 0.41,
                  child: const List_Paymanst()),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (ticketController.tickitDto.value == null) {
                    show_dia_log.showSuccessDialog(
                        context,
                        "Thông báo",
                        "Quý Khách chưa chọn chuyến bay",
                        true,
                        const MainTabView());
                  } else {
                    if (payController.selectedPaymentIndex.value == -1) {
                      show_dia_log.showSuccessDialog(
                          context,
                          "Thông báo",
                          "Quý Khách chưa chọn phương thức thanh toán",
                          false,
                          null);
                    }
                    payController.Payment(
                        ticketController.tickitDto.value!.orderNo);

                    Future.delayed(Duration(seconds: 5), () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainTabView()),

                        );
                      });
                      ticket_controller.clean();
                      payController.clean_data_payment();
                    });
                   const Duration(minutes: 1);
                  }
                },
                child: Container(
                  height: media.height * 0.05,
                  width: media.width * 1,
                  margin: const EdgeInsetsDirectional.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.amber),
                  alignment: Alignment.center,
                  child: Text_Data(
                      name: "Xác nhận",
                      color: Colors.white,
                      size: 15,
                      maxLine: 1),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
