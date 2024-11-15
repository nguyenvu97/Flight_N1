import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_4/common/Box_Container/New_Box.dart';
import 'package:flutter_application_4/common/Box_Container/Top_Picks_Call.dart';
import 'package:flutter_application_4/common/CustomerSearchView.dart';
import 'package:flutter_application_4/common/LoadingUtils.dart';
import 'package:flutter_application_4/common/On_Long_Press.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/hotel/Hotel_HomePage.dart';
import 'package:flutter_application_4/hotel/Search_hotel.dart';
import 'package:flutter_application_4/login/New_login.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Login_Get_Controller.dart';
import 'package:flutter_application_4/ticket/findby_ticket/Find_By_Ticket.dart';
import 'package:flutter_application_4/home/Menu_Main_Home.dart';

import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int _currentIndex = 0;

// ScrollController? controller;

List topPicksArr = [
  {"img": "assets/banner1.jpg"},
  {"img": "assets/banner2.png"},
  {"img": "assets/banner3.png"}
];

List Top3AdressHot = [
  {"img": "assets/tokyo.jpg", "text": "Tokyo Thủ Dô Của Hiện Đại"},
  {"img": "assets/phuquoc.jpg", "text": "Phú Quốc - Hòn Ngọc Quý"},
  {"img": "assets/dalac.jpg", "text": "Đà Lạc - Môt Paris Thu Nhỏ"}
];
List<Map<String, dynamic>> gridItems = [
  {
    'text': 'Khách Sạn',
    'imagePath': 'assets/khachsan.jpeg',
  },
  {
    'text': 'Hành Lý Ký Gửi',
    'imagePath': 'assets/hanhly3.jpeg',
    "Data": "Mua Vé Online"
  },
  {
    'text': 'Chọn Chỗ Ngồi',
    'imagePath': 'assets/shit.jpeg',
    "Data": "Mua Vé Online"
  },
  {
    'text': 'Phòng Chờ Thương Gia',
    'imagePath': 'assets/phongcho.png',
    "Data": "Mua Vé Online"
  },
  {'text': 'Quà tặng', 'imagePath': 'assets/gif.jpeg', "Data": "Mua Vé Online"},
  {'text': 'Đặt Xe', 'imagePath': 'assets/texi1.jpeg', "Data": "Mua Vé Online"},
];

class _HomePageState extends State<HomePage> {
  Login_Getx_Controller loginController = Get.put(Login_Getx_Controller());
  final LabeledGlobalKey<ScaffoldState> sideMenuScaffoldKey =
      LabeledGlobalKey<ScaffoldState>('sideMenuScaffoldMainTab');
  @override
  void initState() {
    super.initState();
  }

  double _height = 100.0;
  double _wight = 100.0;
  bool _hasUpdated = false;

  void _updateSize() {
    setState(() {
      if (!_hasUpdated) {
        // Kiểm tra xem đã cập nhật chưa
        _wight += 50.0;
        _height += 50.0;
        _hasUpdated = true; // Đánh dấu rằng kích thước đã được cập nhật
      }
    });
  }

  int? expandedIndex;

  void toggleSize(int index) {
    setState(() {
      expandedIndex = index;
    });
  }

  void onLongPressEnd() {
    setState(() {
      expandedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 80,
              backgroundColor: Colors.blue,
              // pinned: true,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    child: ClipRRect(
                      child: Image.asset(
                        'assets/Logo2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              leading: Container(),
              leadingWidth: 0,
              actions: [
                Container(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: CustomerSearchView(),
                          );
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      // neu chua login no ma person login roi no na menu
                      IconButton(
                          onPressed: () {
                            if (loginController.memberData1.value == null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => newLogin()));
                            } else {
                              sideMenuScaffoldKey.currentState?.openEndDrawer();
                            }
                          },
                          icon: loginController.memberData1.value == null
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.more_horiz_sharp,
                                  color: Colors.white,
                                ))
                    ],
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: media.width,
                    height: media.width * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text_Data(
                                name: "Xin Chào",
                                color: Colors.black,
                                size: 20,
                                maxLine: 1)),
                        Visibility(
                          visible: loginController.memberData1.value != null,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              loginController.memberData1.value != null
                                  ? "${loginController.memberData1.value!.aliases} .${loginController.memberData1.value!.sub} "
                                  : "",
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    width: media.width,
                    height: media.height * 0.3,
                    child: CarouselSlider.builder(
                      itemCount: topPicksArr.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) {
                        var iObj = topPicksArr[itemIndex] as Map? ?? {};
                        return TopPicksCell(
                          iObj: iObj,
                        );
                      },
                      options: CarouselOptions(
                        autoPlayInterval: Duration(seconds: 20),
                        aspectRatio: 1,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        enlargeFactor: 0.4,
                        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Box("KHÁM PHÁ ĐIỂM ĐẾN"),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Số lượng cột
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 30),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var iObj = Top3AdressHot[index] as Map? ?? {};
                  bool isExpanded = expandedIndex == index;
                  return On_Long_Press(
                    onLongPressEnd: onLongPressEnd,
                    toggleSize: toggleSize,
                    isExpanded: isExpanded,
                    iObj: iObj,
                    index: index,
                  );
                },
                childCount: topPicksArr.length,
              ),
            ),
            Box("ĐỂ CHUYẾN ĐI TRỌN VẸN HƠN"),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Số lượng cột
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // Lấy thông tin cho ô hiện tại từ danh sách gridItems
                  Map<String, dynamic> item = gridItems[index];
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        LoadingUtils.show();
                        // Thực hiện điều hướng và ẩn overlay sau khi chuyển trang hoàn tất
                        Future.delayed(Duration(seconds: 2), () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: media.height * 0.5,
                                  child: Search_hotel(
                                    open_show: true,
                                  ),
                                );
                              });
                          LoadingUtils.hide();
                        });
                      }
                    },
                    child: Container(
                      height: media.height * 0.20,
                      width: media.width * 0.4,
                      margin: const EdgeInsets.all(10),
                      child: NewBox(
                        child: Column(
                          children: [
                            SizedBox(
                                child: Text_Data(
                                    name: item['text'],
                                    color: Colors.blue,
                                    size: 15,
                                    maxLine: 1)),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: media.height * 0.16,
                              width: media.width * 0.8,
                              child: Image.asset(
                                item['imagePath'],
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: gridItems.length, // Số lượng mục trong danh sách
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 100,
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter Box(String text) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Container(
              height: 50,
              padding: EdgeInsets.only(left: 20),
              child: Text_Data(
                  name: text, color: Colors.black, size: 20, maxLine: 1)),
        ],
      ),
    );
  }
}
