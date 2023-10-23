import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class TeamInfoRepo {
  static Future getTeamInfo() async {
    var response = await APIService().getResponse(
        url: EndPoints.team,
        apitype: APIType.aGet,
        header: CommonHeader.header);

    return response;
  }

  static Future<bool> sendTeamInfo({
    required String name,
    required String country,
    required String timezone,
    required String sector,
  }) async {
    var reqBody = {
      "name": name,
      "country": country,
      "timezone": timezone,
      "sector": sector
    };

    var response = await APIService().getResponse(
        url: EndPoints.team,
        apitype: APIType.aPost,
        body: reqBody,
        header: CommonHeader.header);

    return response['success'];
  }
}
