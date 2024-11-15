import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/App_Colors.dart';
import 'package:flutter_application_4/common/Box_Container/New_Box.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:flutter_application_4/ticket/tapbar/List_Flight.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    Key? key,
  }) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Ticket_Getx_Controller ticket_controller = Get.put(Ticket_Getx_Controller());

  void _handleTabSelection() {
    setState(() {
      if (!ticket_controller.isRouterGoAndBack.value) {
        if (_tabController.index == 0) {
          ticket_controller.isSelectbusiness.value = true;
        } else {
          ticket_controller.isSelectbusiness.value = false;
        }
      } else {
        if (_tabController.index == 0) {
          ticket_controller.isSelectTicketOneWay.value = true;
        } else {
          ticket_controller.isSelectTicketOneWay.value = false;
        }
      }
    });
  }

  //! state vip and normal

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.white,
              dividerColor: Colors.transparent,
              controller: _tabController,
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
              duration: const Duration(microseconds: 400),
              child: SizedBox(
                height: media.height * 0.42,
                width: media.width * 1,
                child: TabBarView(
                  controller: _tabController,
                  children: [
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
