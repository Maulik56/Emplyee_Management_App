import 'dart:convert';

UserDetailResponseModel userDetailResponseModelFromJson(String str) =>
    UserDetailResponseModel.fromJson(json.decode(str));

String userDetailResponseModelToJson(UserDetailResponseModel data) =>
    json.encode(data.toJson());

class UserDetailResponseModel {
  UserDetailResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory UserDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      UserDetailResponseModel(
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
    this.id,
    this.firstName,
    this.lastName,
    this.displayName,
    this.mobile,
    this.email,
    this.available,
    this.imageId,
    this.role,
    this.qualifications,
  });

  String? id;
  String? firstName;
  String? lastName;
  String? displayName;
  String? mobile;
  String? email;
  bool? available;
  String? imageId;
  String? role;
  String? qualifications;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        displayName: json["display_name"],
        mobile: json["mobile"],
        email: json["email"],
        available: json["available"],
        imageId: json["image_id"],
        role: json["role"],
        qualifications: json["qualifications"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "display_name": displayName,
        "mobile": mobile,
        "email": email,
        "available": available,
        "image_id": imageId,
        "role": role,
        "qualifications": qualifications,
      };
}
