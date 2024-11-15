import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/Box_Container/Grid_View.dart';
import 'package:flutter_application_4/common/Text_Data.dart';

class TopPicksCell extends StatelessWidget {
  final Map iObj;
  TopPicksCell({super.key, required this.iObj});
  TabController? controller;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Stack(children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 2),
                  color: Colors.transparent,
                  blurRadius: 1)
            ]),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => grid_view()));
                },
                child: Transform.scale(
                  scale: 1.5,
                  child: Image.asset(iObj['img'].toString(),
                      height: media.height * 0.2,
                      width: media.width,
                      fit: BoxFit.contain),
                ),
              ),
            )),
      ),
    ]);
  }
}
