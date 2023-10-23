import 'package:news_app/constant/api_const.dart';
import '../models/response_model/qualification_response_model.dart';
import '../services/api_service/base_services.dart';

class GetQualificationListRepo {
  static Future<QualificationResponseModel> getQualificationList() async {
    var response = await APIService().getResponse(
        url: EndPoints.qualificationList,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    QualificationResponseModel qualificationResponseModel =
        QualificationResponseModel.fromJson(response);
    return qualificationResponseModel;
  }
}
