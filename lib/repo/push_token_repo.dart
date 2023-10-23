import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constant/api_const.dart';

class PushTokenRepo {
  static Future<bool> pushToken({String? token}) async {
    http.Response response = await http.post(
        Uri.parse(
          BaseUrl.baseUrl + EndPoints.pushToken + token!,
        ),
        headers: CommonHeader.header);
    var result = jsonDecode(response.body);
    if (kDebugMode) {
      print("PUSH TOKEN API RESPONSE==>>$result");
    }
    return result['success'];
  }
}
