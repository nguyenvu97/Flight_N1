import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/model/flight/Ariport.dart';
import 'package:flutter_application_4/sevice_api/Airport_Service.dart';

import 'package:get/get.dart';
import 'package:http/http.dart';

class Ariport_Controller extends GetxController {
  final ariport_service = AriportService();

  var startCountry = 'Hà Nội'.obs;
  var startCity = 'HAN'.obs;
  var endCountry = 'Hồ Chí Minh'.obs;
  var endCity = 'SGN'.obs;

  RxMap<String, List<Ariport>> menu = <String, List<Ariport>>{}.obs;
  var listdata = <Map<String, List<Ariport>>>[].obs;
  Future<void> getMenu() async {
    try {
      final data = await ariport_service.getMenu();
      if (data != null) {
        menu.value = data;

        listdata.add(menu.value);
        print(listdata.toJson());
      } else {
        print("loi ko lay dc data");
      }
    } catch (e) {
      print(e);
    }
  }

  void swapItems() {
    String swap = startCountry.value;
    String city = startCity.value;
    startCountry.value = endCountry.value;
    endCountry.value = swap;
    startCity.value = endCity.value;
    endCity.value = city;
  }
}
