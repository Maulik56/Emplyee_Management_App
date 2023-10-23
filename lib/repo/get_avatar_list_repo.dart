import 'package:news_app/constant/api_const.dart';
import '../models/response_model/avatar_response_model.dart';
import '../services/api_service/base_services.dart';

class GetAvatarListRepo {
  static Future<AvatarResponseModel> getAvatarList() async {
    var response = await APIService().getResponse(
        url: EndPoints.avatarList,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    AvatarResponseModel avatarResponseModel =
        AvatarResponseModel.fromJson(response);
    return avatarResponseModel;
  }
}
