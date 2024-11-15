import 'package:flutter/material.dart';
import 'package:get/get.dart';

class filter_data extends StatefulWidget {
  final String label_Text;
  final RxList<String> listData;
  final RxString value1;
  filter_data(
      {super.key,
      required this.label_Text,
      required this.listData,
      required this.value1});

  @override
  State<filter_data> createState() => _filter_dataState();
}

class _filter_dataState extends State<filter_data> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: widget.label_Text,
          border: OutlineInputBorder(),
        ),
        value: widget.value1.value,
        items: widget.listData.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            widget.value1.value = value!;
          });
        },
      ),
    );
    ;
  }
}
