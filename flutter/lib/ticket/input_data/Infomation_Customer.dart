import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_4/Ticket/Tapbar/List_Flight.dart';
import 'package:flutter_application_4/common/App_Colors.dart';
import 'package:flutter_application_4/common/LoadingUtils.dart';
import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ariport_Getx_Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/assets_block_Controller.dart';
import 'package:flutter_application_4/ticket/input_data/Show_From_input.dart';
import 'package:flutter_application_4/ticket/input_data/badge/badge_body.dart';

import 'package:flutter_application_4/ticket/input_data/seate/seate_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';

class InfoCustomer extends StatefulWidget {
  const InfoCustomer({super.key});

  @override
  State<InfoCustomer> createState() => _InfoCustomerState();
}

Ticket_Getx_Controller ticket_controler = Get.put(Ticket_Getx_Controller());
Ariport_Controller ariport_controller = Get.put(Ariport_Controller());
Show_Dia_log show_dia_log = Get.find();
Assets_Block_Controller assets_controller = Get.put(Assets_Block_Controller());

class _InfoCustomerState extends State<InfoCustomer> {
  @override
  void initState() {
    super.initState();

    ticket_controler.sum_Anything_Ticket();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return SizedBox(
        height: media.height,
        width: media.width * 1,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            height: media.height * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ticket_controller.isSelectFindBy.value
                  ? AppColors.econdaryFlightColors
                  : AppColors.FlightColors,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text_Data(
                              name: "Tổng Cộng : ",
                              color: AppColors.textColor,
                              size: 15,
                              maxLine: 1)),
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        child: Text_Data(
                            name:
                                "${AppColors.formatCurrency(ticket_controler.sum_ticket_badge.value)}",
                            color: AppColors.textColor,
                            size: 30,
                            maxLine: 1),
                      )),
                      Expanded(
                          child: Text_Data(
                              name: "Giá chưa bao gồm dịch vị bổ trợ",
                              color: AppColors.textColor,
                              size: 15,
                              maxLine: 1))
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Obx(
            () => Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ticket_controller.isSelectFindBy.value
                    ? AppColors.econdaryFlightColors
                    : AppColors.FlightColors,
              ),
              alignment: AlignmentDirectional.topStart,
              height: (ticket_controller.customer.value +
                      ticket_controler.children.value) *
                  70,
              child: childAndAdult(media),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          badge_seats(media, true),
          const SizedBox(
            height: 10,
          ),
          badge_seats(media, false),
          const SizedBox(
            height: 20,
          ),
          ChoosePayAndHotel(media)
        ]));
  }

  Container badge_seats(Size media, bool choose) {
    return Container(
        padding: const EdgeInsets.all(10),
        width: media.width * 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ticket_controller.isSelectFindBy.value
              ? AppColors.econdaryFlightColors
              : AppColors.FlightColors,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    child: Row(
                  children: [
                    choose
                        ? Icon(Icons.badge)
                        : Icon(Icons.airline_seat_recline_normal),
                    const SizedBox(
                      width: 5,
                    ),
                    Text_Data(
                        name: choose ? "Hành lý" : "Chọn Ghế",
                        color: Colors.black,
                        size: 15,
                        maxLine: 1)
                  ],
                )),
                Icon(Icons.arrow_drop_down),
              ],
            ),
            choose
                ? Container(
                    constraints: BoxConstraints(
                      maxHeight:
                          ticket_controller.isSelectFindBy.value ? 160 : 80,
                    ),
                    width: double.infinity, // Use full width
                    child: App_Bar_Seats_Bag(),
                  )
                : Container(
                    constraints: BoxConstraints(
                      maxHeight:
                          ticket_controller.isSelectFindBy.value ? 300 : 120,
                    ),
                    width: double.infinity, // Use full width
                    child: Seats_page(),
                  ),
          ],
        ));
  }

  Widget ChoosePayAndHotel(Size media) {
    return GestureDetector(
      onTap: () async {
        await ticket_controler.input_data_customer_go();
        if (ticket_controler.list_customer_data.isEmpty) {
          show_dia_log.showSuccessDialog(
              context, "Thông Báo", "Hãy chọn ghế ", false, null);
        } else {
          await ticket_controller.creteTickit();
          if (ticket_controller.tickitDto.value != null) {
            assets_controller.add_assest();

            LoadingUtils.show();
            Future.delayed(Duration(seconds: 5), () {
              ticket_controler.activeStep.value = 2;
              LoadingUtils.hide();
            });
          }
        }
      },
      child: Container(
        height: media.height * 0.05,
        width: media.width * 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ticket_controller.isSelectFindBy.value
              ? AppColors.econdaryFlightColors
              : AppColors.FlightColors,
        ),
        alignment: Alignment.center,
        child: Text_Data(
            name: "Thanh toán", color: Colors.black, size: 20, maxLine: 1),
      ),
    );
  }

  Widget childAndAdult(Size size) {
    int totalCount = ticket_controller.children.value < 1
        ? ticket_controller.customer.value
        : ticket_controller.customer.value + ticket_controller.children.value;

    List<Widget> children = List.generate(totalCount, (index) {
      bool isAdult = index < ticket_controller.customer.value;

      var full_name = ticket_controller.customer_input
          .map((data) => data.full_name)
          .toList();

      return ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text_Data(
              name: isAdult
                  ? "Hành Khách ${index + 1} - Người lớn"
                  : "Hành Khách ${index - index + 1} - Trẻ Em",
              color: Colors.black,
              size: 15,
              maxLine: 1,
            ),
            Row(
              children: [
                const Icon(
                  Icons.add_circle_outline,
                  color: Colors.brown,
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    index == 0
                        ? showModalBottomSheet(
                            isDismissible: false,
                            enableDrag: false,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                  height: size.height * 0.9,
                                  width: size.width * 1,
                                  child: ShowFrom(
                                    onKeysReady: (formKeys) {
                                      print('Received keys: $formKeys');
                                    },
                                  ));
                            },
                          )
                        : null;
                  },
                  child: SizedBox(
                    width: size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text_Data(
                          name: ticket_controler.customer_input.length ==
                                  totalCount
                              ? full_name[index]
                              : "Nhập thông tin",
                          color: Colors.brown,
                          size: 15,
                          maxLine: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
    return SizedBox(
      height: size.height * 0.5,
      child: SingleChildScrollView(
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
