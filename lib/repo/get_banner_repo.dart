import 'package:news_app/constant/api_const.dart';
import '../models/response_model/banner_response_model.dart';
import '../services/api_service/base_services.dart';

class GetBannerRepo {
  static Future<BannerResponseModel> getBannerInfo(
      {required String screenId}) async {
    var response = await APIService().getResponse(
        url: "${EndPoints.banner}$screenId",
        apitype: APIType.aGet,
        header: CommonHeader.header);
    BannerResponseModel bannerResponseModel =
        BannerResponseModel.fromJson(response);
    return bannerResponseModel;
  }
}
