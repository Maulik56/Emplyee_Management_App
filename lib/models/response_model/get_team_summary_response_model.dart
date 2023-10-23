import 'dart:convert';

GetTeamSummaryResponseModel getTeamSummaryResponseModelFromJson(String str) =>
    GetTeamSummaryResponseModel.fromJson(json.decode(str));

String getTeamSummaryResponseModelToJson(GetTeamSummaryResponseModel data) =>
    json.encode(data.toJson());

class GetTeamSummaryResponseModel {
  bool? success;
  String? resource;
  Data? data;

  GetTeamSummaryResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  factory GetTeamSummaryResponseModel.fromJson(Map<String, dynamic> json) =>
      GetTeamSummaryResponseModel(
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
  DateTime? date;
  List<Color>? colors;
  List<Summary>? summary;

  Data({
    this.date,
    this.colors,
    this.summary,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        colors: json["colors"] == null
            ? []
            : List<Color>.from(json["colors"]!.map((x) => Color.fromJson(x))),
        summary: json["summary"] == null
            ? []
            : List<Summary>.from(
                json["summary"]!.map((x) => Summary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date?.toIso8601String(),
        "colors": colors == null
            ? []
            : List<dynamic>.from(colors!.map((x) => x.toJson())),
        "summary": summary == null
            ? []
            : List<dynamic>.from(summary!.map((x) => x.toJson())),
      };
}

class Color {
  String? name;
  String? char;
  String? color;

  Color({
    this.name,
    this.char,
    this.color,
  });

  factory Color.fromJson(Map<String, dynamic> json) => Color(
        name: json["name"],
        char: json["char"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "char": char,
        "color": color,
      };
}

class Summary {
  String? name;
  String? hours;

  Summary({
    this.name,
    this.hours,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        name: json["name"],
        hours: json["hours"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "hours": hours,
      };
}
