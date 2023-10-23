import 'dart:convert';

ResourceCategoryResponseModel resourceCategoryResponseModelFromJson(
        String str) =>
    ResourceCategoryResponseModel.fromJson(json.decode(str));

String resourceCategoryResponseModelToJson(
        ResourceCategoryResponseModel data) =>
    json.encode(data.toJson());

class ResourceCategoryResponseModel {
  ResourceCategoryResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory ResourceCategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      ResourceCategoryResponseModel(
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
    this.category,
  });

  List<String>? category;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        category: json["category"] == null
            ? []
            : List<String>.from(json["category"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "category":
            category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
      };
}
