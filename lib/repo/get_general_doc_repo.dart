import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class GetGeneralDocumentRepo {
  static Future getGeneralDocument({String? docType}) async {
    var response = await APIService().getResponse(
        url: docType == 'privacy' ? EndPoints.privacy : EndPoints.terms,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    return response;
  }
}
