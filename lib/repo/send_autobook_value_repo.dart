import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class SendAutoBookValueRepo {
  static Future sendAutoBookValue(
      {required String id, required String value}) async {
    if (kDebugMode) {
      print(
          "Request Parameter of SendAutoBookValueRepo==${EndPoints.autoBook}/$id/$value ");
    }
    var response = await APIService().getResponse(
        url: '${EndPoints.autoBook}/$id/$value',
        apitype: APIType.aPost,
        header: CommonHeader.header);

    if (kDebugMode) {
      print("Send Auto BookValue RESPONSE==>>$response");
    }
    return response;
  }
}
