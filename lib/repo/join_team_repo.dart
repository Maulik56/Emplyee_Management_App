import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/api_const.dart';

class JoinTeamRepo {
  static Future<bool> joinTeam({required inviteCode}) async {
    http.Response response = await http.post(
        Uri.parse(
          BaseUrl.baseUrl + EndPoints.joinTeam + inviteCode,
        ),
        headers: CommonHeader.header);
    var result = jsonDecode(response.body);
    return result['success'];
  }
}
