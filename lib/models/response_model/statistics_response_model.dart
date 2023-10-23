// To parse this JSON data, do
//
//     final statisticsResponseModel = statisticsResponseModelFromJson(jsonString);

import 'dart:convert';

StatisticsResponseModel statisticsResponseModelFromJson(String str) =>
    StatisticsResponseModel.fromJson(json.decode(str));

String statisticsResponseModelToJson(StatisticsResponseModel data) =>
    json.encode(data.toJson());

class StatisticsResponseModel {
  bool? success;
  String? resource;
  Data? data;

  StatisticsResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  factory StatisticsResponseModel.fromJson(Map<String, dynamic> json) =>
      StatisticsResponseModel(
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
  bool? showHistory;
  String? thisWeekTitle;
  List<Week>? thisWeek;
  List<Week>? prevWeeks;

  Data({
    this.showHistory,
    this.thisWeekTitle,
    this.thisWeek,
    this.prevWeeks,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        showHistory: json["show_history"],
        thisWeekTitle: json["this_week_title"],
        thisWeek: json["this_week"] == null
            ? []
            : List<Week>.from(json["this_week"]!.map((x) => Week.fromJson(x))),
        prevWeeks: json["prev_weeks"] == null
            ? []
            : List<Week>.from(json["prev_weeks"]!.map((x) => Week.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "show_history": showHistory,
        "this_week_title": thisWeekTitle,
        "this_week": thisWeek == null
            ? []
            : List<dynamic>.from(thisWeek!.map((x) => x.toJson())),
        "prev_weeks": prevWeeks == null
            ? []
            : List<dynamic>.from(prevWeeks!.map((x) => x.toJson())),
      };
}

class Week {
  String? label;
  dynamic value;

  Week({
    this.label,
    this.value,
  });

  factory Week.fromJson(Map<String, dynamic> json) => Week(
        label: json["label"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}
