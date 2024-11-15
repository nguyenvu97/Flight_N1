import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/Text_Data.dart';

import 'package:flutter_application_4/home/Home_page.dart';
import 'package:flutter_application_4/ticket/findby_ticket/Find_By_Ticket.dart';

class On_Long_Press extends StatelessWidget {
  final Map iObj;
  void Function(int) toggleSize;
  void Function() onLongPressEnd;
  bool isExpanded;
  int index;
  On_Long_Press(
      {super.key,
      required this.onLongPressEnd,
      required this.toggleSize,
      required this.isExpanded,
      required this.index,
      required this.iObj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Stack(
      children: [
        GestureDetector(
          onLongPress: () => toggleSize(index),
          onLongPressEnd: (_) => onLongPressEnd(),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FindByTicket()));
          },
          child: AnimatedContainer(
            duration: const Duration(seconds: 150),
            curve: Curves.easeInOutCubic,
            child: Container(
              margin: EdgeInsets.all(10),
              child: Transform.scale(
                scale: isExpanded ? 1.2 : 1,
                child: Image.asset(
                  iObj["img"],
                  height: media.height * 0.25,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
            top: media.height * 0.13,
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SizedBox(
                  width: media.width * 0.27,
                  child: (Text_Data(
                      name: iObj["text"].toString(),
                      color: isExpanded ? Colors.amber : Colors.white,
                      size: 16,
                      maxLine: 2)),
                ),
                Container(
                    width: media.width * 0.3,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: isExpanded ? Colors.amber : Colors.white)),
                    child: Text_Data(
                        name: "Khám Phá",
                        color: isExpanded ? Colors.amber : Colors.white,
                        size: 15,
                        maxLine: 1)),
              ],
            ))
      ],
    );
  }
}
