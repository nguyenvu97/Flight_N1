import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/Box_Container/New_Box.dart';
import 'package:flutter_application_4/common/LoadingUtils.dart';
import 'package:flutter_application_4/common/Not_Found.dart';
import 'package:flutter_application_4/hotel/Filter_Hotel.dart';
import 'package:flutter_application_4/hotel/Hotel_Details.dart';
import 'package:flutter_application_4/hotel/Search_hotel.dart';
import 'package:flutter_application_4/Sevice_Api/Gex_Controller/Hotel_Getx_Controller.dart';
import 'package:flutter_application_4/model/hotel/Hotel.dart';


import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';

class Hotel_HomePage extends StatefulWidget {
  const Hotel_HomePage({super.key});

  @override
  State<Hotel_HomePage> createState() => _Hotel_HomePageState();
}

Hotel_Controller hotel_controller = Get.put(Hotel_Controller());

class _Hotel_HomePageState extends State<Hotel_HomePage> {
  final ScrollController _scrollController = ScrollController();

  void initState() {
    hotel_controller.loadMoreHotels(); // Tải dữ liệu khi bắt đầu
    checkData();
    _scrollController.addListener(() {
      // Kiểm tra khi cuộn đến gần cuối danh sách
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        hotel_controller.loadMoreHotels(); // Tải thêm khi cuộn đến cuối
      }
    });
    super.initState();
  }

  void checkData() async {
    List<Hotel> data = await hotel_controller.dataTest();

    if (data == null || data.isEmpty) {
      LoadingUtils.show();

      await Future.delayed(Duration(seconds: 4));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Not_Found()),
      );

      LoadingUtils.hide();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          height: 30,
          width: 30,
          child: IconButton(
              onPressed: () {
                hotel_controller.resetPageNumber();
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        title: Center(
          child: Text(
            "Khách Sạn",
            style: GoogleFonts.headlandOne(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: media.height * 0.5,
                      child: Search_hotel(
                        open_show: false,
                      ),
                    );
                  });
            },
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Obx(() {
        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
              delegate: _SortFilterHeaderDelegate(
                child: Container(
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            _showSortOptions(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sort),
                              Text(
                                "Sort",
                                style: GoogleFonts.headlandOne(
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            // _showFilterOptions(context);
                            showModalBottomSheet(
                                isDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: media.height * 0.8,
                                    child: Filter_Hotel(
                                      max_money: hotel_controller.maxMoney,
                                      min_money: hotel_controller.minMoney,
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.filter_alt),
                              Text(
                                "Filter",
                                style: GoogleFonts.headlandOne(
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pinned: true,
            ),
            text_data("Danh Sách Khách Sạn"),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final hotel = hotel_controller.hotels.elementAt(index);

                  return Container(
                    height: 150,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Hotel_Details(hotel: hotel),
                          ),
                        );
                      },
                      child: NewBox(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Swiper(
                                itemCount: hotel.image.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Hero(
                                    tag: hotel.id,
                                    child: Container(
                                      margin: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "http://localhost:1002/api/v1/hotel/upload?imgName=${hotel.image[index].img}"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                control: SwiperControl(color: Colors.white),
                                pagination: SwiperPagination(),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      hotel.hotelName,
                                      style: GoogleFonts.headlandOne(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      hotel.hotelAddress,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.headlandOne(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "${hotel.stars.toStringAsFixed(1)} ⭐️ (${hotel.countReviews}) Reviews",
                                      style: GoogleFonts.headlandOne(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      hotel.price.toString(),
                                      style: GoogleFonts.headlandOne(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          child: Text(
                                            "SL Phòng",
                                            maxLines: 1,
                                            style: GoogleFonts.headlandOne(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  width: 1, color: Colors.red)),
                                          child: Center(
                                            child: Text(
                                              hotel.count.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.headlandOne(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: hotel_controller.hotels.length,
              ),
            )
          ],
        );
      }),
    );
  }

  SliverToBoxAdapter text_data(String name) {
    return SliverToBoxAdapter(
      child: Container(
        height: 25,
        margin: EdgeInsets.all(20),
        child: Text(
          name,
          style: GoogleFonts.headlandOne(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Center(child: Text('Filter Options')),
        );
      },
    );
  }

  // Show Sort by
  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
            itemCount: hotel_controller.sortOptions.length,
            itemBuilder: (BuildContext context, int index) {
              final optionKey =
                  hotel_controller.sortOptions.keys.elementAt(index);
              final optionValue = hotel_controller.sortOptions[optionKey]!;

              return Obx(
                () => ListTile(
                  title: Container(
                    margin: EdgeInsets.all(8),
                    height: 50,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 0.5, color: Colors.black),
                      color:
                          hotel_controller.selectedSortOption.value == optionKey
                              ? Colors.blue[100] // Màu nền khi mục được chọn
                              : Colors.white,
                    ),
                    child: Center(child: Text(optionValue)),
                  ),
                  onTap: () async {
                    if (hotel_controller.selectedSortOption.value !=
                        optionKey) {
                      hotel_controller.resetData();

                      LoadingUtils.show();

                      hotel_controller.selectedSortOption.value = optionKey;
                      hotel_controller.loadMoreHotels();

                      LoadingUtils.hide();

                      Navigator.pop(context);
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SortFilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SortFilterHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
