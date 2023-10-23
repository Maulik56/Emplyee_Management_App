import 'dart:convert';

MarkersResponseModel markersResponseModelFromJson(String str) =>
    MarkersResponseModel.fromJson(json.decode(str));

String markersResponseModelToJson(MarkersResponseModel data) =>
    json.encode(data.toJson());

class MarkersResponseModel {
  MarkersResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory MarkersResponseModel.fromJson(Map<String, dynamic> json) =>
      MarkersResponseModel(
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
    this.markers,
  });

  List<Markers>? markers;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        markers: json["markers"] == null
            ? []
            : List<Markers>.from(
                json["markers"]!.map((x) => Markers.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "markers": markers == null
            ? []
            : List<dynamic>.from(markers!.map((x) => x.toJson())),
      };
}

class Markers {
  Markers({
    this.id,
    this.title,
    this.imgId,
    this.lat,
    this.lon,
  });

  String? id;
  String? title;
  String? imgId;
  double? lat;
  double? lon;

  factory Markers.fromJson(Map<String, dynamic> json) => Markers(
        id: json["id"],
        title: json["title"],
        imgId: json["img_id"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "img_id": imgId,
        "lat": lat,
        "lon": lon,
      };
}
