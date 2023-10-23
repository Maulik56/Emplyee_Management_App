import 'package:news_app/constant/api_const.dart';
import '../models/response_model/auto_book_on_response_model.dart';
import '../services/api_service/base_services.dart';

class GetAutoBookOnDataRepo {
  static Future<AutoBookOnResponseModel> getAutoBookOnData() async {
    var response = await APIService().getResponse(
        url: EndPoints.autoBook,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    AutoBookOnResponseModel autoBookOnResponseModel =
        AutoBookOnResponseModel.fromJson(response);
    return autoBookOnResponseModel;
  }
}
