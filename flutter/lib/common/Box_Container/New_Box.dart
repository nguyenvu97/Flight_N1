import 'package:flutter/material.dart';

class NewBox extends StatelessWidget {
  final Widget child;

  NewBox({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      child: Center(
        child: child,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade300,
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                color: Colors.grey.shade500,
                offset: Offset(5, 5)),
            BoxShadow(
                blurRadius: 10, color: Colors.white, offset: Offset(-5, -5))
          ]),
    );
  }
}
