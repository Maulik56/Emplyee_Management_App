import 'package:news_app/constant/api_const.dart';
import '../models/response_model/get_timezone_list_response_model.dart';
import '../services/api_service/base_services.dart';

class GetTimeZoneListRepo {
  static Future<GetTimeZoneListResponseModel> getTimeZoneList(
      {required String country}) async {
    var response = await APIService().getResponse(
        url: "${EndPoints.timZoneList}$country/timezone/list",
        apitype: APIType.aGet,
        header: CommonHeader.header);
    GetTimeZoneListResponseModel getTimeZoneListResponseModel =
        GetTimeZoneListResponseModel.fromJson(response);
    return getTimeZoneListResponseModel;
  }
}
