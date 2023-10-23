import 'dart:convert';

MainScreenHeaderModel mainScreenHeaderModelFromJson(String str) =>
    MainScreenHeaderModel.fromJson(json.decode(str));

String mainScreenHeaderModelToJson(MainScreenHeaderModel data) =>
    json.encode(data.toJson());

class MainScreenHeaderModel {
  MainScreenHeaderModel({
    this.success,
    this.resource,
    this.data,
  });

  bool? success;
  String? resource;
  Data? data;

  factory MainScreenHeaderModel.fromJson(Map<String, dynamic> json) =>
      MainScreenHeaderModel(
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
    this.teamName,
    this.showAds,
    this.header,
  });

  String? teamName;
  bool? showAds;
  Header? header;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        teamName: json["team_name"],
        showAds: json["show_ads"],
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
      );

  Map<String, dynamic> toJson() => {
        "team_name": teamName,
        "show_ads": showAds,
        "header": header?.toJson(),
      };
}

class Header {
  Header({
    this.text,
    this.bgColor,
    this.textColor,
    this.button,
    this.bars,
    this.actions,
    this.team,
  });

  String? text;
  String? bgColor;
  String? textColor;
  Button? button;
  List<Bar>? bars;
  List<UserActions>? actions;
  List<Team>? team;

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        text: json["text"],
        bgColor: json["bg_color"],
        textColor: json["text_color"],
        button: json["button"] == null ? null : Button.fromJson(json["button"]),
        bars: json["bars"] == null
            ? []
            : List<Bar>.from(json["bars"]!.map((x) => Bar.fromJson(x))),
        actions: json["actions"] == null
            ? []
            : List<UserActions>.from(
                json["actions"]!.map((x) => UserActions.fromJson(x))),
        team: json["team"] == null
            ? []
            : List<Team>.from(json["team"]!.map((x) => Team.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "bg_color": bgColor,
        "text_color": textColor,
        "button": button?.toJson(),
        "bars": bars == null
            ? []
            : List<dynamic>.from(bars!.map((x) => x.toJson())),
        "actions": actions == null
            ? []
            : List<dynamic>.from(actions!.map((x) => x.toJson())),
        "team": team == null
            ? []
            : List<dynamic>.from(team!.map((x) => x.toJson())),
      };
}

class UserActions {
  UserActions({
    this.id1,
    this.text1,
  });

  String? id1;
  String? text1;

  factory UserActions.fromJson(Map<String, dynamic> json) => UserActions(
        id1: json["id"],
        text1: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id1,
        "text": text1,
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
  List<DropDowns>? dropDown;

  factory Button.fromJson(Map<String, dynamic> json) => Button(
        text: json["text"],
        dropDown: json["drop_down"] == null
            ? []
            : List<DropDowns>.from(
                json["drop_down"]!.map((x) => DropDowns.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "drop_down": dropDown == null
            ? []
            : List<dynamic>.from(dropDown!.map((x) => x.toJson())),
      };
}

class DropDowns {
  DropDowns({
    this.id,
    this.text,
  });

  String? id;
  String? text;

  factory DropDowns.fromJson(Map<String, dynamic> json) => DropDowns(
        id: json["id"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
      };
}

class Team {
  Team({
    this.firstname,
    this.surname,
    this.displayName,
    this.nameBold,
    this.detailText,
    this.imageId,
    this.imageRightId,
  });

  String? firstname;
  String? surname;
  String? displayName;
  bool? nameBold;
  DetailText? detailText;
  String? imageId;
  String? imageRightId;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        firstname: json["firstname"],
        surname: json["surname"],
        displayName: json["display_name"],
        nameBold: json["name_bold"],
        detailText: json["detail_text"] == null
            ? null
            : DetailText.fromJson(json["detail_text"]),
        imageId: json["image_id"],
        imageRightId: json["image_right_id"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "surname": surname,
        "display_name": displayName,
        "name_bold": nameBold,
        "detail_text": detailText?.toJson(),
        "image_id": imageId,
        "image_right_id": imageRightId,
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
