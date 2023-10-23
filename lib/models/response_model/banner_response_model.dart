import 'dart:convert';

BannerResponseModel bannerResponseModelFromJson(String str) =>
    BannerResponseModel.fromJson(json.decode(str));

String bannerResponseModelToJson(BannerResponseModel data) =>
    json.encode(data.toJson());

class BannerResponseModel {
  BannerResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory BannerResponseModel.fromJson(Map<String, dynamic> json) =>
      BannerResponseModel(
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
    this.visible,
    this.background,
    this.fontColor,
    this.imageId,
    this.text,
    this.button,
  });

  bool? visible;
  String? background;
  String? fontColor;
  String? imageId;
  String? text;
  Button? button;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        visible: json["visible"],
        background: json["background"],
        fontColor: json["font-color"],
        imageId: json["image_id"],
        text: json["text"],
        button: json["button"] == null ? null : Button.fromJson(json["button"]),
      );

  Map<String, dynamic> toJson() => {
        "visible": visible,
        "background": background,
        "font-color": fontColor,
        "image_id": imageId,
        "text": text,
        "button": button?.toJson(),
      };
}

class Button {
  Button({
    this.text,
    this.action,
    this.url,
  });

  String? text;
  String? action;
  String? url;

  factory Button.fromJson(Map<String, dynamic> json) => Button(
        text: json["text"],
        action: json["action"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "action": action,
        "url": url,
      };
}
