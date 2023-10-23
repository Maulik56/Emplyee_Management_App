import 'dart:convert';

GetInviteCodeResponseModel getInviteCodeResponseModelFromJson(String str) =>
    GetInviteCodeResponseModel.fromJson(json.decode(str));

String getInviteCodeResponseModelToJson(GetInviteCodeResponseModel data) =>
    json.encode(data.toJson());

class GetInviteCodeResponseModel {
  GetInviteCodeResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory GetInviteCodeResponseModel.fromJson(Map<String, dynamic> json) =>
      GetInviteCodeResponseModel(
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
    this.inviteCode,
    this.inviteText,
  });

  String? inviteCode;
  String? inviteText;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        inviteCode: json["inviteCode"],
        inviteText: json["inviteText"],
      );

  Map<String, dynamic> toJson() => {
        "inviteCode": inviteCode,
        "inviteText": inviteText,
      };
}
