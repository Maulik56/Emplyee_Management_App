import 'package:news_app/constant/api_const.dart';
import '../models/response_model/event_detail_response_model.dart';
import '../models/response_model/get_events_detail_response_model.dart';
import '../services/api_service/base_services.dart';

class GetEventDetailRepo {
  static Future<EventsDetailResponseModel> getEventDetail(
      {required String year,
      required String month,
      required String day}) async {
    var response = await APIService().getResponse(
        url: "${EndPoints.event}$year/$month/$day",
        apitype: APIType.aGet,
        header: CommonHeader.header);
    EventsDetailResponseModel eventsDetailResponseModel =
        EventsDetailResponseModel.fromJson(response);
    return eventsDetailResponseModel;
  }

  static Future<ParticularEventDetailResponseModel> getParticularEventDetail({
    required String eventId,
  }) async {
    var response = await APIService().getResponse(
        url: "${EndPoints.event}$eventId",
        apitype: APIType.aGet,
        header: CommonHeader.header);
    ParticularEventDetailResponseModel particularEventDetailResponseModel =
        ParticularEventDetailResponseModel.fromJson(response);
    return particularEventDetailResponseModel;
  }
}
