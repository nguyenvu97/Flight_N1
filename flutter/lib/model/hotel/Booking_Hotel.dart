import 'dart:convert';



class Booking_Hotel {
  int? id;
  String? orderNo;
  DateTime? bookingDate;
  String checkInDate;
  String checkOutDate;
  int numberPeople;
  double totalPrice;
  int quantityRoom;
  String userName;
  String email;
  String phoneNumber;
  int? roomId;
  String? bookingStatus;
  int hotelId;
  String roomCategory;
  String hotelName;
  int stayNight;
  Booking_Hotel(
      {this.id,
      this.orderNo,
      this.bookingDate,
      this.roomId,
      this.bookingStatus,
      required this.hotelId,
      required this.checkInDate,
      required this.checkOutDate,
      required this.numberPeople,
      required this.totalPrice,
      required this.quantityRoom,
      required this.userName,
      required this.email,
      required this.phoneNumber,
      required this.roomCategory,
      required this.hotelName,
      required this.stayNight});
  factory Booking_Hotel.fromMap(Map<String, dynamic> map) {
    return Booking_Hotel(
        id: map['id'] as int?,
        orderNo: map['orderNo'] as String?,
        bookingDate: map['bookingDate'] != null
            ? DateTime.parse(map['bookingDate'])
            : null,
        checkInDate: map['checkInDate'] as String,
        checkOutDate: map['checkOutDate'] as String,
        numberPeople: map['numberPeople'] as int,
        totalPrice: map['totalPrice'] as double,
        quantityRoom: map['quantityRoom'] as int,
        userName: map['userName'] as String,
        email: map['email'] as String,
        phoneNumber: map['phoneNumber'] as String,
        roomId: map['roomId'] as int?,
        bookingStatus: map['bookingStatus']
            as String, // Điều chỉnh theo kiểu của BookingStatus
        hotelId: map['hotelId'] as int,
        roomCategory: map['roomCategory'] as String,
        hotelName: map['hotelName'] as String,
        stayNight: map['stayNight'] as int);
  }

  // Convert the instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderNo': orderNo,
      'bookingDate': bookingDate?.toIso8601String(),
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'numberPeople': numberPeople,

      'totalPrice': totalPrice,
      'quantityRoom': quantityRoom,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'roomId': roomId,
      'bookingStatus': bookingStatus, // Điều chỉnh theo kiểu của BookingStatus
      'hotelId': hotelId,
      'roomCategory': roomCategory,
      'hotelName': hotelName,
      'stayNight': stayNight
    };
  }

  // Convert the instance to a JSON string
  String toJson() {
    final map = toMap();
    return jsonEncode(map);
  }

  // Create an instance from a JSON string
  factory Booking_Hotel.fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return Booking_Hotel.fromMap(map);
  }
}
