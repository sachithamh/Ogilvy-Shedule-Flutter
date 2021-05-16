import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import './main/main_screen.dart';
import './countdown/countdown.dart';

final storage = GetStorage();

List<GetPage> route = [
  GetPage(
    name: '/',
    page: () => MainScreen(),
  ),
  GetPage(
    name: '/countdown',
    page: ()=> CountDown(),
    ) 
];