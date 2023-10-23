import 'dart:convert';

FilterCountryResponseModel filterCountryResponseModelFromJson(String str) =>
    FilterCountryResponseModel.fromJson(json.decode(str));

String filterCountryResponseModelToJson(FilterCountryResponseModel data) =>
    json.encode(data.toJson());

class FilterCountryResponseModel {
  FilterCountryResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory FilterCountryResponseModel.fromJson(Map<String, dynamic> json) =>
      FilterCountryResponseModel(
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
    this.countries,
  });

  List<String>? countries;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        countries: json["countries"] == null
            ? []
            : List<String>.from(json["countries"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "countries": countries == null
            ? []
            : List<dynamic>.from(countries!.map((x) => x)),
      };
}
