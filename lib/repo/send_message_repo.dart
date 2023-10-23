import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class SendMessageRepo {
  static Future sendMessage({required String message}) async {
    var reqBody = {"text": message};

    var response = await APIService().getResponse(
        url: EndPoints.sendMessage,
        apitype: APIType.aPost,
        body: reqBody,
        header: CommonHeader.header);
    if (kDebugMode) {
      print('Send Message API Response==>$response');
    }
    return response;
  }
}
