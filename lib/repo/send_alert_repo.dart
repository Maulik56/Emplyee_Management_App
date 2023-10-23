import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class SendAlertRepo {
  static Future sendAlert({required String alertId}) async {
    var response = await APIService().getResponse(
        url: EndPoints.sendAlert + alertId,
        apitype: APIType.aPost,
        header: CommonHeader.header);

    if (kDebugMode) {
      print("Send Alert RESPONSE==>>$response");
    }
    return response;
  }
}
