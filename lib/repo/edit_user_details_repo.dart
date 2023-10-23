import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/constant/api_const.dart';

class EditUserProfileRepo {
  static Future editUserProfile({
    required String id,
    required String firstName,
    required String lastName,
    required String mobile,
    required String email,
  }) async {
    var reqBody = json.encode({
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "mobile": mobile,
      "email": email
    });

    http.Response response = await http.post(
        Uri.parse(BaseUrl.baseUrl + EndPoints.user),
        body: reqBody,
        headers: CommonHeader.header);
    var result = jsonDecode(response.body);

    if (kDebugMode) {
      print("Edit User Profile=>$result");
    }
    return result;
  }
}
