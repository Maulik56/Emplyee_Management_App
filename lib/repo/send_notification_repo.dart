import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class SendNotificationRepo {
  static Future sendNotificationRepo() async {
    var response = await APIService().getResponse(
        url: "device/testDataNotification?id=team_status_update",
        apitype: APIType.aGet,
        header: CommonHeader.header);
    return response;
  }
}
