import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../repo/team_info_repo.dart';
import '../services/api_service/api_response.dart';

class GetTeamInfoViewModel extends GetxController {
  ApiResponse _getTeamInfoResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getTeamInfoResponse => _getTeamInfoResponse;

  Future<void> getTeamInfo({bool isLoading = true}) async {
    if (isLoading) {
      _getTeamInfoResponse = ApiResponse.loading(message: 'Loading');
    }

    try {
      var data = await TeamInfoRepo.getTeamInfo();
      if (kDebugMode) {
        print("Get Team Info API Response==>$data");
      }
      _getTeamInfoResponse = ApiResponse.complete(data);
    } catch (e) {
      if (kDebugMode) {
        print("Get Team Info API Error==>$e==");
      }
      _getTeamInfoResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
