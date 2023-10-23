import 'dart:convert';

GetTimeZoneListResponseModel getTimeZoneListResponseModelFromJson(String str) =>
    GetTimeZoneListResponseModel.fromJson(json.decode(str));

String getTimeZoneListResponseModelToJson(GetTimeZoneListResponseModel data) =>
    json.encode(data.toJson());

class GetTimeZoneListResponseModel {
  GetTimeZoneListResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory GetTimeZoneListResponseModel.fromJson(Map<String, dynamic> json) =>
      GetTimeZoneListResponseModel(
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
    this.timezones,
  });

  List<Timezone>? timezones;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        timezones: json["timezones"] == null
            ? []
            : List<Timezone>.from(
                json["timezones"]!.map((x) => Timezone.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "timezones": timezones == null
            ? []
            : List<dynamic>.from(timezones!.map((x) => x.toJson())),
      };
}

class Timezone {
  Timezone({
    this.name,
    this.displayName,
  });

  String? name;
  String? displayName;

  factory Timezone.fromJson(Map<String, dynamic> json) => Timezone(
        name: json["name"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "display_name": displayName,
      };
}
