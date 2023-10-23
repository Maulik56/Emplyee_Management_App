import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/constant/api_const.dart';

class CreateTeamRepo {
  static Future<bool> createTeam(
      {required String teamName,
      required String country,
      required String timezone,
      required String sector}) async {
    var reqBody = json.encode({
      "name": teamName,
      "country": country,
      "timezone": timezone,
      "sector": sector
    });

    http.Response response = await http.post(
        Uri.parse(BaseUrl.baseUrl + EndPoints.createTeam),
        body: reqBody,
        headers: CommonHeader.header);
    var result = jsonDecode(response.body);
    if (kDebugMode) {
      print("Create Team Response==>>$result");
    }
    return result['success'];
  }
}
