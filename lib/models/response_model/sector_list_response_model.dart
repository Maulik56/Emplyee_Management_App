import 'dart:convert';

SectorListResponseModel sectorListResponseModelFromJson(String str) =>
    SectorListResponseModel.fromJson(json.decode(str));

String sectorListResponseModelToJson(SectorListResponseModel data) =>
    json.encode(data.toJson());

class SectorListResponseModel {
  SectorListResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory SectorListResponseModel.fromJson(Map<String, dynamic> json) =>
      SectorListResponseModel(
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
    this.sectors,
  });

  List<String>? sectors;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        sectors: json["sectors"] == null
            ? []
            : List<String>.from(json["sectors"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "sectors":
            sectors == null ? [] : List<dynamic>.from(sectors!.map((x) => x)),
      };
}
