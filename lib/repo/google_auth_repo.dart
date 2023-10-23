import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/constant/api_const.dart';

class GoogleAuthRepo {
  static Future<bool> sendGoogleAuthUserData({
    required String displayName,
    required String email,
    required String uid,
    required String uuid,
  }) async {
    var header = {"uuid": uuid};

    var reqBody = json.encode({
      'displayName': displayName,
      'email': email,
      'uid': uid,
    });

    http.Response response = await http.post(
        Uri.parse(BaseUrl.baseUrl + EndPoints.googleAuth),
        body: reqBody,
        headers: header);
    var result = jsonDecode(response.body);
    if (kDebugMode) {
      print("Google Auth Repo Response==>>${response.body}");
    }
    return result['success'];
  }
}
