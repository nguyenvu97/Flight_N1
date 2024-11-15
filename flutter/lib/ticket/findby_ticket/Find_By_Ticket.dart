import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/App_Colors.dart';

import 'package:flutter_application_4/common/Box_Container/New_Box.dart';
import 'package:flutter_application_4/common/LoadingUtils.dart';
import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ariport_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:flutter_application_4/ticket/choose_tickit/Choose_Ticket.dart';
import 'package:flutter_application_4/ticket/findby_ticket/Adress_Time.dart';
import 'package:flutter_application_4/ticket/findby_ticket/Choose_Customer_Child.dart';
import 'package:flutter_application_4/ticket/findby_ticket/Show_Menu.dart';
import 'package:flutter_application_4/ticket/findby_ticket/TimeGo_CallBack.dart';
import 'package:flutter_application_4/home/Home_page.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';

class FindByTicket extends StatefulWidget {
  const FindByTicket({super.key});

  @override
  State<FindByTicket> createState() => _FindByTicketState();
}

class _FindByTicketState extends State<FindByTicket>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Ticket_Getx_Controller ticket_controller = Get.put(Ticket_Getx_Controller());
  Show_Dia_log show_dia_log = Get.put(Show_Dia_log());

  void _handleTabSelection() {
    if (_tabController.index == 0) {
      ticket_controller.isSelectFindBy.value = true;
    } else if (_tabController.index == 1) {
      ticket_controller.isSelectFindBy.value = false;
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
                child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/ios2.jpg"), fit: BoxFit.cover)),
            )),
            Obx(
              () => Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text_Data(
                                name: 'Tìm Kiếm Chuyến Bay',
                                color: Colors.white,
                                size: 25,
                                maxLine: 1),
                            const SizedBox(width: 50), // To balance the row
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: AppColors.FlightColors,
                              borderRadius: BorderRadius.circular(30)),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.white,
                            indicatorColor: Colors.white,
                            dividerColor: Colors.transparent,
                            tabs: [
                              Tab(
                                child: Center(
                                  child: Text_Data(
                                      name: 'Khứ Hồi',
                                      color: null,
                                      size: 20,
                                      maxLine: 1),
                                ),
                              ),
                              Tab(
                                child: Center(
                                  child: Text_Data(
                                      name: 'Một Chiều',
                                      color: null,
                                      size: 20,
                                      maxLine: 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(controller: _tabController, children: [
                      // page 1
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AdressAndTime(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          ariport_controller.swapItems();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          height: 70,
                                          width: 70,
                                          child: Container(
                                            child: Icon(Icons.refresh),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  GoAndCallBack()
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.FlightColors,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: const Text(
                                            "Khách Hàng",
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 50,
                                                width: media.width * 0.55,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "0${ticket_controller.customer.toString()}",
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ticket_controller
                                                                  .children >
                                                              0
                                                          ? "Người Lớn , 0${ticket_controller.children} Trẻ Em"
                                                          : "Người Lớn",
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                  child:
                                                      ChooseBigUserAndKiss()),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                      // page 2
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: SizedBox(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AdressAndTime(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          ariport_controller.swapItems();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          height: 70,
                                          width: 70,
                                          child: Container(
                                            child: Icon(Icons.refresh),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const GoAndCallBack()
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.FlightColors,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: const Text(
                                            "Khách Hàng",
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 50,
                                                width: media.width * 0.55,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "0${ticket_controller.customer.toString()}",
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ticket_controller
                                                                  .children >
                                                              0
                                                          ? "Người Lớn , 0${ticket_controller.children} Trẻ Em"
                                                          : "Người Lớn",
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const ChooseBigUserAndKiss(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                            child: Checkbox(
                          value: ticket_controller.isChecked.value,
                          onChanged: (value) {
                            ticket_controller.onCheckboxChanged(value);
                          },
                        )),
                        Text_Data(
                            name: "Hiển Thị Loại Vé Loại Giá Được Phép Hoàn",
                            color: Colors.black,
                            size: 15,
                            maxLine: 1),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      LoadingUtils.show();
                      Future.delayed(Duration(seconds: 3), () {
                        if (ticket_controller.activeStep.value == null ||
                            ticket_controller.activeStep.value == 2) {
                          ticket_controller.activeStep.value = 0;
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chooseflight()));
                        LoadingUtils.hide();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      width: media.width * 0.8,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 157, 157, 3),
                          borderRadius: BorderRadius.circular(30)),
                      height: media.height * 0.07,
                      alignment: Alignment.center,
                      child: Text_Data(
                          name: "Tìm Kiếm Chuyến Bay",
                          color: Colors.white,
                          size: 20,
                          maxLine: 1),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// OK
}
