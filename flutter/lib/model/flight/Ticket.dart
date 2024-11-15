import 'package:flutter_application_4/model/hotel/CustomerDto.dart';

class TickitDto {
  final String id;
  final String orderNo;
  final String orderStatus;
  final String ticketTypeGo;
  final String? ticketTypeBack;
  final double totalTicket;
  final String ticketType;
  final List<CustomerDto> customers;
  final FlightTicketDto flightsGo;
  final FlightTicketDto? flightsBack;

  TickitDto({
    required this.id,
    required this.orderNo,
    required this.orderStatus,
    required this.ticketTypeGo,
    this.ticketTypeBack,
    required this.totalTicket,
    required this.ticketType,
    required this.customers,
    required this.flightsGo,
    this.flightsBack,
  });

  factory TickitDto.fromJson(Map<String, dynamic> json) {
    return TickitDto(
      id: json['id'],
      orderNo: json['orderNo'],
      orderStatus: json['orderStatus'],
      ticketTypeGo: json['ticketTypeGo'],
      ticketTypeBack: json['ticketTypeBack'],
      totalTicket: (json['totalTicket'] as num).toDouble(),
      ticketType: json['ticketType'],
      customers: (json['customers'] as List)
          .map((customer) => CustomerDto.fromJson(customer))
          .toList(),
      flightsGo: FlightTicketDto.fromJson(json['flights_go']),
      flightsBack: json['flights_back'] != null
          ? FlightTicketDto.fromJson(json['flights_back'])
          : null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderNo': orderNo,
      'orderStatus': orderStatus,
      'ticketTypeGo': ticketTypeGo,
      'ticketTypeBack': ticketTypeBack,
      'totalTicket': totalTicket,
      'ticketType': ticketType,
    };
  }
}
class FlightTicketDto {
  final int id;
  final String fromCity;
  final String toCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double basePrice;
  final String code;
  final List<FlightTicketDto>? flights;

  FlightTicketDto({
    required this.id,
    required this.fromCity,
    required this.toCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.basePrice,
    required this.code,
    this.flights,
  });

  // Phương thức chuyển đổi thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromCity': fromCity,
      'toCity': toCity,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'basePrice': basePrice,
      'code': code,
      'flights': flights?.map((flight) => flight.toJson()).toList(),
    };
  }

  factory FlightTicketDto.fromJson(Map<String, dynamic> json) {
    return FlightTicketDto(
      id: json['id'],
      fromCity: json['fromCity'],
      toCity: json['toCity'],
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
      basePrice: (json['basePrice'] as num).toDouble(),
      code: json['code'],
      flights: (json['flights'] as List<dynamic>?)
          ?.map((flight) => FlightTicketDto.fromJson(flight))
          .toList(),
    );
  }
}

