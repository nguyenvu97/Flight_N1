import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/App_Colors.dart';
import 'package:flutter_application_4/common/Box_Container/New_Box.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:flutter_application_4/ticket/tapbar/List_Flight.dart';
import 'package:get/get.dart';

class Customer_TapBar_One_Way extends StatefulWidget {
  Customer_TapBar_One_Way({
    Key? key,
  }) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<Customer_TapBar_One_Way>
    with SingleTickerProviderStateMixin {
  late TabController _tabController1;

  Ticket_Getx_Controller ticket_controller = Get.put(Ticket_Getx_Controller());

  void _handleTabSelection() {
    setState(() {
      if (_tabController1.index == 0) {
        ticket_controller.isSelectTicketOneWay.value = true;
      }
      if (_tabController1.index == 1) {
        ticket_controller.isSelectTicketOneWay.value = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController1 = TabController(length: 2, vsync: this);
    _tabController1.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(microseconds: 200),
        height: media.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: ticket_controler.isSelectFindBy.value
              ? AppColors.econdaryFlightColors
              : AppColors.FlightColors,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.white,
              dividerColor: Colors.transparent,
              controller: _tabController1,
              tabs: [
                Tab(
                  child: Container(
                      height: 70,
                      width: 150,
                      alignment: Alignment.center,
                      child: Text_Data(
                        name: ticket_controller.ticket.value,
                        color: Colors.black,
                        size: 15,
                        maxLine: 1,
                      )),
                ),
                Tab(
                  child: Container(
                      height: 70,
                      width: 150,
                      alignment: Alignment.center,
                      child: Text_Data(
                        name: ticket_controller.ticKetVip.value,
                        color: Colors.black,
                        size: 15,
                        maxLine: 1,
                      )),
                )
              ],
            ),
            AnimatedContainer(
              duration: const Duration(microseconds: 200),
              child: SizedBox(
                height: media.height * 0.42,
                width: media.width * 1,
                child: TabBarView(
                  controller: _tabController1,
                  children: [
                    // Ticket
                    ListFlight(key: UniqueKey()),

                    ListFlight(key: UniqueKey()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
