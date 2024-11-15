import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_4/common/App_Colors.dart';
import 'package:flutter_application_4/common/New_Text_Input.dart';
import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/model/flight/Customer_Ticket.dart';

import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:flutter_application_4/ticket/choose_tickit/Choose_Ticket.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../Ticket/input_data/Infomation_Customer.dart';

class ShowFrom extends StatefulWidget {
  final Function(List<GlobalKey<FormState>>) onKeysReady;
  ShowFrom({super.key, required this.onKeysReady});

  @override
  State<ShowFrom> createState() => _ShowFromState();
}

class _ShowFromState extends State<ShowFrom> with TickerProviderStateMixin {
  PageController pageViewController = PageController();

  Show_Dia_log show_dia_log = Get.find();

  Ticket_Getx_Controller tickit_controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    List<GlobalKey<FormState>> _formKeys = List.generate(
      tickit_controller.customer.value + tickit_controller.children.value,
      (index) => GlobalKey<FormState>(),
    );

    @override
    void initState() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onKeysReady(_formKeys);
      });
      super.initState();
    }

    final totalPages =
        tickit_controller.customer.value + tickit_controller.children.value;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        height: media.height * 0.8,
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageViewController,
          children: List.generate(totalPages, (index) {
            bool isAdult = index < tickit_controller.customer.value;
            ticket_controler.isAdult.value = isAdult;
            return Column(
              children: [
                AppBar(
                  leading: null,
                  automaticallyImplyLeading: false,
                  title: Text_Data(
                      name: isAdult
                          ? "Nhập thông tin người lớn ${index + 1}"
                          : "Nhập thông tin trẻ con ${index - tickit_controller.customer.value + 1}",
                      color: Colors.black,
                      size: 15,
                      maxLine: 1),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ))
                  ],
                  elevation: 4,
                ),
                Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: _formKeys[index],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Column(
                          children: [
                            Text_Data(
                                name: "1. Thông tin căn bản",
                                color: Colors.black,
                                size: 20,
                                maxLine: 1),
                            const SizedBox(height: 40),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  choose_customertype_briday(
                                    choose: false,
                                    isAdult: isAdult,
                                  ),
                                  const SizedBox(height: 10),
                                  New_Text_Input(
                                    icon: const Icon(Icons.person),
                                    onSaved: (value) {
                                      tickit_controller.fullName.value =
                                          value ?? "";
                                    },
                                    name_header: "Họ và Tên",
                                    returnEx: 'Họ và tên không đúng',
                                  ),
                                  const SizedBox(height: 40),
                                  choose_customertype_briday(
                                    choose: true,
                                    isAdult: isAdult,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Obx(
                          () => Visibility(
                            visible:
                                tickit_controller.customer_input.value.isEmpty,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text_Data(
                                    name: "2. Thông tin liên hệ",
                                    color: Colors.black,
                                    size: 20,
                                    maxLine: 1),
                                Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      children: [
                                        New_Text_Input(
                                          icon: Icon(Icons.email),
                                          onSaved: (value) {
                                        
                                              tickit_controller.email.value =
                                                  value ?? "";
                                            
                                          },
                                          name_header: "Email",
                                          returnEx:
                                              "Email không đúng định dạng",
                                        ),
                                        const SizedBox(height: 10),
                                        New_Text_Input(
                                          icon: Icon(Icons.contact_phone),
                                          onSaved: (value) {
                                            tickit_controller.phone.value =
                                                value ?? "";
                                          },
                                          name_header: "Số Điện Thoại",
                                          returnEx: 'Số Điện Thoại không đúng',
                                        ),
                                        const SizedBox(height: 40),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: () {
                              if (_formKeys[index].currentState?.validate() ??
                                  false) {
                                _formKeys[index].currentState?.save();

                                tickit_controller.customer_input.add(
                                  Customer_Ticket(
                                    customType: isAdult ? "adult" : "child",
                                    birth_of_day:
                                        tickit_controller.birthOfDay.value,
                                    customer_title:
                                        tickit_controller.customer_title.value,
                                    full_name: tickit_controller.fullName.value,
                                    email: tickit_controller.email.value,
                                    phone: tickit_controller.phone.value,
                                  ),
                                );

                                final currentPage =
                                    pageViewController.page?.toInt() ?? 0;
                                if (currentPage < totalPages - 1) {
                                  pageViewController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                  tickit_controller.removeData();
                                } else {
                                  Navigator.pop(
                                      context); // Đóng modal khi đến form cuối
                                }
                              }
                            },
                            child: Container(
                              height: media.height * 0.05,
                              width: media.width * 1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.amber),
                              alignment: Alignment.center,
                              child: Text_Data(
                                  name: "Xác nhận",
                                  color: Colors.black,
                                  size: 20,
                                  maxLine: 1),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class choose_customertype_briday extends StatefulWidget {
  choose_customertype_briday(
      {super.key, required this.choose, required this.isAdult});
  final bool choose;
  final bool isAdult;

  @override
  State<choose_customertype_briday> createState() =>
      choose_customertype_bridayState();
}

DateTime dateTime = DateTime(1997, 06, 17);
Ticket_Getx_Controller tickit_controller = Get.find();
int index = 0;

class choose_customertype_bridayState
    extends State<choose_customertype_briday> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Obx(
      () => GestureDetector(
        onTap: () async {
          if (widget.choose) {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return Container(
                  height: media.height * 0.4,
                  width: media.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CupertinoDatePicker(
                    use24hFormat: true,
                    mode: CupertinoDatePickerMode.date,
                    backgroundColor: Colors.white,
                    initialDateTime: dateTime,
                    maximumDate: DateTime(3000),
                    onDateTimeChanged: (value) {
                      tickit_controller.birthOfDay.value =
                          DateFormat('dd/MM/yyyy').format(value);
                    },
                  ),
                );
              },
            );
          } else {
            showModalBottomSheet(
              isDismissible: true,
              isScrollControlled: false,
              context: context,
              builder: (context) {
                List<String> titles = widget.isAdult
                    ? tickit_controller.data_title_adult
                    : tickit_controller.data_title_child;

                return Container(
                  height: media.height * 0.5,
                  width: media.width,
                  child: Column(
                    children: [
                      AppBar(
                        automaticallyImplyLeading: false,
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 15,
                            ),
                          )
                        ],
                        title: Text_Data(
                          name: "Danh Xưng",
                          color: Colors.black,
                          size: 15,
                          maxLine: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: media.height * 0.4,
                        child: titles.isNotEmpty
                            ? ListView.builder(
                                itemCount: titles.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: SizedBox(
                                      height: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                tickit_controller.customer_title
                                                    .value = titles[index];
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Text_Data(
                                                name: titles[index],
                                                color: Colors.black,
                                                size: 15,
                                                maxLine: 1,
                                              ),
                                            ),
                                          ),
                                          const Divider(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                    "Không có danh xưng nào.")), // Hiển thị khi danh sách rỗng
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.choose ? Icon(Icons.calendar_month) : Icon(Icons.title),
            Container(
              width: media.width * 0.85,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black12))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text_Data(
                      name: widget.choose
                          ? tickit_controller.birthOfDay.value == ""
                              ? "Ngày tháng năm sinh"
                              : tickit_controller.birthOfDay.value
                          : tickit_controller.customer_title.value == ""
                              ? "Danh Xưng"
                              : tickit_controller.customer_title.value,
                      color: Colors.black,
                      size: 15,
                      maxLine: 1),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
