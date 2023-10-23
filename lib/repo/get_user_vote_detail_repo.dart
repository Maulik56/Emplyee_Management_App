import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';

class GetUserVoteDetailRepo {
  static Future getUserVoteDetail({required String targetUserId}) async {
    var response = await APIService().getResponse(
        url: '${EndPoints.user}$targetUserId/vote',
        apitype: APIType.aGet,
        header: CommonHeader.header);
    return response;
  }
}
