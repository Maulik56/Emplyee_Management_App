import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class AddEventRepo {
  static Future addEvent({
    required String eventId,
    required String title,
    required String startTime,
    required String finishTime,
    required bool personal,
  }) async {
    var reqBody = {
      "id": eventId,
      "title": title,
      "start_time": startTime,
      "finish_time": finishTime,
      "personal": personal
    };

    var response = await APIService().getResponse(
        url: EndPoints.event,
        apitype: APIType.aPost,
        body: reqBody,
        header: CommonHeader.header);
    if (kDebugMode) {
      print('Add Event API Response==>$response');
    }
    return response;
  }
}
