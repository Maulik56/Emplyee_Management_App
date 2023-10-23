import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/get_storage_services/get_storage_service.dart';

import '../constant/api_const.dart';

class VerifyCodeRepo {
  static Future<bool> verifyCode(
      {required String code, required String uuid}) async {
    var reqBody = json.encode({"code": code, "uuid": uuid});

    http.Response response = await http.post(
        Uri.parse(BaseUrl.baseUrl + EndPoints.verify),
        body: reqBody,
        headers: CommonHeader.header);
    var result = jsonDecode(response.body);
    if (kDebugMode) {
      print("DATA===>>${result['next_page']}");
    }

    /// Save Next Screen name:
    GetStorageServices.setNextScreen(result['next_page']);

    return result['success'];
  }
}
