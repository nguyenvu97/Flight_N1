import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  var _showContainer = false;
  void _onDataReceived(String data) {
    if (data == "data") {
      setState(() {
        _showContainer =
            (data == "data"); // Cập nhật trạng thái để hiển thị container
      });
    } else {
      setState(() {
        _showContainer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: Text("Parent Widget")),
        body: Column(
          children: [
            if (_showContainer)
              AnimatedOpacity(
                opacity: _showContainer ? 1 : 0,
                duration: const Duration(microseconds: 200),
                curve: Curves.bounceInOut,
                child: Container(
                    color: Colors.amber, child: Text("Container hiển thị!")),
              ),
            ChildWidget(onDataSend: _onDataReceived),
            GestureDetector(
              onTap: () {},
              child: const SizedBox(
                child: Text("new page"),
              ),
            )
          ],
        ));
  }
}

class ChildWidget extends StatelessWidget {
  final Function(String) onDataSend;

  const ChildWidget({Key? key, required this.onDataSend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            onDataSend("data");
          },
          child: Text("Send Data"),
        ),
        ElevatedButton(
          onPressed: () {
            onDataSend("data1111");
          },
          child: Text("off container"),
        ),
      ],
    );
  }
}

class new_data extends StatelessWidget {
  const new_data({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: media.height * 1,
        width: media.width * 1,
        color: Colors.black,
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ParentWidget(),
    );
  }
}
