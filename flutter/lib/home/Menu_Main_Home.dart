import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/Box_Container/New_Box.dart';
import 'package:flutter_application_4/common/LoadingUtils.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/hotel/Hotel_Details.dart';
import 'package:flutter_application_4/hotel/Hotel_HomePage.dart';
import 'package:flutter_application_4/hotel/Search_hotel.dart';
import 'package:flutter_application_4/login/New_login.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ariport_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Login_Get_Controller.dart';
import 'package:flutter_application_4/ticket/findby_ticket/Find_By_Ticket.dart';
import 'package:flutter_application_4/home/Home_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}



class _MainTabViewState extends State<MainTabView>
    with TickerProviderStateMixin {
  late TabController? controller;
  final LabeledGlobalKey<ScaffoldState> sideMenuScaffoldKey = LabeledGlobalKey<ScaffoldState>('sideMenuScaffoldMainTab');

  Ariport_Controller ariport_controller = Get.put(Ariport_Controller());
  int selectMenu = 0;
  int _currentIndex = 0;

  Login_Getx_Controller login_controller = Get.put(Login_Getx_Controller());

  List menuArr = [
    {"name": "Our Books", "icon": Icons.book},
    {"name": "Our Stores", "icon": Icons.storefront},
    {"name": "Careers", "icon": Icons.business_center},
    {"name": "Sell With Us", "icon": Icons.attach_money},
    {"name": "Newsletter", "icon": Icons.newspaper},
    {"name": "Pop-up Leasing", "icon": Icons.open_in_new},
    // {"name": "Account", "icon": Icons.account_circle}
  ];
  Login_Getx_Controller loginController = Get.put(Login_Getx_Controller());
  @override
  void initState() {
    controller = TabController(length: 1, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      key: sideMenuScaffoldKey,
      endDrawer: Drawer(
        backgroundColor: Colors.transparent,
        elevation: 0,
        width: media.width * 0.8,
        child: Obx(() =>

            // ?
            Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(media.width * 0.7),
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.black54, blurRadius: 15)
                    ]),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/avatar1.png")),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text_Data(
                          name: "${login_controller.memberData1.value!.sub}",
                          color: Colors.black,
                          size: 15,
                          maxLine: 1),
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          children: menuArr.map((mObj) {
                            var index = menuArr.indexOf(mObj);
                            return Container(
                              // margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 15),
                              decoration: selectMenu == index
                                  ? BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                          BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 10,
                                              offset: const Offset(0, 3))
                                        ])
                                  : null,
                              child: GestureDetector(
                                onTap: () {
                                  if (index == 0) {
                                    print("index = 0");
                                    Navigator.pop(context);
                                    sideMenuScaffoldKey.currentState
                                        ?.closeEndDrawer();
                                  } else if (index == 6) {
                                    print("index = 6");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const newLogin()));
                                    sideMenuScaffoldKey.currentState
                                        ?.closeEndDrawer();
                                  }
                                  setState(() {
                                    selectMenu = index;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      mObj["name"].toString(),
                                      style: TextStyle(
                                          color: selectMenu == index
                                              ? Colors.blue
                                              : Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Icon(
                                      mObj["icon"] as IconData? ?? Icons.home,
                                      color: selectMenu == index
                                          ? Colors.blue
                                          : Colors.black,
                                      size: 33,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList()),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.settings,
                                  color: Colors.black,
                                  size: 25,
                                )),
                            const SizedBox(
                              width: 15,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Terns",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Privacy",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ))),
      ),
      body: TabBarView(controller: controller, children: [
        HomePage(),
      ]),
      bottomNavigationBar: CustomNavigationBar(
        borderRadius: Radius.circular(30),
        iconSize: 20,
        selectedColor: Color.fromARGB(255, 5, 4, 5),
        strokeColor: Color(0x30040307),
        unSelectedColor: Colors.white,
        backgroundColor: Colors.blue,
        items: [
          CustomNavigationBarItem(
            icon: GestureDetector(onTap: () {}, child: Icon(Icons.home)),
            title: Text("Home"),
          ),
          CustomNavigationBarItem(
            icon: GestureDetector(
                onTap: () {
                  ariport_controller.getMenu();
                  LoadingUtils.show();

                
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FindByTicket()));
                    LoadingUtils.hide();
                  });
                },
                child:const Icon(Icons.airplanemode_active)),
            title: const Text("Buy ticket"),
          ),
          CustomNavigationBarItem(
            icon: GestureDetector(
                onTap: () {
                  LoadingUtils.show();

                  // Thực hiện điều hướng và ẩn overlay sau khi chuyển trang hoàn tất
                  Future.delayed(Duration(seconds: 2), () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: media.height * 0.5,
                            child: Search_hotel(
                              open_show: true,
                            ),
                          );
                        });
                    LoadingUtils.hide();
                  });
                },
                child: Icon(Icons.store)),
            title: Text("Book Hotel"),
          ),
          CustomNavigationBarItem(
            icon: GestureDetector(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => Find_By_Order()));
                },
                child: Icon(Icons.date_range)),
            title: Text(
              "Schedules",
              maxLines: 1,
            ),
          ),
          CustomNavigationBarItem(
            icon: GestureDetector(
                onTap: () {
                  // if (memberData != null) {
                },
                child: Icon(Icons.account_circle)),
            title: Text("Me"),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
