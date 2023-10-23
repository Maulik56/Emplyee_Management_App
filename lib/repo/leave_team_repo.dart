import 'dart:convert';
import 'package:news_app/constant/api_const.dart';
import 'package:http/http.dart' as http;

class LeaveTeamRepo {
  static Future leaveTeam() async {
    http.Response response = await http.post(
        Uri.parse(BaseUrl.baseUrl + EndPoints.leaveTeam),
        headers: CommonHeader.header);
    var result = jsonDecode(response.body);
    print("LEAVE TEAM==>$result");
    return result['success'];
  }
}
