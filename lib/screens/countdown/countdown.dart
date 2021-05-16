
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import './../../models/schedule.dart';
import 'package:get/get.dart';
import 'package:flutter_countdown_timer/index.dart';
import './../../Util/LocalNotification.dart';

class CountDown extends StatefulWidget {
  CountDown({Key key}) : super(key: key);

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  CountdownTimerController controller;
  Schedule schedule = Get.arguments;
  int endTime = 0;
  @override
  void initState() {
    super.initState();
    endTime = schedule.scheduleDatetime.millisecondsSinceEpoch;
    print(endTime);
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
  }

  void onEnd() {
    print("End count");
    var nowTimw = DateTime.now();
    var sheduletime =  schedule.scheduleDatetime;
    print("End count:${sheduletime.difference(nowTimw).inSeconds}");
    if (sheduletime.difference(nowTimw).inSeconds >= -1){
         LocalNotification.sheard.showNotification(schedule.title, "Time over.");
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(schedule.title),
      ),
      body: Container(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CountdownTimer(
                onEnd: onEnd,
                endTime: endTime,
                widgetBuilder: (_, CurrentRemainingTime time) {
                  if (time == null) {
                    return Text('Countdown over',
                        style: TextStyle(
                          fontSize: 25,
                        ));
                  }
                  return Text(
                      'days: ${time.days ?? 0} hours: ${time.hours ?? 0} min:  ${time.min ?? 0}  sec:  ${time.sec ?? 0} ',
                      style: TextStyle(
                        fontSize: 25,
                      ));
                },
              ),
              Text(DateFormat('yyyy,MMMM dd – hh:mm a').format(schedule.scheduleDatetime))
            ],
          ),
        ),
      ),
    );
  }
}
