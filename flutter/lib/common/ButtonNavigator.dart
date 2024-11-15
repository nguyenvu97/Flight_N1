import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/Box_Container/New_Box.dart';

class BottomNavigator extends StatelessWidget {
  final child;
  BottomNavigator({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        child: child,
      ),
    );
  }
}
