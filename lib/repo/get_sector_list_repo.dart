import 'package:news_app/constant/api_const.dart';
import '../models/response_model/sector_list_response_model.dart';
import '../services/api_service/base_services.dart';

class GetSectorListRepo {
  static Future<SectorListResponseModel> getSectorList() async {
    var response = await APIService().getResponse(
        url: EndPoints.sectorList,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    SectorListResponseModel sectorListResponseModel =
        SectorListResponseModel.fromJson(response);
    return sectorListResponseModel;
  }
}
