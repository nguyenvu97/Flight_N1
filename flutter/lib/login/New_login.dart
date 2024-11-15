import 'package:flutter/material.dart';
import 'package:flutter_application_4/common/Box_Container/New_Box.dart';
import 'package:flutter_application_4/common/Check_Anything.dart';
import 'package:flutter_application_4/common/Text_Data.dart';
import 'package:flutter_application_4/common/Text_Input.dart';
import 'package:flutter_application_4/login/Resgister_Page.dart';

import 'package:flutter_application_4/home/Home_page.dart';
import 'package:flutter_application_4/sevice_api/gex_controller/Login_Get_Controller.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class newLogin extends StatefulWidget {
  const newLogin({super.key});

  @override
  State<newLogin> createState() => _newLoginState();
}

Login_Getx_Controller loginController = Get.put(Login_Getx_Controller());
bool _isobscureText = true;

class _newLoginState extends State<newLogin> {
  CheckAnything checker = CheckAnything();

  Future<bool?> checkPassword() async {
    bool? isPasswordValid =
        await checker.CheckPassword(loginController.passWorld.text);
    if (isPasswordValid != null && isPasswordValid) {
      return true;
    } else {
      final snackBar = SnackBar(
        content: Text('You entered the wrong Password format'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

// Gọi phương thức kiểm tra độ dài của chuỗi bất kỳ
  Future<bool?> CheckEmail() async {
    bool? isLengthValid = await checker.checkEmail(loginController.email.text);
    if (isLengthValid != null && isLengthValid) {
      return true;
    } else {
      final snackBar = SnackBar(
        content: Text('You entered the wrong email format'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _onLoginPressed() async {
    // bool? isEmailValid = await CheckEmail();
    // bool? isPasswordValid = await checkPassword();

    // if (isEmailValid != null &&
    //     isEmailValid &&
    //     isPasswordValid != null &&
    //     isPasswordValid) {
    bool? loginSuccess = await loginController.login();

    if (loginSuccess!) {
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Please check your email and password.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
    // }
  }

  // check Email VS password

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: media.width,
            height: media.height,
            child: Image.network(
              "https://images.unsplash.com/photo-1532920161727-344adb090f7f?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YmFtYm9vfGVufDB8fDB8fHww",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  title: Image.asset(
                    "assets/Logo2.png",
                    color: Colors.white,
                    width: 100,
                    height: 50,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "X",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                  leading: Container(
                    height: 50,
                    width: 50,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                  ),
                ),
                SizedBox(
                  height: media.height * 0.3,
                ),
                Container(
                  height: media.height * 0.5,
                  width: media.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey.shade300),
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        padding: EdgeInsets.all(8),
                        width: media.width * 0.8,
                        child: NewBox(
                            child: Text_Data(
                          name: "Login",
                          color: Colors.blue,
                          size: 20,
                          maxLine: 1,
                        )),
                      ),
                      Container(
                        height: 80,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: NewBox(
                          child: TextFailInput(
                            textName: "Email",
                            controller: loginController.email,
                            obscureText: !_isobscureText,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 80,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: NewBox(
                          child: TextFailInput(
                            textName: "Password",
                            controller: loginController.passWorld,
                            obscureText: _isobscureText,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _onLoginPressed();
                            });
                          },
                          child: Container(
                            height: media.height * 0.07,
                            width: media.width,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(40)),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: media.height * 0.02,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: media.height * 0.04,
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  "For Get PassWorld??",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResgisterPage()));
                              },
                              child: Container(
                                height: media.height * 0.04,
                                margin: EdgeInsets.only(right: 10),
                                child: Text(
                                  "Resgitser",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ]),
                      Container(
                        height: media.height * 0.05,
                        width: media.width * 0.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: media.height * 0.04,
                                child: Icon(
                                  Icons.facebook_rounded,
                                  size: 45,
                                  color:
                                      const Color.fromARGB(255, 64, 167, 251),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: media.height * 0.04,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://cdn-icons-png.freepik.com/512/2875/2875331.png"))),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: media.height * 0.04,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/Apple_Computer_Logo_rainbow.svg/514px-Apple_Computer_Logo_rainbow.svg.png"))),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
