import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/App_Colors.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/model/hotel/CustomerDto.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:get/get.dart';

class Show_List_Curtomer extends StatefulWidget {
  Show_List_Curtomer({
    super.key,
  });

  @override
  State<Show_List_Curtomer> createState() => _Show_List_CurtomerState();
}

RxList<Widget> body = <Widget>[].obs;
late GlobalKey<AnimatedListState> list_key_customer = GlobalKey();

Ticket_Getx_Controller ticket_controller = Get.put(Ticket_Getx_Controller());

class _Show_List_CurtomerState extends State<Show_List_Curtomer> {
  void addData() {
    body.value.clear();
    var List_Customer = ticket_controller.tickitDto.value!.customers;
    if (!List_Customer.isEmpty) {
      List_Customer.asMap().forEach((index, data) {
        body.add(builerCustomer(data, index)); // Thêm vào danh sách body
        list_key_customer.currentState?.insertItem(body.length - 1); // Cập nhật widget
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addData();
    });
    super.initState();
  }

  @override
  void dispose() {
    body.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: list_key_customer,
      initialItemCount: body.length,
      itemBuilder: (context, index, animation) {
        return SlideTransition(
          position:
              animation.drive(Tween(begin: Offset(1, 0), end: Offset(0, 0))),
          child: body[index],
        );
      },
    );
  }

  Widget builerCustomer(CustomerDto customerDto, int index) {
    String name = customerDto.customType == "child"
        ? "Hành Khách ${index + 1} - Trẻ con"
        : "Hành Khách ${index + 1} - Người lớn";
    // double tickit_price = customerDto.amountTotal! -
    //     (customerDto.bagGo ?? 0 * AppColors.money_to_bage) -
    //     (customerDto.bagBack ?? 0 * AppColors.money_to_bage);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text_Data(name: name, color: Colors.black, size: 15, maxLine: 1),
          const SizedBox(
            height: 10,
          ),
          Text_Data(
              name: customerDto.fullName,
              color: Colors.black,
              size: 15,
              maxLine: 1),
          const SizedBox(
            height: 10,
          ),
          Text_Data(
              name: "Thông tin cơ bản ",
              color: Colors.black,
              size: 15,
              maxLine: 1),
          const SizedBox(
            height: 10,
          ),
          InforCustomer(tital:"Ngày Sinh", dataCustomer :customerDto.birthOfDay),
          const SizedBox(
            height: 10,
          ),
          Text_Data(
              name: "Thông tin liên hệ ",
              color: Colors.black,
              size: 15,
              maxLine: 1),
          const SizedBox(
            height: 10,
          ),
          InforCustomer(tital:"Điện thoại", dataCustomer :customerDto.phone),
          const SizedBox(
            height: 10,
          ),
          InforCustomer(tital:"Thư điện tử", dataCustomer:customerDto.email),
          const SizedBox(
            height: 10,
          ),
          const Divider()
        ],
      ),
    );
  }

  
}
class InforCustomer extends StatefulWidget {
  String tital;
  String dataCustomer;
   InforCustomer({super.key,required this.tital,required this.dataCustomer});

  @override
  State<InforCustomer> createState() => _nameState();
}

class _nameState extends State<InforCustomer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text_Data(name: widget.tital, color: Colors.black54, size: 15, maxLine: 1),
        Text_Data(
            name:widget.dataCustomer, color: Colors.black, size: 15, maxLine: 1),
      ],
    );
  }
}

