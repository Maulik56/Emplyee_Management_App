import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class SendSubscriptionDataRepo {
  static Future sendSubscriptionInfo(
      {required Map<String, dynamic> reqBody}) async {
    var response = await APIService().getResponse(
        url: EndPoints.subscription,
        apitype: APIType.aPost,
        body: reqBody,
        header: CommonHeader.header);

    if (kDebugMode) {
      print("POST SUBSCRIPTION RESPONSE==>>$response");
    }
    return response;
  }
}
