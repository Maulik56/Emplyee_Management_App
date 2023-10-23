import 'package:news_app/constant/api_const.dart';
import '../models/response_model/resource_category_response_model.dart';
import '../services/api_service/base_services.dart';

class GetResourceCategoryRepo {
  static Future<ResourceCategoryResponseModel> getResourceCategory() async {
    var response = await APIService().getResponse(
        url: EndPoints.resourceCategory,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    ResourceCategoryResponseModel resourceCategoryResponseModel =
        ResourceCategoryResponseModel.fromJson(response);
    return resourceCategoryResponseModel;
  }
}
