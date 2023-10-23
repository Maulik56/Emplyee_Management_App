import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class LoginRepo {
  static Future<bool> login() async {
    var response = await APIService().getResponse(
        url: EndPoints.login,
        apitype: APIType.aPost,
        header: CommonHeader.header);

    if (kDebugMode) {
      print("LOGIN API RESPONSE==>>$response");
    }
    return response['success'];
  }
}
