import 'package:news_app/constant/api_const.dart';
import '../models/response_model/role_response_model.dart';
import '../services/api_service/base_services.dart';

class GetRoleListRepo {
  static Future<RoleResponseModel> getRoleList() async {
    var response = await APIService().getResponse(
        url: EndPoints.roleList,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    RoleResponseModel roleResponseModel = RoleResponseModel.fromJson(response);
    return roleResponseModel;
  }
}
