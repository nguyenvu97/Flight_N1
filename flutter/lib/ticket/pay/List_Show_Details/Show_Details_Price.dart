import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/App_Colors.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ariport_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/assets_block_Controller.dart';
import 'package:flutter_application_4/ticket/input_data/Show_From_input.dart';
import 'package:flutter_application_4/ticket/input_data/seate/seate_page.dart';
import 'package:flutter_application_4/ticket/pay/List_Choose_Customer.dart';
import 'package:flutter_application_4/ticket/pay/List_Show_Details/Show_list_customer.dart';
import 'package:get/get.dart';

class Show_Details_Price extends StatefulWidget {
  const Show_Details_Price({super.key});

  @override
  State<Show_Details_Price> createState() => _Show_Details_PriceState();
}

late AnimationController _controller;
late Animation<Offset> _animation;
Ticket_Getx_Controller ticket_controller = Get.put(Ticket_Getx_Controller());
Ariport_Controller ariport_controller = Get.put(Ariport_Controller());
Assets_Block_Controller assets_controller = Get.find();

class _Show_Details_PriceState extends State<Show_Details_Price>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation =
        Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(_controller);
    _controller.forward();
    quantity_customer();
  }

  var tickit_data = ticket_controller.tickitDto.value;
  int quantity_adult = 0;
  int quantity_child = 0;
  void quantity_customer() {
    var customer_type =
        tickit_data!.customers.map((e) => e.customType).toList();
    for (var customer in customer_type) {
      if (customer.contains("adult")) {
        quantity_adult = quantity_adult + 1;
      } else {
        quantity_child = quantity_child + 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return AnimatedContainer(
        height: media.height * 0.65,
        duration: Duration(milliseconds: 200),
        child: SlideTransition(
          position: _animation,
          child: builer_price(context),
        ));
  }

  Widget builer_price(BuildContext context) {
    var media = MediaQuery.of(context).size;

    int? total_badge(bool choose) {
      if (choose) {
        var total_badge_go =
            tickit_data!.customers.map((e) => e.bagGo).toList();
        int badge =
            total_badge_go.fold(0, (sum, current) => sum + (current ?? 0));
        return badge;
      } else {
        var total_badge_back =
            tickit_data!.customers.map((e) => e.bagBack).toList();
        int badge =
            total_badge_back.fold(0, (sum, current) => sum + (current ?? 0));
        return badge;
      }
    }

    int? badge_go = total_badge(true);
    int? badge_back = total_badge(false);
    double? tickit_price_data() {
      var tickit_price = tickit_data!.totalTicket -
          (badge_go ?? 0 * AppColors.money_to_bage) -
          (badge_back ?? 0 * AppColors.money_to_bage);
      return tickit_price;
    }

    var tickit_total_money_go = 0.0;
    var tickit_total_money_back = 0.0;

    double? tickit_total() {
      if (tickit_data!.flightsGo != null) {
        tickit_total_money_go = tickit_data!.flightsGo.basePrice;
        if (tickit_data!.flightsGo.flights != null) {
          tickit_total_money_go =
              tickit_data!.flightsGo.flights!.first.basePrice +
                  tickit_total_money_go;
        }
      }

      if (tickit_data!.flightsBack != null) {
        tickit_total_money_back = tickit_data!.flightsBack!.basePrice;
        if (tickit_data!.flightsBack!.flights != null) {
          tickit_total_money_back = tickit_data!.flightsBack!.basePrice +
              tickit_data!.flightsBack!.flights!.first.basePrice;
        }
      }
      if (tickit_data!.ticketTypeGo == "Economy") {
        tickit_total_money_go = tickit_total_money_go * AppColors.Economy_Money;
      } else {
        tickit_total_money_go =
            tickit_total_money_go * AppColors.Business_Money;
      }

      if (tickit_data!.ticketTypeBack != null) {
        if (tickit_data!.ticketTypeBack == "Economy") {
          tickit_total_money_back =
              tickit_total_money_back * AppColors.Economy_Money;
        } else {
          tickit_total_money_back =
              tickit_total_money_back * AppColors.Business_Money;
        }
      }
      return tickit_total_money_go + tickit_total_money_back;
    }

    String? list_asets(int number) {
      switch (number) {
        case 1:
          return assets_controller.seats_go_1.join(",");
          break;
        case 2:
          return assets_controller.seats_go_child_1.join(",");
          break;
        case 3:
          return assets_controller.seats_back_1.join(",");
          break;
        case 4:
          return assets_controller.seats_back_child_1.join(",");
          break;
      }
    }

    final flightGo = tickit_data!.flightsGo;
    final flightBack = tickit_data!.flightsBack;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InforCustomer(
            tital: 'Giá vé',
            dataCustomer:
                "${AppColors.formatCurrency(quantity_adult * tickit_total()! + (quantity_child * tickit_total()! * (1 - AppColors.child_discount)))}",
          ),
          const SizedBox(
            height: 10,
          ),
          infomatiom(
              'Người lớn ',
              "${AppColors.formatCurrency((quantity_adult * tickit_total()!))}",
              quantity_adult),
          const SizedBox(
            height: 10,
          ),
          infomatiom(
              'Trẻ em',
              "${AppColors.formatCurrency((quantity_child * tickit_total()! * (1 - AppColors.child_discount)))}",
              quantity_child),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          Text_Data(name: "Hành lý", color: Colors.black, size: 15, maxLine: 1),
          const SizedBox(
            height: 10,
          ),
          InforCustomer(
            tital:
                '${ariport_controller.startCountry} -----> ${ariport_controller.endCountry}',
            dataCustomer:
                "${AppColors.formatCurrency((badge_go! * AppColors.money_to_bage))}",
          ),
          const SizedBox(
            height: 10,
          ),
          tickit_data!.flightsBack != null
              ? InforCustomer(
                  tital:
                      '${ariport_controller.endCountry}  -----> ${ariport_controller.startCountry}',
                  dataCustomer:
                      "${AppColors.formatCurrency((badge_back! * AppColors.money_to_bage))}",
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          Text_Data(name: "Loai vé", color: Colors.black, size: 15, maxLine: 1),
          const SizedBox(
            height: 10,
          ),
          InforCustomer(
            tital: 'Loại vé chiều đi',
            dataCustomer: tickit_data!.ticketTypeGo,
          ),
          tickit_data!.flightsBack != null
              ? InforCustomer(
                  tital: 'Loại vé chiều về',
                  dataCustomer: tickit_data!.ticketTypeBack!,
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          Text_Data(
              name: "Chỗ ngồi", color: Colors.black, size: 15, maxLine: 1),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              if (flightGo != null) ...[
                if (flightGo.flights == null)
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        seats(
                          to_city: " ${flightGo.fromCity} ---> ",
                          from_city: "${flightGo.toCity}",
                        ),
                        Text_Data(
                            name: list_asets(1) ?? "",
                            color: Colors.black,
                            size: 15,
                            maxLine: 1)
                      ],
                    ),
                  ])
                else ...[
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          seats(
                            to_city: "${flightGo.fromCity} ---> ",
                            from_city: "${flightGo.flights!.first.fromCity}",
                          ),
                          Text_Data(
                              name: list_asets(1) ?? "",
                              color: Colors.black,
                              size: 15,
                              maxLine: 1)
                        ]),
                  ]),
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        seats(
                          to_city: "${flightGo.flights!.first.fromCity} ---> ",
                          from_city: "${flightGo.flights!.first.toCity}",
                        ),
                        Text_Data(
                            name: list_asets(2) ?? "",
                            color: Colors.black,
                            size: 15,
                            maxLine: 1)
                      ],
                    ),
                  ]),
                ],
              ],
              Visibility(
                visible: ticket_controler.isSelectFindBy.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (flightBack != null)
                      if (flightBack.flights == null)
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  seats(
                                    to_city: " ${flightBack.fromCity} ---> ",
                                    from_city: "${flightBack.toCity}",
                                  ),
                                  Text_Data(
                                      name: list_asets(3) ?? "",
                                      color: Colors.black,
                                      size: 15,
                                      maxLine: 1)
                                ],
                              ),
                            ])
                      else ...[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  seats(
                                    to_city: "${flightBack.fromCity} ---> ",
                                    from_city:
                                        "${flightBack.flights!.first.fromCity}",
                                  ),
                                  Text_Data(
                                      name: list_asets(3) ?? "",
                                      color: Colors.black,
                                      size: 15,
                                      maxLine: 1)
                                ],
                              ),
                            ]),
                        if (flightBack != null && flightBack.flights != null)
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    seats(
                                      to_city: "${flightBack!.toCity} ---> ",
                                      from_city:
                                          "${flightBack.flights!.first.toCity}",
                                    ),
                                    Text_Data(
                                        name: list_asets(4) ?? "",
                                        color: Colors.black,
                                        size: 15,
                                        maxLine: 1)
                                  ],
                                ),
                              ]),
                      ]
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          InforCustomer(
            tital: 'Tổng Tiền ',
            dataCustomer:
                "${AppColors.formatCurrency((tickit_data!.totalTicket))}",
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: media.height * 0.05,
              width: media.width * 1,
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Text_Data(
                  name: "Xác nhận", color: Colors.black, size: 15, maxLine: 1),
            ),
          )
        ],
      ),
    );
  }

  Widget infomatiom(String tital, String dataCustomer, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 3,
            child: Text_Data(
                name: tital, color: Colors.black54, size: 15, maxLine: 1)),
        Expanded(
          flex: 1,
          child: Text_Data(
              name: quantity.toString(),
              color: Colors.black54,
              size: 15,
              maxLine: 1),
        ),
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.centerRight,
            child: Text_Data(
                name: dataCustomer, color: Colors.black, size: 15, maxLine: 1),
          ),
        ),
      ],
    );
  }
}
