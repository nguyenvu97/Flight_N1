import 'package:intl/intl.dart';

enum BookingStatus { PENDING, CONFIRMED, CANCELLED, COMPLETED }

class Booking {
  String checkInDate;
  String checkOutDate;
  int numberPeople;
  int numberRoom;
  double totalPrice;
  int quantityRom; // Có thể là 'quantityRoom' nếu có lỗi chính tả
  String userName;
  String email;
  String phoneNumber;
  int roomId;
  BookingStatus bookingStatus;
  int hotelId;
  String roomCategory;
  String hotelName;

  Booking({
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberPeople,
    required this.numberRoom,
    required this.totalPrice,
    required this.quantityRom, // Hoặc 'quantityRoom'
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.roomId,
    required this.bookingStatus,
    required this.hotelId,
    required this.roomCategory,
    required this.hotelName,
  });

  @override
  String toString() {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return 'Booking('
        'checkInDate: $checkInDate '
        'checkOutDate: $checkOutDate '
        'numberPeople: $numberPeople, '
        'numberRoom: $numberRoom, '
        'totalPrice: $totalPrice, '
        'quantityRom: $quantityRom, '
        'userName: $userName, '
        'email: $email, '
        'phoneNumber: $phoneNumber, '
        'roomId: $roomId, '
        'bookingStatus: $bookingStatus, '
        'hotelId: $hotelId, '
        'roomCategory: $roomCategory, '
        'hotelName: $hotelName'
        ')';
  }
}
