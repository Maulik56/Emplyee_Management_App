import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class UpdateSubscriptionEventRepo {
  static Future updateSubscription(String id) async {
    var response = await APIService().getResponse(
        url: '${EndPoints.subscriptionEvent}/$id',
        apitype: APIType.aPost,
        header: CommonHeader.header);

    if (kDebugMode) {
      print("Update Subscription EventRepo RESPONSE==>>$response");
    }
    return response;
  }
}
