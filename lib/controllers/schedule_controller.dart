import 'dart:developer';
import 'package:get/get.dart';
import './../models/schedule.dart';
import './../services/remote_services.dart';
class ScheduleController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<Schedule> listResult = <Schedule>[].obs;

  @override
  void onInit() {
    fetchResults();
    super.onInit();
  }

  void fetchResults() async {
    try {
      isLoading(true);

      listResult.value =
          await RemoteServices.fetchSearchResults();
      log("data");    
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading(false);
    }

  }

   void updateValue(Schedule schedule){
     int index = listResult.indexWhere((element) => element.id == schedule.id);
     if(index >= 0){
        listResult[index] = schedule;
     }else{
       listResult.add(schedule);
     }
   }
}