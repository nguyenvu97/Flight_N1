import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/Sevice_Api/Gex_Controller/Hotel_Getx_Controller.dart';
import 'package:flutter_application_4/model/hotel/Hotel.dart';


import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class List_Reviews extends StatefulWidget {
  Hotel hotel;
  List_Reviews({super.key, required this.hotel});

  @override
  State<List_Reviews> createState() => _List_ReviewsState();
}

final ScrollController _scrollController = ScrollController();
Hotel_Controller hotel_controller = Get.put(Hotel_Controller());
final FocusNode _focusNode = FocusNode();
final TextEditingController _controller = TextEditingController();

class _List_ReviewsState extends State<List_Reviews> {
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        hotel_controller
            .loadMoreReviews(widget.hotel.id); // Tải thêm khi cuộn đến cuối
      }
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        print('TextField is focused');
      } else {
        print('TextField lost focus');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(() {
        final reviewsResponse = hotel_controller.reviews;
        print(reviewsResponse);
        if (reviewsResponse == null) {
          return Center(child: Text('No data available'));
        }

        return CustomScrollView(slivers: [
          SliverPersistentHeader(
              delegate: _SliverPersistentHeaderDelegate(
                  child: Row(
            children: [
              Expanded(child: Container()),
              Expanded(
                flex: 2,
                child: Container(
                  child: Center(
                      child: Text_Data(
                          name: "Bình Luận (${widget.hotel.countReviews})",
                          color: Colors.black,
                          size: 25,
                          maxLine: 1)),
                ),
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              )),
            ],
          ))),
          SliverToBoxAdapter(
            child: Container(
              height: media.height * 0.5,
              width: media.width,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: widget.hotel.countReviews,
                  itemBuilder: (BuildContext context, int index) {
                    final revies = hotel_controller.reviews.elementAt(index);
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                height: 30,
                                width: 30,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Icon(Icons.person_3),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 30,
                                    margin: EdgeInsets.all(10),
                                    width: media.width * 0.8,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      children: [
                                        Text_Data(
                                          name: revies.email,
                                          color: Colors.black,
                                          size: 10,
                                          maxLine: 1,
                                        ),
                                        SizedBox(
                                          width: 15,
                                          child: Text("*"),
                                        ),
                                        Text_Data(
                                          name: revies.time.toString(),
                                          color: Colors.black,
                                          size: 15,
                                          maxLine: 1,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text_Data(
                                            name:
                                                "${revies.rating.toStringAsFixed(0)}⭐️",
                                            color: Colors.black,
                                            size: 15,
                                            maxLine: 1)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: media.width * 0.7,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text_Data(
                                        name: revies.comment,
                                        color: Colors.black,
                                        size: 20,
                                        maxLine: 1),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Icon(Icons.more_horiz),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
            ),
          )
        ]);
      }),
      // bottomNavigationBar: Container(
      //   height: media.height * 0.07,
      //   margin: EdgeInsets.symmetric(horizontal: 20),
      //   child: Row(
      //     children: [
      //       Expanded(
      //         child: TextField(
      //           focusNode: _focusNode,
      //           controller: _controller,
      //           maxLines: 1,
      //           decoration: InputDecoration(
      //             labelText: "Viết Bình luận",
      //             border: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(40),
      //               borderSide: BorderSide(color: Colors.black),
      //             ),
      //           ),
      //           style: TextStyle(
      //             color: Colors.black,
      //             fontWeight: FontWeight.bold,
      //             fontSize: 14, // Điều chỉnh kích thước chữ nếu cần
      //           ),
      //         ),
      //       ),
      //       SizedBox(width: 10), // Khoảng cách giữa TextField và IconButton
      //       IconButton(
      //         onPressed: () {
      //           showCupertinoDialog(
      //               context: context,
      //               builder: (BuildContext context) {
      //                 return Container(
      //                   height: 100,
      //                   width: 100,
      //                   color: Colors.amber,
      //                 );
      //               });
      //         },
      //         icon: Icon(Icons.send),
      //         color: Colors.blue, // Màu sắc của biểu tượng gửi
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverPersistentHeaderDelegate({required this.child});

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
