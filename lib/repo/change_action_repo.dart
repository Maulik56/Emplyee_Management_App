import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import 'package:http/http.dart' as http;

class ChangeActionRepo {
  static Future changeAction({required String id}) async {
    http.Response response = await http.put(
        Uri.parse(
          "${BaseUrl.baseUrl}${EndPoints.responding}$id",
        ),
        headers: CommonHeader.header);
    var result = jsonDecode(response.body);
    if (kDebugMode) {
      print("Change Action Response==>$result");
    }
    return result;
  }
}
