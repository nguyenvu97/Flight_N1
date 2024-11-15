import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/App_Colors.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:google_fonts/google_fonts.dart';

class New_Text_Input extends StatelessWidget {
  Icon icon;

  String name_header;
  String returnEx;
  final Function(String?)? onSaved;

  New_Text_Input(
      {super.key,
      required this.icon,
      required this.name_header,
      required this.returnEx,
      required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: GoogleFonts.headlandOne(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
        obscureText: false,
        readOnly: false,
        decoration: InputDecoration(
            icon: icon,
            label: Text_Data(
              name: name_header,
              color: Colors.black,
              size: 15,
              maxLine: 1,
            ),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return returnEx;
          }
          // if (icon.icon == Icons.email) {
          //   if (!AppColors.checkemail(value)!) {
          //     return returnEx;
          //   }
          // } else if (icon.icon == Icons.contact_phone) {
          //   if (!AppColors.checkPhone(value)!) {
          //     return returnEx;
          //   }
          // }

          // return returnEx;
        },
        onSaved: onSaved);
  }
}
