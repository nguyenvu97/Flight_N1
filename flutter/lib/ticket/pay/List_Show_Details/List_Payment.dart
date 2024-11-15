import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Pay_Getx_Controller.dart';
import 'package:flutter_application_4/ticket/input_data/Show_From_input.dart';
import 'package:get/get.dart';

class List_Paymanst extends StatefulWidget {
  const List_Paymanst({super.key});

  @override
  State<List_Paymanst> createState() => _List_PaymanstState();
}

List<Payment_Data> data = [
  new Payment_Data(imge: "assets/vnpay.png", titil: "Thẻ ATM, QR pay"),
  new Payment_Data(imge: "assets/MoMo.jpg", titil: "MoMo"),
  new Payment_Data(imge: "assets/shoppeepay.png", titil: "ShopeePay"),
  new Payment_Data(imge: "", titil: "Thanh toán trả sau")
];
Pay_Controller pay_controller = Get.put(Pay_Controller());

class _List_PaymanstState extends State<List_Paymanst> {
  RxList<Widget> body = <Widget>[].obs;
  GlobalKey<AnimatedListState> list_key_payment = GlobalKey();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addData();
    });
    super.initState();
  }

  void addData() {
    body.clear();
    var List_payment = data;
    if (List_payment.isNotEmpty) {
      List_payment.asMap().forEach((index, data) {
        body.add(builder_payment(data, index)); // Thêm vào danh sách body
        list_key_payment.currentState
            ?.insertItem(body.length - 1); // Cập nhật widget
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return AnimatedList(
      key: list_key_payment,
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

  Widget builder_payment(Payment_Data payment_data, int index) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              pay_controller.selectedPaymentIndex.value = index;
            },
            child: Container(
              padding: const EdgeInsetsDirectional.all(10),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text_Data(
                      name: payment_data.titil,
                      color: pay_controller.selectedPaymentIndex.value == index
                          ? Colors.red
                          : Colors.black,
                      size: 15,
                      maxLine: 1),
                  payment_data.imge != ""
                      ? Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: AssetImage(payment_data.imge),
                                  fit: BoxFit.cover)),
                        )
                      : Container()
                ],
              ),
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}

class Payment_Data {
  String titil;
  String imge;
  Payment_Data({required this.imge, required this.titil});
}
