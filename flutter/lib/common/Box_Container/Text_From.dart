import 'package:flutter/material.dart';

class Text_from extends StatelessWidget {
  String labelText;
  Icon icon;
  bool obscureText;
  bool carenda;
  final Function(String?)? onSaved;
  Text_from(
      {super.key,
      required this.onSaved,
      required this.labelText,
      required this.icon,
      required this.carenda,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          icon: icon,
          prefix: carenda
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Icon(Icons.calendar_month)],
                )
              : null,
          labelText: labelText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.black)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
        },
        onSaved: onSaved);
  }
}
