import 'dart:convert';

List<Schedule> parseSchedules(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Schedule>((json) => Schedule.fromJson(json)).toList();
}
Schedule parseSchedule(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Schedule>((json) => Schedule.fromJson(json));
}

class Schedule {
  Schedule({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.scheduleDatetime,
  });

  int id;
  String title;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime scheduleDatetime;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"].toInt(),
        title: json["title"],
        createdAt: DateTime.parse(json['created_at'].toString()),
        updatedAt: DateTime.parse(json['updated_at'].toString()),
        scheduleDatetime: DateTime.parse(json['schedule_datetime'].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "schedule_datetime": scheduleDatetime,
      };
}
