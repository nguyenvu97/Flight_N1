import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/App_Colors.dart';
import 'package:flutter_application_4/model/flight/BookingDto.dart';
import 'package:flutter_application_4/model/flight/Customer_Ticket.dart';
import 'package:flutter_application_4/model/flight/FlightResponse.dart';
import 'package:flutter_application_4/model/flight/SearchFlight.dart';
import 'package:flutter_application_4/model/flight/Ticket.dart';
import 'package:flutter_application_4/model/hotel/CustomerDto.dart';

import 'package:flutter_application_4/sevice_api/Airport_Service.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ariport_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/Ticket_Service.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Ticket_Getx_Controller extends GetxController {
  /**
   *  find_by_ticket
   * 
   */
  RxList<String> airpost1 = <String>[].obs;

  var selectFindBy = "Round_trip".obs;
  final Map<int, String> userType = {
    0: "Trẻ Em",
    1: "Người Lớn",
  }.obs;
  var isChecked = false.obs;
  var customer = 1.obs;
  var children = 0.obs;
  var isSelectFindBy = true.obs;

  Rx<DateTime?> timeGo = Rx<DateTime?>(null);
  Rx<DateTime?> timeCallBack = Rx<DateTime?>(null);
  var dateTime = DateTime.now().obs;
  var notification = "Notification".obs;

  void updateUserType(int key) {
    if (key == 1) {
      customer++;
      return;
    } else {
      children += 1;
      return;
    }
  }

  //! sreach list Datetime for herder

  void removeUserType(int key, BuildContext context) {
    if (key == 1) {
      customer--;
      if (customer < 1) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(notification.value),
            content: Text('The number of customers is less than zero'),
          ),
        );
        customer = customer + 1;
        return;
      }
    } else {
      children--;
      return;
    }
  }

  bool? CheckAddress(String start, String end, BuildContext context) {
    if (start.contains(end)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(notification.value),
          content: Text(
              'The origin address and destination address cannot be the same. Please select again.'),
        ),
      );
      return null;
    } else {
      return true;
    }
  }

  DateTime checkTime(BuildContext context) {
    if (timeGo.value != null && timeCallBack.value != null) {
      if (timeGo.value!.isAfter(timeCallBack.value!)) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(notification.value),
            content: Text(
                'The return date cannot be before the departure date. Please select again.'),
          ),
        );
        throw Exception("loi me roi");
      }
    }
    return timeCallBack.value!;
  }

  void onCheckboxChanged(bool? value) {
    isChecked.value =
        value ?? true; // Update the state when checkbox value changes
  }

  //!

  // !

  //  import service here

  TicKet_Service ticKet_Service = TicKet_Service();

  Ariport_Controller ariport_controller = Get.put(Ariport_Controller());

  //!

  var flight_response = FlightResponse().obs;

  var number = 1.obs;

  var ticket = 'Phổ Thông'.obs;
  var ticKetVip = "Thương gia".obs;
  var error = true.obs;

  Future<FlightResponse?> flightData() async {
    String startTimeData =
        DateFormat("yyyy-MM-dd").format(timeGo.value ?? DateTime.now());
    String? endTimeData = isSelectFindBy.value
        ? DateFormat("yyyy-MM-dd").format(timeCallBack.value!)
        : null;

    number.value =
        isSelectFindBy.value ? 2 : 1; // Set number based on the selection

    SearchFlight searchFlight = SearchFlight(
      startDate: startTimeData,
      endDate: endTimeData,
      departure: ariport_controller.startCountry.value,
      arrival: ariport_controller.endCountry.value,
    );

    var response = await ticKet_Service.getFlight(number.value, searchFlight);
    if (response != null) {
      flight_response.value = response;
      error.value = true;
      return flight_response.value;
    } else {
      error.value = false;
      return null; // Explicitly return null in case of error
    }
  }

  // ! One way Import Here
  var isSelectTicketOneWay = true.obs;

  var flightGo = Rx<Flight?>(null);
  var flightBack = Rx<Flight?>(null);

  //! RouteTrip Import Here

  var isSelectbusiness = true.obs;
  var isRouterGoAndBack = true.obs;

  //! choose wieght
  var activeStep = 0.obs;

  //! input data customer

  var data_title_adult = ["Ông", "Bà", "Cô/Chị"].obs;
  var data_title_child = ["Trẻ em trai", "Trẻ em gái"].obs;

  var email = ''.obs;
  var fullName = ''.obs;
  var phone = ''.obs;
  var birthOfDay = ''.obs;
  var customer_title = ''.obs;

  var customer_input = <Customer_Ticket>[].obs;

  void removeData() {
    fullName.value = '';
    birthOfDay.value = '';
    customer_title.value = '';
  }

  //! seats and bag

  var badges = <Map<int, List<Customer_Ticket>>>[].obs;

  var moneybadge = 500000.00.obs;
  var sum_badge_go = 0.0.obs;
  var sum_badge_back = 0.0.obs;
  var number_go = 0.obs;
  var number_back = 0.obs;

  void sumMoneyBadge(int i) {
    number_go.value = 0;
    number_back.value = 0;
    switch (i) {
      case 1:
        customer_input.forEach((data) {
          number_go.value += data.badge_go?.value ?? 0; // Kiểm tra null
        });
        sum_badge_go.value =
            number_go.value * moneybadge.value; // Cập nhật giá trị

      case 2:
        customer_input.forEach((data) {
          number_back.value += data.badge_back?.value ?? 0; // Kiểm tra null
        });

        sum_badge_back.value = number_back.value * moneybadge.value;
    }
  }

  String formatCurrency(double amount) {
    if (isRouterGoAndBack.value) {
      amount = isSelectTicketOneWay.value
          ? amount * AppColors.Economy_Money
          : amount * 2;
    } else {
      amount = isSelectbusiness.value
          ? amount * AppColors.Economy_Money
          : amount * 2;
    }
    final formatCurrency = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
    );
    return formatCurrency.format(amount);
  }

  var sum_ticket_badge = 0.0.obs;

  void update_sum_ticket_badge() {
    sum_ticket_badge.value = (sum_badge_go.value + sum_badge_back.value);
  }

  double? sum_Anything_Ticket() {
    if (isSelectFindBy.value) {
      sum_ticket_badge.value = 0;
      var flight_go_money =
          flightGo.value!.flights == null && flightGo.value!.flights == null
              ? isSelectTicketOneWay.value
                  ? flightGo.value!.basePrice * 1.5
                  : flightGo.value!.basePrice * 2
              : isSelectTicketOneWay.value
                  ? (flightGo.value!.basePrice +
                          flightGo.value!.flights!.first.basePrice) *
                      1.5
                  : (flightGo.value!.basePrice +
                          flightGo.value!.flights!.first.basePrice) *
                      2;
      var flight_back_money =
          flightBack.value!.flights == null && flightBack.value!.flights == null
              ? isSelectbusiness.value
                  ? flightBack.value!.basePrice * 1.5
                  : flightBack.value!.basePrice * 2
              : isSelectbusiness.value
                  ? (flightBack.value!.basePrice +
                          flightBack.value!.flights!.first.basePrice) *
                      1.5
                  : (flightBack.value!.basePrice +
                          flightBack.value!.flights!.first.basePrice) *
                      2;
      sum_ticket_badge.value = (flight_back_money + flight_go_money) *
          (customer.value + children.value - (children.value * 0.25));
      return sum_ticket_badge.value;
    } else {
      sum_ticket_badge.value = 0;
      if (isSelectTicketOneWay.value) {
        var flight_go_money = flightGo.value!.flights == null
            ? flightGo.value!.basePrice
            : (flightGo.value!.basePrice +
                flightGo.value!.flights!.first.basePrice);
        return sum_ticket_badge.value = (flight_go_money * 1.5) *
            (customer.value + children.value - (children.value * 0.25));
      } else {
        var flight_go_money = flightGo.value!.flights == null
            ? flightGo.value!.basePrice
            : (flightGo.value!.basePrice +
                flightGo.value!.flights!.first.basePrice);
        return sum_ticket_badge.value = (flight_go_money * 2) *
            (customer.value + children.value - (children.value * 0.25));
      }
    }
  }

  void clean() {
    isRouterGoAndBack.value = true;
    isSelectTicketOneWay.value = true;
    isSelectbusiness.value = true;
    flightBack.value = null;
    flightGo.value = null;
    flight_response.value = FlightResponse(
      flight_go: [],
      flight_back: [],
    );
    sum_badge_go.value = 0.0;
    sum_badge_back.value = 0.0;
    customer_input.clear();
    list_customer_data.clear();
    seats_flight_father.value = '';
    seats_flight_child.value = '';
    seats_flight_child_back.value = '';
    seats_flight_father_back.value = '';
    listOfFlightSeatsMaps.clear();
    listOfFlightBackSeatsMaps.clear();
    tickitDto.value = null;
    flight_go_data = [];
    flight_back_data = [];
  }

//seats
  var seatGo = [].obs;

  var seat_back = [].obs;

  var index_customer = 0.obs;
  var isLocked = true.obs;
  var isAlreadySelected = true.obs;
  var isAdult = true.obs;

  var currentIndex = 0.obs;
  var flightSeatsMap = <int, List<String>>{}.obs;
  var listOfFlightSeatsMaps = <Map<int, List<Customer_Ticket>>>{};
  var listOfFlightBackSeatsMaps = <Map<int, List<Customer_Ticket>>>{};

  var seats_flight_father = "Chưa chọn ghế".obs;
  var seats_flight_child = "Chưa chọn ghế".obs;
  var seats_flight_father_back = "Chưa chọn ghế".obs;
  var seats_flight_child_back = "Chưa chọn ghế".obs;

  void check_seats(String seatNumber, int index, int? flightId, bool choose,
      int? flightId_back) {
    if (flightId_back == null) {
      seatGo.value = [];
      if (flightGo.value!.id == flightId) {
        if (flightGo.value!.seats == null) {
          seatGo.value = [];
        }
        isLocked.value = flightGo.value!.seats!.contains(seatNumber);
      } else {
        if (flightGo.value!.seats == null) {
          seatGo.value = [];
        }
        isLocked.value =
            flightGo.value!.flights!.first.seats!.contains(seatNumber);
      }
    } else {
      seat_back.value = [];
      if (flightBack.value!.id == flightId_back) {
        if (flightBack.value!.seats == null) {
          seatGo.value = [];
        }
        isLocked.value = flightBack.value!.seats!.contains(seatNumber);
      } else {
        if (flightBack.value!.seats == null) {
          seatGo.value = [];
        }
        isLocked.value =
            flightBack.value!.flights!.first.seats!.contains(seatNumber);
      }
    }
  }

  var list_customer_data = <CustomerDto>{}.obs;
  Future<void> input_data_customer_go() async {
    String email = "";
    String phone = "";

    for (var customer in listOfFlightSeatsMaps) {
      if (customer.containsKey(flightGo.value!.id)) {
        var list_customer = customer[flightGo.value!.id];

        if (list_customer != null && list_customer.isNotEmpty) {
          for (var customer_data in list_customer) {
            email = customer_data.email!;
            phone = customer_data.phone!;
            Map<int, String> seats_go = {};
            seats_go[flightGo.value!.id] = customer_data.flight_go_seats!.value;

            var customer_data_go = CustomerDto(
              fullName: customer_data.full_name,
              aliases: customer_data.customer_title,
              birthOfDay: customer_data.birth_of_day,
              email: email,
              phone: phone,
              bagBack: customer_data.badge_back!.value,
              bagGo: customer_data.badge_go!.value,
              customType: customer_data.customType,
              seatsGo: seats_go,
              seatsGoChild: {},
              seatsBack: {},
              seatsBackChild: {},
            );
            if (flightGo.value!.flights != null) {
              input_data_customer_child(customer_data_go, customer_data, true);
              if (flightBack.value != null) {
                input_data_customer_back(customer_data_go);
              }
            } else {
              if (flightBack.value == null) {
                list_customer_data.add(customer_data_go);
              } else {
                input_data_customer_back(customer_data_go);
              }
            }
          }
        }
      }
    }
  }

  void input_data_customer_child(
      CustomerDto customerDto, Customer_Ticket customer_ticket, bool choose) {
    if (choose) {
      for (var customer in listOfFlightSeatsMaps) {
        if (customer.containsKey(flightGo.value!.flights!.first.id)) {
          var list_customer = customer[flightGo.value!.flights!.first.id];
          if (list_customer != null && list_customer.isNotEmpty) {
            Map<int, String> seats_go_child = {};
            for (var customer_data in list_customer) {
              if (customer_ticket.full_name == customer_data.full_name) {
                seats_go_child[flightGo.value!.flights!.first.id] =
                    customer_data.flight_go_seats!.value;
                customerDto.seatsGoChild = seats_go_child;
                list_customer_data.add(customerDto);
              }
            }
          }
        }
      }
    } else {
      for (var customer in listOfFlightBackSeatsMaps) {
        if (customer.containsKey(flightBack.value!.flights!.first.id)) {
          var list_customer = customer[flightBack.value!.flights!.first.id];
          if (list_customer != null && list_customer.isNotEmpty) {
            Map<int, String> seats_back_child = {};
            for (var customer_data in list_customer) {
              if (customer_ticket.full_name == customer_data.full_name) {
                seats_back_child[flightBack.value!.flights!.first.id] =
                    customer_data.flight_back_seats!.value;
                customerDto.seatsBackChild = seats_back_child;

                list_customer_data.add(customerDto);
              }
            }
          }
        }
      }
    }
  }

  void input_data_customer_back(CustomerDto customerDto) {
    for (var customer in listOfFlightBackSeatsMaps) {
      if (customer.containsKey(flightBack.value!.id)) {
        var list_customer = customer[flightBack.value!.id];

        if (list_customer != null && list_customer.isNotEmpty) {
          for (var customer_data in list_customer) {
            Map<int, String> seats_back = {};
            seats_back[flightBack.value!.id] =
                customer_data.flight_back_seats!.value;
            customerDto.seatsBack = seats_back;
            if (flightBack.value!.flights != null) {
              input_data_customer_child(customerDto, customer_data, false);
            } else {
              list_customer_data.add(customerDto);
            }
          }
        }
      }
    }
  }

  var orderNo = "".obs;
  var tickitDto = Rx<TickitDto?>(null);
  List<int> flight_go_data = [];
  List<int> flight_back_data = [];
  Future<TickitDto?> creteTickit() async {
    if (flightGo.value != null) {
      flight_go_data.add(flightGo.value!.id);

      if (flightGo.value!.flights != null) {
        flight_go_data.add(flightGo.value!.flights!.first.id);
      }
    }

    if (flightBack.value != null) {
      flight_back_data.add(flightBack.value!.id);

      if (flightBack.value!.flights != null) {
        flight_back_data.add(flightBack.value!.flights!.first.id);
      }
    }

    BookingTickit bookingTickit = new BookingTickit(
        flightGo: flight_go_data,
        flightBack: flight_back_data,
        customers: list_customer_data.toList(),
        ticketTypeGo: isSelectTicketOneWay.value,
        ticketTypeBack:
            flight_back_data.isEmpty ? null : isSelectbusiness.value);

    var response = await ticKet_Service.createOrder(bookingTickit);
    if (response != null) {
      tickitDto.value = response;
      return tickitDto.value;
    } else {
      return null;
    }
  }

  //! check payment khi thanh toan xong xoa acc trang di
}
