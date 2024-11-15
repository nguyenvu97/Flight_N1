import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/ShowSuccessController.dart';

import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/model/flight/Customer_Ticket.dart';
import 'package:flutter_application_4/model/flight/FlightResponse.dart';

import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/assets_block_Controller.dart';
import 'package:get/get.dart';

class choose_seats extends StatefulWidget {
  Flight? flight_go;
  bool choose;
  Flight? flight_back;
  choose_seats(
      {super.key, this.flight_go, this.flight_back, required this.choose});

  @override
  State<choose_seats> createState() => _choose_seatsState();
}

Ticket_Getx_Controller ticket_controller = Get.put(Ticket_Getx_Controller());
Assets_Block_Controller assets_controller = Get.put(Assets_Block_Controller());
Show_Dia_log show_dia_log = Get.put(Show_Dia_log());

class _choose_seatsState extends State<choose_seats> {
  List<Widget> body = <Widget>[].obs;
  GlobalKey<AnimatedListState> list_key = GlobalKey();
  int currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Customer_Ticket>? _getCustomerTickets() {
    body.clear();
    Map<int, List<Customer_Ticket>> add_flight = {};
    if (widget.flight_back == null) {
      if (!widget.choose) {
        List<Customer_Ticket> newCustomerTickets =
            ticket_controller.customer_input.map((ticket) {
          return Customer_Ticket(
            customType: ticket.customType,
            email: ticket.email,
            phone: ticket.phone,
            full_name: ticket.full_name,
            customer_title: ticket.customer_title,
            birth_of_day: ticket.birth_of_day,
            badge_go: ticket.badge_go,
            badge_back: ticket.badge_back,
            flight_go_seats: ''.obs,
            flight_back_seats: ''.obs,
          );
        }).toList();

        add_flight[widget.flight_go!.id] = newCustomerTickets;
        bool containsKey = ticket_controller.listOfFlightSeatsMaps
            .any((map) => map.containsKey(widget.flight_go!.id));

        if (!containsKey) {
          ticket_controller.listOfFlightSeatsMaps.add(add_flight);
        }
      } else {
        add_flight[widget.flight_go!.id] = ticket_controller.customer_input;
        bool containsKey = ticket_controller.listOfFlightSeatsMaps
            .any((map) => map.containsKey(widget.flight_go!.id));

        if (!containsKey) {
          ticket_controller.listOfFlightSeatsMaps.add(add_flight);
        }
      }
      for (var data in ticket_controller.listOfFlightSeatsMaps) {
        if (data.containsKey(widget.flight_go!.id)) {
          var customerTickets = data[widget.flight_go!.id];

          if (customerTickets != null && customerTickets.isNotEmpty) {
            return customerTickets;
          }
        }
      }

      return [];
    } else {
      final flightId = widget.flight_back!.id;

      bool containsKey = ticket_controller.listOfFlightBackSeatsMaps
          .any((map) => map.containsKey(flightId));

      if (!containsKey) {
        List<Customer_Ticket> newCustomerTickets =
            ticket_controller.customer_input.map((ticket) {
          return Customer_Ticket(
            customType: ticket.customType,
            email: ticket.email,
            phone: ticket.phone,
            full_name: ticket.full_name,
            customer_title: ticket.customer_title,
            birth_of_day: ticket.birth_of_day,
            badge_go: ticket.badge_go,
            badge_back: ticket.badge_back,
            flight_go_seats: ''.obs,
            flight_back_seats: ''.obs,
          );
        }).toList();

        add_flight[flightId] = newCustomerTickets;
        ticket_controller.listOfFlightBackSeatsMaps.add(add_flight);
      }

      for (var data in ticket_controller.listOfFlightBackSeatsMaps) {
        if (data.containsKey(flightId)) {
          var customerTickets = data[flightId];
          if (customerTickets != null && customerTickets.isNotEmpty) {
            for (Customer_Ticket customer_ticket in customerTickets) {
              print(customer_ticket.flight_back_seats);
            }
            return customerTickets;
          }
        }
      }

      return [];
    }
  }

// Usage

  @override
  Widget build(BuildContext context) {
    final List<Customer_Ticket>? listCustomer = _getCustomerTickets();
    var media = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: media.height * 0.1,
            width: media.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listCustomer == null ? 0 : listCustomer.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentPage = index;
                      _pageController.jumpToPage(currentPage);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 2, color: Colors.grey),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ticket_controller.customer_input[index].customType ==
                                    "adult"
                                ? "Hành khách người lớn ${index + 1}"
                                : "Hành khách trẻ em ${index - index + 1}",
                          ),
                          Text_Data(
                            name:
                                ticket_controller.customer_input[index].full_name,
                            color: Colors.black,
                            size: 15,
                            maxLine: 1,
                          ),
                          Obx(
                            () => Text_Data(
                              name: widget.flight_back == null
                                  ? listCustomer![index]
                                          .flight_go_seats!
                                          .isNotEmpty
                                      ? "Ghế đã chọn : ${listCustomer[index].flight_go_seats}"
                                      : ""
                                  : listCustomer![index]
                                          .flight_back_seats!
                                          .isNotEmpty
                                      ? "Ghế đã chọn : ${listCustomer[index].flight_back_seats}"
                                      : "",
                              color: Colors.black,
                              size: 15,
                              maxLine: 1,
                            ),
                          ),
                        ]),
                  ),
                );
              },
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: media.height * 0.72,
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: ticket_controller.customer_input.length,
                  onPageChanged: (page) {
                    setState(() {
                      page = currentPage;
                    });
                  },
                  itemBuilder: (context, index) {
                    List<String> map_code_go =
                        ticket_controller.isSelectTicketOneWay.value
                            ? ["A", "B", "C", "D"]
                            : ["V", "I", "P"];
                    List<String> map_code_back =
                        ticket_controller.isSelectbusiness.value
                            ? ["A", "B", "C", "D"]
                            : ["V", "I", "P"];
                    return Column(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (!ticket_controller.isSelectFindBy.value) ...[
                                for (String code in map_code_go)
                                  Expanded(child: GoogleMapGo(code, listCustomer)),
                              ] else ...[
                                if (widget.flight_back != null) ...[
                                  for (String code in map_code_back)
                                    Expanded(child: GoogleMapGo(code, listCustomer)),
                                ] else ...[
                                  for (String code in map_code_go)
                                    Expanded(child: GoogleMapGo(code, listCustomer)),
                                ]
                              ],
                            ],
                          ),
                        ),

                      ],
                    );
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 10),
                      attention_seats("Ghế của tạm khóa", Colors.green),
                      const SizedBox(width: 10),
                      attention_seats("Ghế đã đặt", Colors.red),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 10),
                      attention_seats("Ghế còn trống", Colors.grey),
                      const SizedBox(width: 10),
                      attention_seats("Ghế của khách hàng", Colors.amber),
                      const SizedBox(width: 10),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // ticket_controller.listOfFlightSeatsMaps
                      //     .add(ticket_controller.flightSeatsMap);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      height: media.height * 0.05,
                      width: media.width,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 0.3, color: Colors.black),
                      ),
                      alignment: Alignment.center,
                      child: Text_Data(
                        name: "Hoàn tất chọn chỗ ngồi",
                        color: Colors.white,
                        size: 15,
                        maxLine: 1,
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget GoogleMapGo(String map, List<Customer_Ticket>? listCustomer) {
    int numberOfSeats = !ticket_controller.isSelectFindBy.value
        ? ticket_controller.isSelectTicketOneWay.value
            ? (ticket_controller.flightGo.value!.economySeats).toInt()
            : (ticket_controller.flightGo.value!.businessSeats).toInt()
        : widget.flight_back != null
            ? ticket_controller.isSelectbusiness.value
                ? (ticket_controller.flightBack.value!.economySeats).toInt()
                : (ticket_controller.flightBack.value!.businessSeats).toInt()
            : ticket_controller.isSelectTicketOneWay.value
                ? (ticket_controller.flightBack.value!.economySeats).toInt()
                : (ticket_controller.flightBack.value!.businessSeats).toInt();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(map),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int i = 1; i <= numberOfSeats / 4; i++)
                    SeatGoAndOnwWay('$map$i', listCustomer)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget SeatGoAndOnwWay(
      String seatNumber, List<Customer_Ticket>? listCustomer) {
    // List<String> blockedSeats = ['A1', 'A5', 'A6', 'A7', 'A8', 'A9'];
    bool isSelectedByAny = false;
    if (listCustomer != null) {
      for (var customer in listCustomer) {
        if (widget.flight_back == null) {
          if (customer.flight_go_seats!.value.split(',').contains(seatNumber)) {
            isSelectedByAny = true;
            break;
          }
        } else {
          if (customer.flight_back_seats!.value
              .split(',')
              .contains(seatNumber)) {
            isSelectedByAny = true;
            break;
          }
        }
      }
    }
    if (widget.flight_back == null) {
      ticket_controller.check_seats(
          seatNumber, currentPage, widget.flight_go!.id, widget.choose, null);
      assets_controller.check_seats_block(
          seatNumber, currentPage, widget.flight_go!.id, widget.choose, null);
    } else {
      ticket_controller.check_seats(
          seatNumber, currentPage, null, widget.choose, widget.flight_back!.id);
      assets_controller.check_seats_block(
          seatNumber, currentPage, null, widget.choose, widget.flight_back!.id);
    }

    ticket_controller.isAlreadySelected.value = isSelectedByAny;

    void update_seats(String seatsName) {
      setState(() {
        if (listCustomer == null) {
          return;
        }
        if (widget.flight_back == null) {
          listCustomer[currentPage].flight_go_seats!.value = "";
          if (listCustomer[currentPage].flight_go_seats!.isEmpty) {
            listCustomer[currentPage].flight_go_seats!.value = seatNumber;
          }
          if (currentPage < ticket_controller.customer_input.length - 1) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
          Navigator.pop(context);
        } else {
          print(seatNumber);
          listCustomer[currentPage].flight_back_seats!.value = "";
          if (listCustomer[currentPage].flight_back_seats!.isEmpty) {
            listCustomer[currentPage].flight_back_seats!.value = seatNumber;
          }

          if (currentPage < ticket_controller.customer_input.length - 1) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
          Navigator.pop(context);
        }
      });
    }

    return GestureDetector(
      onTap: () {
        currentPage = _pageController.page?.toInt() ?? 0;
        if (widget.flight_back == null) {
          ticket_controller.check_seats(seatNumber, currentPage,
              widget.flight_go!.id, widget.choose, null);
          assets_controller.check_seats_block(seatNumber, currentPage,
              widget.flight_go!.id, widget.choose, null);
        } else {
          ticket_controller.check_seats(seatNumber, currentPage, null,
              widget.choose, widget.flight_back!.id);
          assets_controller.check_seats_block(seatNumber, currentPage, null,
              widget.choose, widget.flight_back!.id);
        }

        if (ticket_controller.isLocked.value) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Thông Báo"),
                content: const Text("Ghế này đã đặt rồi"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Xác nhận"),
                  ),
                ],
              );
            },
          );
        } else if (ticket_controller.isAlreadySelected.value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Ghế $seatNumber này đã được chọn"),
            ),
          );
        } else if (assets_controller.isblock_assets.value) {
          show_dia_log.showSuccessDialog(context, "Thông báo",
              "Ghế $seatNumber này đã được người khác chọn", false, null);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Thông báo"),
                content: Text("bạn đã chọn ghê ${seatNumber}"),
                actions: [
                  TextButton(
                    child: Text("Xác Nhận"),
                    onPressed: () {
                      update_seats(seatNumber);
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: ticket_controller.isAlreadySelected.value
              ? Colors.amber
              : Colors.white, // Đổi màu của ghế nếu đã được chọn
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.airline_seat_recline_normal,
              size: 20,
              color: ticket_controller.isLocked.value
                  ? Colors
                      .red // Đổi màu của biểu tượng ghế nếu ghế đã bị khóa (đặt rồi)
                  : assets_controller.isblock_assets.value
                      ? Colors
                          .green // Màu xanh nếu ghế đã bị chọn bởi người khác
                      : Colors.grey,
            ),
            Text(
              seatNumber,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget attention_seats(String text, Color color_icon) {
    return Row(
      children: [
        Container(
            height: 40,
            width: 40,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            margin: const EdgeInsets.all(5),
            child: Icon(
              Icons.airline_seat_recline_normal,
              color: color_icon,
            )),
        Text_Data(name: text, color: color_icon, size: 10, maxLine: 1)
      ],
    );
  }
}
