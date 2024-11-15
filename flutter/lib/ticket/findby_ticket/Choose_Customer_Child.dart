import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/Box_Container/New_Box.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Ticket_Getx.Controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ChooseBigUserAndKiss extends StatefulWidget {
  const ChooseBigUserAndKiss({super.key});

  @override
  State<ChooseBigUserAndKiss> createState() => _ChooseBigUserAndKissState();
}

Ticket_Getx_Controller ticket_controller = Get.put(Ticket_Getx_Controller());

class _ChooseBigUserAndKissState extends State<ChooseBigUserAndKiss> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      child: IconButton(
        onPressed: () {
          showModalBottomSheet(
            isDismissible: true,
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.white,
            builder: (BuildContext context) {
              return Container(
                height: media.height * 0.2,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final List<MapEntry<int, String>> items =
                        ticket_controller.userType.entries.toList();
                    final MapEntry<int, String> entry = items[index];
                    int key1 = entry.key;
                    String value = entry.value;

                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(
                            context); // Đóng BottomSheet và trả về giá trị của chuyến bay
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            padding: EdgeInsets.all(15),
                            child: NewBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 100,
                                    child: Text(
                                      key1.toString(),
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                 const SizedBox(width: 10),
                                  SizedBox(
                                    height: 100,
                                    width: 200,
                                    child: Text(
                                      value,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              ticket_controller.removeUserType(
                                                  entry.key, context);
                                            },
                                            child: Container( 
                                              child:  Icon(Icons.remove),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Expanded(
                                        //     child: Center(
                                        //   child: Container(
                                        //     child: Text_Data(
                                        //         name: ticket_controller.customer[entry.key].value

                                        //         color: Colors.black,
                                        //         size: 15),
                                        //   ),
                                        // )),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              ticket_controller
                                                  .updateUserType(entry.key);
                                            },
                                            child: Container(
                                              child: Icon(Icons.add),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: ticket_controller.userType.length,
                ),
              );
            },
          );
        },
        icon:const Icon(Icons.arrow_drop_down),
      ),
    );
    ;
  }
}
