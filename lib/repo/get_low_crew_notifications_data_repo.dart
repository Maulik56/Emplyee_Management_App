import 'package:news_app/constant/api_const.dart';
import '../models/response_model/low_crew_notification_response_model.dart';
import '../services/api_service/base_services.dart';

class GetLowCrewNotificationsRepo {
  static Future<LowCrewNotificationResponseModel>
      getLowCrewNotifications() async {
    var response = await APIService().getResponse(
        url: EndPoints.teamLevels,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    LowCrewNotificationResponseModel lowCrewNotificationResponseModel =
        LowCrewNotificationResponseModel.fromJson(response);
    return lowCrewNotificationResponseModel;
  }
}
