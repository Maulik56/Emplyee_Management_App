import 'package:news_app/constant/api_const.dart';
import '../models/response_model/alert_list_reponse_model.dart';
import '../services/api_service/base_services.dart';

class GetAlertListRepo {
  static Future<AlertListResponseModel> getAlertList() async {
    var response = await APIService().getResponse(
        url: EndPoints.alertList,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    AlertListResponseModel alertListResponseModel =
        AlertListResponseModel.fromJson(response);
    return alertListResponseModel;
  }
}
