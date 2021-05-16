import 'package:http/http.dart' as http;
import './../models/schedule.dart';

class RemoteServices {
  static var client = http.Client();

  static Future<List<Schedule>> fetchSearchResults() async {
    var response = await client.get(
      'http://192.168.1.104:80/api/schedules',
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      return parseSchedules(jsonString);
    } else
      return null;
  }
}
