import 'package:news_app/constant/api_const.dart';
import '../models/response_model/statistics_response_model.dart';
import '../services/api_service/base_services.dart';

class GetStatisticsRepo {
  static Future<StatisticsResponseModel> getStatistics() async {
    var response = await APIService().getResponse(
        url: EndPoints.statistics,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    StatisticsResponseModel statisticsResponseModel =
        StatisticsResponseModel.fromJson(response);
    return statisticsResponseModel;
  }
}
