import 'dart:convert';

class Flight {
  final int id;
  final String fromCity;
  final String toCity;
  final String departureTime;
  final String arrivalTime;
  final double basePrice;
  final int reservedSeats;
  final int reservedBusinessSeats;
  final int economySeats;
  final int businessSeats;
  final int totalSeats;
  final String airline;
  final String code;
  final List<Flight>? flights;
  final List<String>? seats;

  Flight({
    required this.id,
    required this.fromCity,
    required this.toCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.basePrice,
    required this.reservedSeats,
    required this.reservedBusinessSeats,
    required this.economySeats,
    required this.businessSeats,
    required this.totalSeats,
    required this.airline,
    required this.code,
    this.flights,
    this.seats
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fromCity": fromCity,
      "toCity": toCity,
      "departureTime": departureTime,
      "arrivalTime": arrivalTime,
      "basePrice": basePrice,
      "reservedSeats": reservedSeats,
      "reservedBusinessSeats": reservedBusinessSeats,
      "economySeats": economySeats,
      "businessSeats": businessSeats,
      "totalSeats": totalSeats,
      "airline": airline,
      'code':code,
      'seats': seats,
      "flights": flights?.map((flight) => flight.toMap()).toList(),

    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory Flight.fromJson(String json) {
    return Flight.fromMap(jsonDecode(json));
  }

  factory Flight.fromMap(Map<String, dynamic> map) {
    return Flight(
      id: map["id"],
      fromCity: map["fromCity"],
      toCity: map["toCity"],
      departureTime: map["departureTime"],
      arrivalTime: map["arrivalTime"],
      basePrice: map["basePrice"].toDouble(),
      reservedSeats: map["reservedSeats"],
      reservedBusinessSeats: map["reservedBusinessSeats"],
      economySeats: map["economySeats"],
      businessSeats: map["businessSeats"],
      totalSeats: map["totalSeats"],
      code: map['code'],
      airline: map["airline"],
      flights: map["flights"] != null
          ? List<Flight>.from(
              map["flights"].map((flight) => Flight.fromMap(flight)))
          : null,
          seats: map["seats"] != null ? List<String>.from(map["seats"]) : null,
    );
  }
}

class FlightResponse {
  final List<Flight>? flight_go;
  final List<Flight>? flight_back; // flight_back có thể là null

  FlightResponse({
    this.flight_go,
    this.flight_back, // không cần required
  });

  Map<String, dynamic> toMap() {
    return {
      'flight_go': flight_go?.map((flight) => flight.toMap()).toList(),
      'flight_back': flight_back?.map((flight) => flight.toMap()).toList(),
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory FlightResponse.fromJson(String json) {
    return FlightResponse.fromMap(jsonDecode(json));
  }

  factory FlightResponse.fromMap(Map<String, dynamic> map) {
    return FlightResponse(
      flight_go: List<Flight>.from(
        map['flight_go']?.map((flight) => Flight.fromMap(flight)) ?? [],
      ),
      flight_back: map['flight_back'] != null
          ? List<Flight>.from(
              map['flight_back']?.map((flight) => Flight.fromMap(flight)) ?? [],
            )
          : null,
    );
  }
}
