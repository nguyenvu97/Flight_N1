import 'package:flutter/material.dart';



class app_bar extends StatelessWidget {
  Widget title;
  app_bar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: null,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: Colors.red,
            ))
      ],
    );
  }
}
