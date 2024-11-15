import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/Icon_And_Text.dart';
import 'package:flutter_application_4/common/Not_Found.dart';
import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/hotel/List_Reviews.dart';
import 'package:flutter_application_4/hotel/Order_hotel.dart';
import 'package:flutter_application_4/Login/new_login.dart';
import 'package:flutter_application_4/Sevice_Api/Gex_Controller/Hotel_Getx_Controller.dart';
import 'package:flutter_application_4/Sevice_Api/Gex_Controller/Login_Get_Controller.dart';
import 'package:flutter_application_4/model/hotel/Hotel.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Hotel_Details extends StatefulWidget {
  Hotel hotel;
  Hotel_Details({super.key, required this.hotel});

  @override
  State<Hotel_Details> createState() => _Hotel_DetailsState();
}

Hotel_Controller hotel_controller = Get.put(Hotel_Controller());

Login_Getx_Controller login_controller = Get.put(Login_Getx_Controller());

class _Hotel_DetailsState extends State<Hotel_Details> {
  void initState() {
    hotel_controller.loadMoreReviews(widget.hotel.id);
    super.initState();
  }

  Show_Dia_log showController = Get.put(Show_Dia_log());

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 2,
              expandedHeight: 300.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Swiper(
                  itemCount: widget.hotel.image.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Hero(
                      tag: widget.hotel.id,
                      child: SizedBox(
                        child: Transform.scale(
                          scale: 1,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(40)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "http://localhost:1002/api/v1/hotel/upload?imgName=${widget.hotel.image[index].img}"),
                                      fit: BoxFit.cover))),
                        ),
                      ),
                    );
                  },
                  pagination: SwiperPagination(),
                ),
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    margin: EdgeInsetsDirectional.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white54),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    )),
              ),
              actions: [
                Container(
                  margin: EdgeInsetsDirectional.symmetric(
                      horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.white54),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: media.height * 0.03,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            widget.hotel.hotelName,
                            style: GoogleFonts.headlandOne(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.hotel.price.toString(),
                              style: GoogleFonts.headlandOne(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: media.height * 0.02,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "2 người 1 phòng 1 gường",
                            style: GoogleFonts.headlandOne(
                                color: Colors.grey[800],
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.hotel.category,
                              style: GoogleFonts.headlandOne(
                                  color: Colors.grey[800],
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //! reviews
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          isDismissible: false,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: media.height * 0.6,
                              child: List_Reviews(
                                hotel: widget.hotel,
                              ),
                            );
                          });
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      width: media.width * 0.8,
                      height: media.height * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 249, 239, 239)),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text_Data(
                                      name:
                                          "${widget.hotel.stars.toStringAsFixed(1)}⭐️",
                                      color: Colors.black,
                                      size: 20,
                                      maxLine: 1),
                                ),
                                Container(
                                  child: Text_Data(
                                      name:
                                          "(${widget.hotel.countReviews}Reviews)",
                                      color: Colors.black,
                                      size: 15,
                                      maxLine: 1),
                                ),
                                Container(
                                  child: Icon(
                                    Icons.message_outlined,
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: media.height * 0.05,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text_Data(
                                name: "Đánh Giá Và Cho Bình Luận",
                                color: Colors.black,
                                size: 16,
                                maxLine: 1),
                          ],
                        ),
                      ),
                      RatingBar.builder(
                        initialRating: login_controller.token.value.isEmpty
                            ? 0
                            : hotel_controller.rating.value,
                        minRating: 1,
                        itemSize: 50,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          if (login_controller.token.value.isEmpty) {
                            showController.confirm_Dialog(context,
                                "Mục Này Bạn Phải Đang nhập", newLogin());
                          } else {
                            setState(() {
                              hotel_controller.rating.value = rating;
                            });

                            // setState(() {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    height: media.height * 0.4,
                                    width: media.width,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          height: media.height * 0.1,
                                          child: Row(
                                            children: [
                                              Icon_And_Text(
                                                  icon: Icons.person_2,
                                                  size: 20,
                                                  name:
                                                      "${loginController.memberData1.value!.aliases} .${loginController.memberData1.value!.sub}",
                                                  color: Colors.blue,
                                                  iconColor: Colors.black)
                                            ],
                                          ),
                                        ),
                                        RatingBar.builder(
                                            initialRating:
                                                hotel_controller.rating.value,
                                            minRating: 1,
                                            itemSize: 50,
                                            itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                            onRatingUpdate: (rating) {
                                              setState(() {
                                                hotel_controller.rating.value =
                                                    rating;
                                              });
                                            }),
                                        Container(
                                          height: media.height * 0.1,
                                          padding: EdgeInsets.all(10),
                                          child: TextField(
                                            controller: hotel_controller
                                                .reviewsController,
                                            maxLines: 4,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: "Bình Luận",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            style: GoogleFonts.headlandOne(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            if (hotel_controller
                                                        .reviewsController
                                                        .text ==
                                                    '' &&
                                                hotel_controller
                                                    .reviewsController
                                                    .text
                                                    .isEmpty) {
                                              Future.delayed(
                                                  Duration(milliseconds: 300),
                                                  () {
                                                showController
                                                    .showSuccessDialog(
                                                        context,
                                                        "Thông Báo",
                                                        "Đăng Bài Thất Bại",
                                                        false,
                                                        null);
                                              });
                                            } else {
                                              if (hotel_controller.kq.isFalse) {
                                                showController.showSuccessDialog(
                                                    context,
                                                    "Thông Báo",
                                                    "Đăng Bài Thành Công \n Cảm Ơn Quý Khách",
                                                    false,
                                                    null);
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: media.height * 0.05,
                                            width: media.width * 0.8,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon_And_Text(
                                                      icon: Icons.send,
                                                      size: 15,
                                                      name: "Đăng",
                                                      color: Colors.white,
                                                      iconColor: Colors.white),
                                                ]),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                            hotel_controller.rating.value = rating;
                            // });
                          }
                        },
                      )
                    ],
                  ),

                  // ! ! hotel titleHotel
                  Column(
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text_Data(
                                  name: "Thông Tin Khách Sạn",
                                  color: Colors.black,
                                  size: 16,
                                  maxLine: 1),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Colors.blue,
                                  ))
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_sharp,
                            color: Colors.blue,
                          ),
                          Text_Data(
                              name: widget.hotel.hotelAddress,
                              color: Colors.black,
                              size: 15,
                              maxLine: 1),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(widget.hotel.titleHotel as String),
                      )
                    ],
                  ),

                  //!!!  Các tiện nghi
                  Column(
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text_Data(
                                  name: "Các tiện nghi ",
                                  color: Colors.black,
                                  size: 16,
                                  maxLine: 1),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Colors.blue,
                                  ))
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
                child: Container(
                    height: media.height *
                        0.08, // Chiều cao của container chứa grid ngang
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hotel_controller.gridItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> item =
                            hotel_controller.gridItems[index];
                        return Container(
                            margin: EdgeInsets.all(4.0),
                            child: Icon_And_Text(
                              color: Colors.black,
                              icon: item['icon'],
                              size: 10,
                              name: item['text'],
                              iconColor: Colors.green,
                            ));
                      },
                    )))
          ],
        ),
      ),

      //! book king table
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Order_Hotel(
                        hotel: widget.hotel,
                      )));
        },
        child: Container(
          height: media.height * 0.08,
          width: media.width * 0.8,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.blue),
            child: Container(
              child: Center(
                  child: Text_Data(
                      name: "Đăt Khách Sạn",
                      color: Colors.black,
                      size: 20,
                      maxLine: 1)),
            ),
          ),
        ),
      ),
    );
  }
}
