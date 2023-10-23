import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class ContactUsRepo {
  static Future sendMessage({required String message}) async {
    var reqBody = {"message": message};

    var response = await APIService().getResponse(
        url: EndPoints.generalEmail,
        apitype: APIType.aPost,
        body: reqBody,
        header: CommonHeader.header);

    if (kDebugMode) {
      print("Send Message RESPONSE==>>$response");
    }
    return response;
  }
}
