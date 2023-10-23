import 'dart:convert';

AlertListResponseModel alertListResponseModelFromJson(String str) =>
    AlertListResponseModel.fromJson(json.decode(str));

String alertListResponseModelToJson(AlertListResponseModel data) =>
    json.encode(data.toJson());

class AlertListResponseModel {
  AlertListResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory AlertListResponseModel.fromJson(Map<String, dynamic> json) =>
      AlertListResponseModel(
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
    this.items,
  });

  List<Item>? items;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.type,
    this.title,
    this.id,
    this.imgId,
    this.subTitle,
    this.enabled,
    this.message,
  });

  String? type;
  String? title;
  String? id;
  String? imgId;
  String? subTitle;
  bool? enabled;
  String? message;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        type: json["type"],
        title: json["title"],
        id: json["id"],
        imgId: json["img_id"],
        subTitle: json["sub_title"],
        enabled: json["enabled"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
        "id": id,
        "img_id": imgId,
        "sub_title": subTitle,
        "enabled": enabled,
        "message": message,
      };
}
