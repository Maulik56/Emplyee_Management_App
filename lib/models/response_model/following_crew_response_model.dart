import 'dart:convert';

FollowingCrewResponseModel followingCrewResponseModelFromJson(String str) =>
    FollowingCrewResponseModel.fromJson(json.decode(str));

String followingCrewResponseModelToJson(FollowingCrewResponseModel data) =>
    json.encode(data.toJson());

class FollowingCrewResponseModel {
  FollowingCrewResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory FollowingCrewResponseModel.fromJson(Map<String, dynamic> json) =>
      FollowingCrewResponseModel(
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
    this.team,
  });

  List<Team>? team;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        team: json["team"] == null
            ? []
            : List<Team>.from(json["team"]!.map((x) => Team.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "team": team == null
            ? []
            : List<dynamic>.from(team!.map((x) => x.toJson())),
      };
}

class Team {
  Team({
    this.id,
    this.imageId,
    this.name,
    this.checked,
  });

  String? id;
  String? imageId;
  String? name;
  bool? checked;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["id"],
        imageId: json["image_id"],
        name: json["name"],
        checked: json["checked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_id": imageId,
        "name": name,
        "checked": checked,
      };
}
