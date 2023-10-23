import 'dart:convert';

EventsDetailResponseModel eventsDetailResponseModelFromJson(String str) =>
    EventsDetailResponseModel.fromJson(json.decode(str));

String eventsDetailResponseModelToJson(EventsDetailResponseModel data) =>
    json.encode(data.toJson());

class EventsDetailResponseModel {
  EventsDetailResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory EventsDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      EventsDetailResponseModel(
        success: json["success"],
        resource: json["resource"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "resource": resource,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.events,
  });

  List<Events>? events;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        events: json["events"] == null
            ? []
            : List<Events>.from(json["events"]!.map((x) => Events.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "events": events == null
            ? []
            : List<dynamic>.from(events!.map((x) => x.toJson())),
      };
}

class Events {
  Events(
      {this.timeStart,
      this.timeFinish,
      this.title,
      this.duration,
      this.description,
      this.location,
      this.id});

  DateTime? timeStart;
  DateTime? timeFinish;
  String? title;
  String? duration;
  String? description;
  String? location;
  String? id;

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        timeStart: json["time_start"] == null
            ? null
            : DateTime.parse(json["time_start"]),
        timeFinish: json["time_finish"] == null
            ? null
            : DateTime.parse(json["time_finish"]),
        title: json["title"],
        duration: json["duration"],
        description: json["description"],
        location: json["location"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "time_start": timeStart?.toIso8601String(),
        "time_finish": timeFinish?.toIso8601String(),
        "title": title,
        "duration": duration,
        "description": description,
        "location": location,
        "id": id,
      };
}
