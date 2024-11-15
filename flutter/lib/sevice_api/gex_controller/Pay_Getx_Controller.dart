import 'package:flutter_application_4/sevice_api/Pay_Service.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:get/get.dart';

class Pay_Controller extends GetxController {
  var isOpenContai = true.obs;
  RxInt selectedPaymentIndex = (-1).obs;
  Ticket_Getx_Controller ticket_controller = Get.put(Ticket_Getx_Controller());
  Pay_Service pay_service = Pay_Service();
  Future<void> Payment(String orderNo) async {
    if (selectedPaymentIndex.value == 0) {
      pay_service.pay_menst(orderNo);
    }
  }

  void clean_data_payment() {
    selectedPaymentIndex.value = -1;
    ticket_controller.activeStep.value.delay();
  }
}
