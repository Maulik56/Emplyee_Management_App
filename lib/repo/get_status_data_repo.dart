import 'package:news_app/constant/api_const.dart';
import '../models/response_model/main_screen_header_model.dart';
import '../models/response_model/status_response_model.dart';
import '../services/api_service/base_services.dart';

class GetStatusRepo {
  static Future<StatusResponseModel> getStatusData(
      {bool? needFilter = false, String? queryParameter}) async {
    var response = await APIService().getResponse(
        url: needFilter == true
            ? '${EndPoints.status}?status=$queryParameter'
            : EndPoints.status,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    print(
        "URL===>>${needFilter == true ? '${EndPoints.status}?status=$queryParameter' : EndPoints.status}");
    StatusResponseModel statusResponseModel =
        StatusResponseModel.fromJson(response);
    return statusResponseModel;
  }

  static Future<MainScreenHeaderModel> getHeaderData() async {
    var response = await APIService().getResponse(
        url: EndPoints.status,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    //print("Header DATA==>>$response");
    //print("Header ${CommonHeader.header}");

    MainScreenHeaderModel mainScreenHeaderModel =
        MainScreenHeaderModel.fromJson(response);
    return mainScreenHeaderModel;
  }
}
