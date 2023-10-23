import 'dart:convert';

RoleResponseModel roleResponseModelFromJson(String str) =>
    RoleResponseModel.fromJson(json.decode(str));

String roleResponseModelToJson(RoleResponseModel data) =>
    json.encode(data.toJson());

class RoleResponseModel {
  RoleResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory RoleResponseModel.fromJson(Map<String, dynamic> json) =>
      RoleResponseModel(
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
    this.roles,
  });

  List<String>? roles;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        roles: json["roles"] == null
            ? []
            : List<String>.from(json["roles"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
      };
}
