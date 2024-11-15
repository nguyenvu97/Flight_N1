import 'dart:convert';

import 'package:flutter/material.dart';

class HotelResponse {
  final int pageSize;
  final int pageNumber;
  final List<Hotel> content;
  final int totalElements;
  final int number;
  final int numberOfElements;
  final int totalPages;

  HotelResponse({
    required this.pageSize,
    required this.pageNumber,
    required this.content,
    required this.totalElements,
    required this.number,
    required this.numberOfElements,
    required this.totalPages,
  });

  factory HotelResponse.fromJson(Map<String, dynamic> json) {
    return HotelResponse(
      pageSize: json['pageSize'],
      pageNumber: json['pageNumber'],
      content:
          List<Hotel>.from(json['content'].map((item) => Hotel.fromJson(item))),
      totalElements: json['totalElements'],
      number: json['number'],
      numberOfElements: json['numberOfElements'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageSize': pageSize,
      'pageNumber': pageNumber,
      'content': List<dynamic>.from(content.map((item) => item.toJson())),
      'totalElements': totalElements,
      'number': number,
      'numberOfElements': numberOfElements,
      'totalPages': totalPages,
    };
  }
}

// Lớp cho đối tượng khách sạn
class Hotel {
  final int id;
  final String hotelName;
  final String hotelAddress;
  final String titleHotel;
  final String phoneNumber;
  final double stars;
  final int countReviews;
  final String website;
  final List<Image> image;
  final int count;
  final double price;
  final String category;
  final int roomId;

  Hotel(
      {required this.id,
      required this.hotelName,
      required this.hotelAddress,
      required this.titleHotel,
      required this.phoneNumber,
      required this.stars,
      required this.countReviews,
      required this.website,
      required this.image,
      required this.count,
      required this.price,
      required this.category,
      required this.roomId});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
        id: json['id'],
        hotelName: json['hotelName'],
        hotelAddress: json['hotelAddress'],
        titleHotel: json['titleHotel'],
        phoneNumber: json['phoneNumber'],
        stars: json['stars'].toDouble(),
        countReviews: json['countReviews'],
        website: json['website'],
        image:
            List<Image>.from(json['image'].map((item) => Image.fromJson(item))),
        count: json['count'],
        price: json['price'].toDouble(),
        category: json['category'],
        roomId: json['roomId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelName': hotelName,
      'hotelAddress': hotelAddress,
      'titleHotel': titleHotel,
      'phoneNumber': phoneNumber,
      'stars': stars,
      'countReviews': countReviews,
      'website': website,
      'image': List<dynamic>.from(image.map((item) => item.toJson())),
      'count': count,
      'price': price,
      'category': category,
      'roomId': roomId
    };
  }
}

// Lớp cho đối tượng hình ảnh
class Image {
  final int id;
  final String img;
  final String pathImg;

  Image({
    required this.id,
    required this.img,
    required this.pathImg,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'],
      img: json['img'],
      pathImg: json['pathImg'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img': img,
      'pathImg': pathImg,
    };
  }
}
