import 'dart:convert';

AutoBookOnResponseModel autoBookOnResponseModelFromJson(String str) =>
    AutoBookOnResponseModel.fromJson(json.decode(str));

String autoBookOnResponseModelToJson(AutoBookOnResponseModel data) =>
    json.encode(data.toJson());

class AutoBookOnResponseModel {
  AutoBookOnResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory AutoBookOnResponseModel.fromJson(Map<String, dynamic> json) =>
      AutoBookOnResponseModel(
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
    this.categories,
    this.items,
  });

  List<Category>? categories;
  Items? items;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
        items: json["items"] == null ? null : Items.fromJson(json["items"]),
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "items": items?.toJson(),
      };
}

class Category {
  Category({
    this.id,
    this.text,
  });

  String? id;
  String? text;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
      };
}

class Items {
  Items({
    this.time,
    this.duration,
  });

  List<Duration>? time;
  List<Duration>? duration;

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        time: json["TIME"] == null
            ? []
            : List<Duration>.from(
                json["TIME"]!.map((x) => Duration.fromJson(x))),
        duration: json["DURATION"] == null
            ? []
            : List<Duration>.from(
                json["DURATION"]!.map((x) => Duration.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TIME": time == null
            ? []
            : List<dynamic>.from(time!.map((x) => x.toJson())),
        "DURATION": duration == null
            ? []
            : List<dynamic>.from(duration!.map((x) => x.toJson())),
      };
}

class Duration {
  Duration({
    this.id,
    this.imageId,
    this.fontColor,
    this.value,
    this.text,
  });

  String? id;
  String? imageId;
  String? fontColor;
  String? value;
  String? text;

  factory Duration.fromJson(Map<String, dynamic> json) => Duration(
        id: json["id"],
        imageId: json["image_id"],
        fontColor: json["font_color"],
        value: json["value"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_id": imageId,
        "font_color": fontColor,
        "value": value,
        "text": text,
      };
}
