import 'dart:convert';

EventsResponseModel eventsResponseModelFromJson(String str) =>
    EventsResponseModel.fromJson(json.decode(str));

String eventsResponseModelToJson(EventsResponseModel data) =>
    json.encode(data.toJson());

class EventsResponseModel {
  EventsResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory EventsResponseModel.fromJson(Map<String, dynamic> json) =>
      EventsResponseModel(
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

  List<Event>? events;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        events: json["events"] == null
            ? []
            : List<Event>.from(json["events"]!.map((x) => Event.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "events": events == null
            ? []
            : List<dynamic>.from(events!.map((x) => x.toJson())),
      };
}

class Event {
  Event(
      {this.timeStart,
      this.timeFinish,
      this.title,
      this.description,
      this.location,
      this.id});

  DateTime? timeStart;
  DateTime? timeFinish;
  String? title;
  String? description;
  String? location;
  String? id;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        timeStart: json["time_start"] == null
            ? null
            : DateTime.parse(json["time_start"]),
        timeFinish: json["time_finish"] == null
            ? null
            : DateTime.parse(json["time_finish"]),
        title: json["title"],
        description: json["description"],
        location: json["location"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "time_start": timeStart?.toIso8601String(),
        "time_finish": timeFinish?.toIso8601String(),
        "title": title,
        "description": description,
        "location": location,
        "id": id,
      };
}
