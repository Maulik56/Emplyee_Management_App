import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:news_app/models/response_model/following_crew_response_model.dart';
import 'package:news_app/repo/get_following_team_repo.dart';
import '../services/api_service/api_response.dart';

class GetFollowingCrewViewModel extends GetxController {
  ApiResponse _getFollowingCrewResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getFollowingCrewResponse => _getFollowingCrewResponse;

  Future<void> getFollowingCrewData({
    bool isLoading = true,
  }) async {
    if (isLoading) {
      _getFollowingCrewResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      FollowingCrewResponseModel response =
          await GetFollowingTeamRepo.getFollowingTeam();
      if (kDebugMode) {
        print("FollowingCrewResponseModel==>$response");
      }

      _getFollowingCrewResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("FollowingCrewResponseModel Error==>$e==");
      }
      _getFollowingCrewResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
