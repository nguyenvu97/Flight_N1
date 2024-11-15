import 'package:flutter/material.dart';

import 'package:flutter_application_4/home/Menu_Main_Home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        // const Locale('en', 'US'),
        const Locale('vi', 'VN'), // Hỗ trợ tiếng Việt
      ],
      home: MainTabView(),
    );
  }
}
