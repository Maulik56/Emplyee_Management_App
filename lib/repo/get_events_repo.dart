import 'package:news_app/constant/api_const.dart';
import '../models/response_model/events_response_model.dart';
import '../services/api_service/base_services.dart';

class GetEventsRepo {
  static Future<EventsResponseModel> getEvents({
    required String year,
    required String month,
  }) async {
    var response = await APIService().getResponse(
        url: "${EndPoints.event}$year/$month",
        apitype: APIType.aGet,
        header: CommonHeader.header);
    EventsResponseModel eventsResponseModel =
        EventsResponseModel.fromJson(response);
    return eventsResponseModel;
  }
}
