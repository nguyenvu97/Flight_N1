import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class grid_view extends StatefulWidget {
  const grid_view({super.key});

  @override
  State<grid_view> createState() => _grid_viewState();
}

class _grid_viewState extends State<grid_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text("Du Lịch Việt Nam"),
        actions: [],
      ),
      body: MasonryGridView.builder(
        itemCount: 12,
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(2),
            child: Image.asset("assets/${index + 1}.jpeg"),
          );
        },
      ),
    );
  }
}
