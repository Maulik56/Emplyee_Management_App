import 'package:news_app/constant/api_const.dart';
import '../models/response_model/markers_response_model.dart';
import '../services/api_service/base_services.dart';

class GetMarkersRepo {
  static Future<MarkersResponseModel> getMarkers(
      {required lat, required long, required zoom, required region}) async {
    var response = await APIService().getResponse(
        url: "${EndPoints.markers}$lat/$long/$zoom?region=$region",
        apitype: APIType.aGet,
        header: CommonHeader.header);
    MarkersResponseModel markersResponseModel =
        MarkersResponseModel.fromJson(response);
    return markersResponseModel;
  }
}
