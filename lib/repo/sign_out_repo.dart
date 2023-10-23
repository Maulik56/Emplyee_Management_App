import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import 'package:http/http.dart' as http;

class SignOutRepo {
  static Future signOut() async {
    http.Response response = await http.delete(
        Uri.parse(BaseUrl.baseUrl + EndPoints.signOut),
        headers: CommonHeader.header);
    var result = jsonDecode(response.body);
    if (kDebugMode) {
      print("SIGN OUT==>$result");
    }
    return result['success'];
  }
}
