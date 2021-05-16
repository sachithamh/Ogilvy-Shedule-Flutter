import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import './screens/route.dart';
void main() {
  GetStorage.init();

  runApp(SchedulApp());
}

class SchedulApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Schedul',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'poppins',
      ),
      initialRoute: '/',
      getPages: route,
    );
  }
}