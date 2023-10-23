import 'dart:convert';

GetChatListResponseModel getChatListResponseModelFromJson(String str) =>
    GetChatListResponseModel.fromJson(json.decode(str));

String getChatListResponseModelToJson(GetChatListResponseModel data) =>
    json.encode(data.toJson());

class GetChatListResponseModel {
  GetChatListResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory GetChatListResponseModel.fromJson(Map<String, dynamic> json) =>
      GetChatListResponseModel(
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
    this.messages,
  });

  List<Message>? messages;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        messages: json["messages"] == null
            ? []
            : List<Message>.from(
                json["messages"]!.map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "messages": messages == null
            ? []
            : List<dynamic>.from(messages!.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    this.id,
    this.imgId,
    this.type,
    this.data,
    this.name,
    this.created,
    this.you,
  });

  String? id;
  String? imgId;
  String? type;
  String? data;
  String? name;
  DateTime? created;
  bool? you;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        imgId: json["img_id"],
        type: json["type"],
        data: json["data"],
        name: json["name"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        you: json["you"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "img_id": imgId,
        "type": type,
        "data": data,
        "name": name,
        "created": created?.toIso8601String(),
        "you": you,
      };
}
