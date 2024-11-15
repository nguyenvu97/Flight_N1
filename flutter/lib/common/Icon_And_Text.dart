import 'package:flutter/material.dart';

import 'package:flutter_application_4/common/Text_Data.dart';

class Icon_And_Text extends StatefulWidget {
  IconData icon;
  String name;
  double size;
  Color color;
  Color iconColor;

  Icon_And_Text(
      {super.key,
      required this.icon,
      required this.size,
      required this.name,
      required this.color,
      required this.iconColor});

  @override
  State<Icon_And_Text> createState() => _Icon_And_TextState();
}

class _Icon_And_TextState extends State<Icon_And_Text> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(
            widget.icon,
            color: widget.iconColor,
          ),
        ),
        Container(
          child: Text_Data(
            name: widget.name,
            color: widget.color,
            size: widget.size,
            maxLine: 1,
          ),
        )
      ],
    );
  }
}
