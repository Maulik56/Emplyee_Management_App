import 'dart:convert';

LowCrewNotificationResponseModel lowCrewNotificationResponseModelFromJson(
        String str) =>
    LowCrewNotificationResponseModel.fromJson(json.decode(str));

String lowCrewNotificationResponseModelToJson(
        LowCrewNotificationResponseModel data) =>
    json.encode(data.toJson());

class LowCrewNotificationResponseModel {
  LowCrewNotificationResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory LowCrewNotificationResponseModel.fromJson(
          Map<String, dynamic> json) =>
      LowCrewNotificationResponseModel(
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
    this.minLevels,
  });

  List<MinLevel>? minLevels;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        minLevels: json["min_levels"] == null
            ? []
            : List<MinLevel>.from(
                json["min_levels"]!.map((x) => MinLevel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "min_levels": minLevels == null
            ? []
            : List<dynamic>.from(minLevels!.map((x) => x.toJson())),
      };
}

class MinLevel {
  MinLevel({
    this.imgId,
    this.code,
    this.text,
    this.detail,
    this.value,
  });

  String? imgId;
  String? code;
  String? text;
  String? detail;
  int? value;

  factory MinLevel.fromJson(Map<String, dynamic> json) => MinLevel(
        imgId: json["img_id"],
        code: json["code"],
        text: json["text"],
        detail: json["detail"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "img_id": imgId,
        "code": code,
        "text": text,
        "detail": detail,
        "value": value,
      };
}
