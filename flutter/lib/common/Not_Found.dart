import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/Text_Data.dart';

import 'package:flutter_application_4/home/Home_page.dart';
import 'package:flutter_application_4/home/Menu_Main_Home.dart';
import 'package:lottie/lottie.dart';

class Not_Found extends StatelessWidget {
  Not_Found({super.key});

  @override
  Widget build(BuildContext context) {
    String mainErrorText =
        "Chúng tôi xin lỗi, trang bạn yêu cầu\nkhông thể tìm thấy. Vui lòng quay lại\ntrang chủ!";
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 50),
        height: media.height,
        width: media.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text_Data(
                name: "404",
                color: Colors.black,
                size: 40,
                maxLine: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text_Data(
                name: "Page Not Found",
                color: Colors.black,
                size: 35,
                maxLine: 1,
              ),
            ),
            Center(
              child: Lottie.asset('assets/1.json'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: media.height * 0.1,
              width: media.width * 0.8,
              child: Text_Data(
                name: mainErrorText,
                color: Colors.black,
                size: 15,
                maxLine: 3,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: media.height * 0.07,
                width: media.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber[400]),
                child: Center(
                  child: Text_Data(
                    name: "Trang Chủ",
                    color: Colors.black,
                    size: 25,
                    maxLine: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
