import 'dart:convert';

StatusResponseModel statusResponseModelFromJson(String str) =>
    StatusResponseModel.fromJson(json.decode(str));

String statusResponseModelToJson(StatusResponseModel data) =>
    json.encode(data.toJson());

class StatusResponseModel {
  StatusResponseModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory StatusResponseModel.fromJson(Map<String, dynamic> json) =>
      StatusResponseModel(
        success: json["success"],
        resource: json["resource"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "resource": resource,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.teamName,
    this.showAds,
    this.header,
    this.md5Hash,
  });

  String? teamName;
  bool? showAds;
  Header? header;
  String? md5Hash;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        teamName: json["team_name"],
        showAds: json["show_ads"],
        header: Header.fromJson(json["header"]),
        md5Hash: json["md5_hash"],
      );

  Map<String, dynamic> toJson() => {
        "team_name": teamName,
        "show_ads": showAds,
        "header": header!.toJson(),
        "md5_hash": md5Hash,
      };
}

class Header {
  Header({
    this.text,
    this.bgColor,
    this.textColor,
    this.button,
    this.bars,
    this.team,
  });

  String? text;
  String? bgColor;
  String? textColor;
  Button? button;
  List<Bar>? bars;
  List<Team>? team;

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        text: json["text"],
        bgColor: json["bg_color"],
        textColor: json["text_color"],
        button: Button.fromJson(json["button"]),
        bars: List<Bar>.from(json["bars"].map((x) => Bar.fromJson(x))),
        team: List<Team>.from(json["team"].map((x) => Team.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "bg_color": bgColor,
        "text_color": textColor,
        "button": button!.toJson(),
        "bars": List<dynamic>.from(bars!.map((x) => x.toJson())),
        "team": List<dynamic>.from(team!.map((x) => x.toJson())),
      };
}

class Bar {
  Bar({
    this.text,
    this.color,
    this.pos,
    this.max,
  });

  String? text;
  String? color;
  int? pos;
  int? max;

  factory Bar.fromJson(Map<String, dynamic> json) => Bar(
        text: json["text"],
        color: json["color"],
        pos: json["pos"],
        max: json["max"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "color": color,
        "pos": pos,
        "max": max,
      };
}

class Button {
  Button({
    this.text,
    this.dropDown,
  });

  String? text;
  List<DropDown>? dropDown;

  factory Button.fromJson(Map<String, dynamic> json) => Button(
        text: json["text"],
        dropDown: List<DropDown>.from(
            json["drop_down"].map((x) => DropDown.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "drop_down": List<dynamic>.from(dropDown!.map((x) => x.toJson())),
      };
}

class DropDown {
  DropDown({
    this.id,
    this.text,
  });

  String? id;
  String? text;

  factory DropDown.fromJson(Map<String, dynamic> json) => DropDown(
        id: json["id"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
      };
}

class Team {
  Team(
      {this.firstname,
      this.surname,
      this.displayName,
      this.imageId,
      this.imageRightId,
      this.nameBold,
      this.id,
      this.detailText,
      this.icons});

  String? firstname;
  String? surname;
  String? displayName;
  String? imageId;
  String? imageRightId;
  bool? nameBold;
  String? id;
  DetailText? detailText;
  List<String>? icons;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        firstname: json["firstname"],
        surname: json["surname"],
        displayName: json["display_name"],
        imageId: json["image_id"],
        imageRightId: json["image_right_id"],
        nameBold: json["name_bold"],
        id: json["id"],
        icons: json["icons"] == null
            ? []
            : List<String>.from(json["icons"]!.map((x) => x)),
        detailText: json["detail_text"] == null
            ? null
            : DetailText.fromJson(
                json["detail_text"],
              ),
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "surname": surname,
        "display_name": displayName,
        "image_id": imageId,
        "image_right_id": imageRightId,
        "name_bold": nameBold,
        "id": id,
        "detail_text": detailText?.toJson(),
        "icons": icons == null ? [] : List<dynamic>.from(icons!.map((x) => x)),
      };
}

class DetailText {
  DetailText({
    this.color,
    this.text,
  });

  String? color;
  String? text;

  factory DetailText.fromJson(Map<String, dynamic> json) => DetailText(
        color: json["color"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "color": color,
        "text": text,
      };
}
