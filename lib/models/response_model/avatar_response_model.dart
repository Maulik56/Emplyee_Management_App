import 'dart:convert';

AvatarResponseModel avatarResponseModelFromJson(String str) =>
    AvatarResponseModel.fromJson(json.decode(str));

String avatarResponseModelToJson(AvatarResponseModel data) =>
    json.encode(data.toJson());

class AvatarResponseModel {
  AvatarResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory AvatarResponseModel.fromJson(Map<String, dynamic> json) =>
      AvatarResponseModel(
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
    this.avatars,
  });

  List<Avatar>? avatars;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        avatars: json["avatars"] == null
            ? []
            : List<Avatar>.from(
                json["avatars"]!.map((x) => Avatar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "avatars": avatars == null
            ? []
            : List<dynamic>.from(avatars!.map((x) => x.toJson())),
      };
}

class Avatar {
  Avatar({
    this.id,
    this.text,
  });

  String? id;
  String? text;

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        id: json["id"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
      };
}
