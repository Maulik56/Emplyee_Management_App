import 'package:news_app/constant/api_const.dart';
import 'package:news_app/models/response_model/get_team_summary_response_model.dart';
import '../services/api_service/base_services.dart';

class GetTeamSummaryRepo {
  static Future<GetTeamSummaryResponseModel> getTeamSummaryRepo() async {
    var response = await APIService().getResponse(
        url: "${EndPoints.teamSummary}",
        apitype: APIType.aGet,
        header: CommonHeader.header);
    GetTeamSummaryResponseModel getTeamSummaryResponseModel =
    GetTeamSummaryResponseModel.fromJson(response);
    return getTeamSummaryResponseModel;
  }


  ///   SummaryPrev   ////

  static Future<GetTeamSummaryResponseModel> getPrevRepo() async {
    var response = await APIService().getResponse(
        url: "${EndPoints.teamPrevSummary}",
        apitype: APIType.aPut,
        header: CommonHeader.header);
    GetTeamSummaryResponseModel getTeamSummaryResponseModel =
    GetTeamSummaryResponseModel.fromJson(response);
    return getTeamSummaryResponseModel;
  }

  ///   SummaryNext    ////

  static Future<GetTeamSummaryResponseModel> getNextRepo() async {
    var response = await APIService().getResponse(
        url: "${EndPoints.teamNextSummary}",
        apitype: APIType.aPut,
        header: CommonHeader.header);
    GetTeamSummaryResponseModel getTeamSummaryResponseModel =
    GetTeamSummaryResponseModel.fromJson(response);
    return getTeamSummaryResponseModel;
  }


  /// SummaryDate///
  static Future<GetTeamSummaryResponseModel> getCurrentDateRepo(
      {DateTime? date}) async {
    var response = await APIService().getResponse(
        url: "${EndPoints.teamCurrentDateSummary}$date.t",
        apitype: APIType.aPut,
        header: CommonHeader.header);
    GetTeamSummaryResponseModel getTeamSummaryResponseModel =
    GetTeamSummaryResponseModel.fromJson(response);
    return getTeamSummaryResponseModel;
  }
}
