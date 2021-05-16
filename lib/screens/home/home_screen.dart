import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './../../controllers/schedule_controller.dart';
import './../../models/schedule.dart';
import './../../Util/LocalNotification.dart';
import 'package:flutter_pusher/pusher.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //controller
  final searchController = Get.put(ScheduleController());
  //socket
  Event lastEvent;
  String lastConnectionState;
  Channel channel;

  @override
  void initState() {
    super.initState();
   initPusher();
  }
  Future<void> initPusher() async {
    try {
      await Pusher.init(
          "89a83fa2479e870e611f",
          PusherOptions(
            cluster: "ap2"
          ),
          enableLogging: true);
    } on PlatformException catch (e) {
      print(e.message);
    }
     
    channel = await Pusher.subscribe("schedule-events");
    await channel.bind("server.task", (x) {
      print("out:${x.data}");
      var out = jsonDecode(x.data)["schedule"];
      Schedule schedule =    Schedule.fromJson(out);          
      searchController.updateValue(schedule);
     });
     Pusher.connect(onConnectionStateChange: (x) async {
                      if (mounted)
                        setState(() {
                          lastConnectionState = x.currentState;
                        });
                    }, onError: (x) {
                      debugPrint("Error: ${x.message}");
                    });                          
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Obx(
          () => ListView.builder(
            itemCount: searchController.listResult.length,
            itemBuilder: (context, index) {
              Schedule schedule = searchController.listResult[index];
              LocalNotification.sheard.sheduledNotification(
                  schedule.id, DateTime.now(), schedule.title, "Time over.");
              return GestureDetector(
                onTap: () => {Get.toNamed("/countdown", arguments: schedule)},
                child: Card(
                  child: Container(
                      padding: EdgeInsets.all(32),
                      child: Row(
                        children: [
                          Expanded(child: Text(schedule.title)),
                          Text(DateFormat('yyyy,MMMM dd – hh:mm a').format(schedule.scheduleDatetime)),
                          SizedBox(width: 8,),
                          Icon(Icons.arrow_forward)
                        ],
                      )),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
