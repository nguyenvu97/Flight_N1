import 'package:flutter_application_4/model/hotel/CustomerDto.dart';

class BookingTickit {
  List<int> flightGo;
  List<int>? flightBack;
  List<CustomerDto> customers;
  bool ticketTypeGo;
  bool? ticketTypeBack;

  BookingTickit({
    required this.flightGo,
     this.flightBack,
    required this.customers,
    required this.ticketTypeGo,
     this.ticketTypeBack,
  });

  Map<String, dynamic> toJson() {
    return {
      'flight_go': flightGo,
      'flight_back': flightBack ?? [],
      'customers': customers.map((customer) => customer.toJson()).toList(), // Sử dụng toJson() cho CustomerDto
      'ticketTypeGo': ticketTypeGo,
      'ticketTypeBack': ticketTypeBack,
    };
  }
}
