import 'package:news_app/constant/api_const.dart';
import '../models/response_model/user_detail_response_model.dart';
import '../services/api_service/base_services.dart';

class GetUserDetailRepo {
  static Future<UserDetailResponseModel> getUserDetail() async {
    var response = await APIService().getResponse(
        url: EndPoints.user,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    UserDetailResponseModel userDetailResponseModel =
        UserDetailResponseModel.fromJson(response);
    return userDetailResponseModel;
  }

  static Future getUserDetailWithoutModel(
      {bool isAnotherUser = false, String? userId}) async {
    var response = await APIService().getResponse(
        url: isAnotherUser ? '${EndPoints.user}$userId' : EndPoints.user,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    return response;
  }
}
