import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/ShowSuccessController.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/model/flight/Ariport.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ariport_Getx_Controller.dart';

import 'package:get/get.dart';

class Show_Menu extends StatefulWidget {
  bool isSelect;
  Show_Menu({super.key, required this.isSelect});

  @override
  State<Show_Menu> createState() => _Show_MenuState();
}

Ariport_Controller ariport_controller = Get.put(Ariport_Controller());
Show_Dia_log showDialog1 = Get.put(Show_Dia_log());

GlobalKey<AnimatedListState> list_key = GlobalKey();

class _Show_MenuState extends State<Show_Menu> {
  Map<String, bool> isExpanded = <String, bool>{}.obs;
  RxList<Widget> body = <Widget>[].obs; // Make body reactive

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ariport_controller.menu.isNotEmpty) {
        data();
      }
    });
  }

  void data() {
    final dataMenu = ariport_controller.listdata;

    if (dataMenu.isNotEmpty) {
      dataMenu.forEach((map) {
        map.forEach((country, airports) {
          body.add(builderMenu(country, airports));
          isExpanded[country] = false;
          list_key.currentState!.insertItem(body.length - 1);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedList(
        key: list_key,
        initialItemCount: body.length,
        itemBuilder: ((context, index, animation) {
          return SlideTransition(
            position:
                animation.drive(Tween(begin: Offset(1, 0), end: Offset(0, 0))),
            child: body[index],
          );
        }),
      ),
    );
  }

  Widget builderMenu(String location, List<Ariport> ariports) {
    void check_start_end() {
      if (ariport_controller.startCountry.value ==
          ariport_controller.endCountry.value) {
        showDialog1.showSuccessDialog(context, "Thông Báo",
            "Bạn hãy xác nhận lại điểm đến vs điểm đi", false, null);
        ariport_controller.endCountry.value = '';
        ariport_controller.endCity.value = '';
      }
    }

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Row(
              children: [
                Text(location, style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(
                    onTap: () {
                      isExpanded[location] = !(isExpanded[location] ?? false);
                      print(isExpanded[location]);
                    },
                    child: (isExpanded[location] ?? false)
                        ? Icon(Icons.arrow_drop_up)
                        : Icon(Icons.arrow_drop_down)),
              ],
            ),
          ),
          SizedBox(
            height: (isExpanded[location] ?? false) ? ariports.length * 50 : 0,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ariports.length,
              itemBuilder: (context, index) {
                Ariport airport = ariports[index];
                return ListTile(
                  title: GestureDetector(
                      onTap: () {
                        if (widget.isSelect) {
                          ariport_controller.startCountry.value = airport.name;
                          ariport_controller.startCity.value = airport.code;
                          Navigator.pop(context);
                        } else {
                          ariport_controller.endCountry.value = airport.name;
                          ariport_controller.endCity.value = airport.code;
                          Navigator.pop(context);
                        }
                        check_start_end();
                      },
                      child: Text("${airport.name} \n${airport.code}")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
