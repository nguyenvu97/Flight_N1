import 'dart:convert';

import 'package:flutter_application_4/model/flight/ResultDto.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Pay_Service {
  static String Url = "http://localhost:1003/api/v1/vnpay";

  Future<void> pay_menst(String orderNo) async {
    try {
      final response =
          await http.get(Uri.parse("$Url?orderNo=$orderNo&choose=false"));

      if (response.statusCode == 200) {
        print(response.body);
        ResultDto data = ResultDto.fromMap(jsonDecode(response.body));

        _launchUrl(data.url);
        return;
      } else {
        print("loi pay ment");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _launchUrl(String url) async {
    Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }

    // handlePaymentSuccess();
  }
}
