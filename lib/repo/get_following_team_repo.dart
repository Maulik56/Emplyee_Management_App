import 'package:news_app/constant/api_const.dart';
import '../models/response_model/following_crew_response_model.dart';
import '../services/api_service/base_services.dart';

class GetFollowingTeamRepo {
  static Future<FollowingCrewResponseModel> getFollowingTeam() async {
    var response = await APIService().getResponse(
        url: EndPoints.teamFollowing,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    FollowingCrewResponseModel followingCrewResponseModel =
        FollowingCrewResponseModel.fromJson(response);
    return followingCrewResponseModel;
  }
}
