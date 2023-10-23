import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/api_const.dart';

class ResendCodeRepo {
  static Future<bool> resendCode() async {
    http.Response response = await http.post(
        Uri.parse(
          BaseUrl.baseUrl + EndPoints.resendCode,
        ),
        headers: CommonHeader.header);
    var result = jsonDecode(response.body);
    return result['success'];
  }
}
