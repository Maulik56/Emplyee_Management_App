import 'package:news_app/constant/api_const.dart';
import 'package:news_app/models/response_model/get_invite_code_response_model.dart';
import 'package:news_app/services/api_service/base_services.dart';

class GetInviteCodeRepo {
  static Future<GetInviteCodeResponseModel> getInviteCodeRepo() async {
    var response = await APIService().getResponse(
        url: EndPoints.getInviteCode,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    GetInviteCodeResponseModel getInviteCodeResponseModel =
        GetInviteCodeResponseModel.fromJson(response);
    return getInviteCodeResponseModel;
  }
}
