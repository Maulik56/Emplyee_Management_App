import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class ChangeFollowingCrewStatusRepo {
  static Future changeStatus(
      {required String contId, required bool isFollow}) async {
    if (kDebugMode) {
      print(
          "Change Status Request Parameter==>${isFollow ? "${EndPoints.followCrew}$contId" : "${EndPoints.unfollowCrew}$contId"}");
    }
    var response = await APIService().getResponse(
        url: isFollow
            ? "${EndPoints.followCrew}$contId"
            : "${EndPoints.unfollowCrew}$contId",
        apitype: APIType.aPost,
        header: CommonHeader.header);
    return response;
  }
}
