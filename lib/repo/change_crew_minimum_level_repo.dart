import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class ChangeCrewMinimumLevelRepo {
  static Future changeLevel(
      {required String code, required String level}) async {
    var response = await APIService().getResponse(
        url: "${EndPoints.teamLevels}/$code/$level",
        apitype: APIType.aPost,
        header: CommonHeader.header);
    if (kDebugMode) {
      print("Change Crew Minimum Level Response===>>$response");
    }
    return response;
  }
}
