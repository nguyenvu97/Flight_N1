import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Customer_Ticket {
  String? email;
  String? phone;
  String full_name;
  String customer_title;
  String birth_of_day;
  String customType;
  RxInt? badge_go;
  RxInt? badge_back;
  RxString? flight_go_seats;
  RxString? flight_back_seats;

  Customer_Ticket({
    required this.birth_of_day,
    required this.customer_title,
    this.email,
    this.badge_go,
    this.badge_back,
    required this.full_name,
    required this.phone,
    required this.customType,
    this.flight_back_seats,
    this.flight_go_seats,
  }) {
    badge_go = 0.obs;
    badge_back = 0.obs;
    flight_go_seats = ''.obs;
    flight_back_seats = ''.obs;
  }
  @override
  String toString() {
    return 'Customer_Ticket{email: $email, phone: $phone, full_name: $full_name, customer_title: $customer_title, birth_of_day: $birth_of_day, badge_go: $badge_go, badge_back: $badge_back, flight_go_seats: ${flight_go_seats!.value}, flight_back_seats: ${flight_back_seats!.value}}';
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'full_name': full_name,
      'customer_title': customer_title,
      'birth_of_day': birth_of_day,
      'customType': customType,
      'badge_go': badge_go?.value ,
      'badge_back': badge_back?.value,
      'flight_go_seats': flight_go_seats?.value,
      'flight_back_seats': flight_back_seats?.value,
    };
  }
  factory Customer_Ticket.fromJson(Map<String, dynamic> json) {
    return Customer_Ticket(
      email: json['email'],
      phone: json['phone'],
      full_name: json['full_name'],
      customer_title: json['customer_title'],
      birth_of_day: json['birth_of_day'],
      customType: json['customType'],
      badge_go: json['badge_go'] != null ? json['badge_go'] : 0,
      badge_back: json['badge_back'] != null ? json['badge_back'] : 0,
      flight_go_seats: json['flight_go_seats'] != null ? json['flight_go_seats'] : '',
      flight_back_seats: json['flight_back_seats'] != null ? json['flight_back_seats'] : '',
    );
  }
}
