import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFailInput extends StatelessWidget {
  TextEditingController controller;
  String textName;
  bool obscureText;

  Color? color;
  double size;
  TextFailInput(
      {super.key,
      required this.controller,
      required this.textName,
      required this.obscureText,
      required this.color,
      required this.size});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        child: AutoSizeTextField(
          controller: controller,
          maxLines: 1,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: textName,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.black)),
          ),
          style: GoogleFonts.headlandOne(
              color: color, fontWeight: FontWeight.bold, fontSize: size),
        ),
      ),
    );
  }
}
