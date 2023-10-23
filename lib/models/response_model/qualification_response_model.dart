import 'dart:convert';

QualificationResponseModel qualificationResponseModelFromJson(String str) =>
    QualificationResponseModel.fromJson(json.decode(str));

String qualificationResponseModelToJson(QualificationResponseModel data) =>
    json.encode(data.toJson());

class QualificationResponseModel {
  QualificationResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory QualificationResponseModel.fromJson(Map<String, dynamic> json) =>
      QualificationResponseModel(
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
    this.qualifications,
  });

  List<Qualification>? qualifications;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        qualifications: json["qualifications"] == null
            ? []
            : List<Qualification>.from(
                json["qualifications"]!.map((x) => Qualification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "qualifications": qualifications == null
            ? []
            : List<dynamic>.from(qualifications!.map((x) => x.toJson())),
      };
}

class Qualification {
  Qualification({
    this.id,
    this.imgId,
    this.text,
  });

  String? id;
  String? imgId;
  String? text;

  factory Qualification.fromJson(Map<String, dynamic> json) => Qualification(
        id: json["id"],
        imgId: json["img_id"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "img_id": imgId,
        "text": text,
      };
}
