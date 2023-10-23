import 'dart:convert';

GeofenceResponseModel geofenceResponseModelFromJson(String str) =>
    GeofenceResponseModel.fromJson(json.decode(str));

String geofenceResponseModelToJson(GeofenceResponseModel data) =>
    json.encode(data.toJson());

class GeofenceResponseModel {
  GeofenceResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory GeofenceResponseModel.fromJson(Map<String, dynamic> json) =>
      GeofenceResponseModel(
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
    this.enabled,
    this.lat,
    this.lon,
    this.geofences,
  });

  bool? enabled;
  double? lat;
  double? lon;
  List<Geofences>? geofences;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        enabled: json["enabled"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        geofences: json["geofences"] == null
            ? []
            : List<Geofences>.from(
                json["geofences"]!.map((x) => Geofences.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "lat": lat,
        "lon": lon,
        "geofences": geofences == null
            ? []
            : List<dynamic>.from(geofences!.map((x) => x.toJson())),
      };
}

class Geofences {
  Geofences({
    this.id,
    this.radius,
    this.radiusText,
  });

  String? id;
  int? radius;
  String? radiusText;

  factory Geofences.fromJson(Map<String, dynamic> json) => Geofences(
        id: json["id"],
        radius: json["radius"],
        radiusText: json["radius_text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "radius": radius,
        "radius_text": radiusText,
      };
}
