import 'dart:convert';

ParticularEventDetailResponseModel particularEventDetailResponseModelFromJson(
        String str) =>
    ParticularEventDetailResponseModel.fromJson(json.decode(str));

String particularEventDetailResponseModelToJson(
        ParticularEventDetailResponseModel data) =>
    json.encode(data.toJson());

class ParticularEventDetailResponseModel {
  ParticularEventDetailResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory ParticularEventDetailResponseModel.fromJson(
          Map<String, dynamic> json) =>
      ParticularEventDetailResponseModel(
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
    this.id,
    this.title,
    this.startTime,
    this.finishTime,
    this.personal,
  });

  String? id;
  String? title;
  DateTime? startTime;
  DateTime? finishTime;
  bool? personal;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        finishTime: json["finish_time"] == null
            ? null
            : DateTime.parse(json["finish_time"]),
        personal: json["personal"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "start_time": startTime?.toIso8601String(),
        "finish_time": finishTime?.toIso8601String(),
        "personal": personal,
      };
}
