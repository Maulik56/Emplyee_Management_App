import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:news_app/models/response_model/get_invite_code_response_model.dart';
import 'package:news_app/repo/get_invite_code_repo.dart';
import '../services/api_service/api_response.dart';

class GetInviteCodeViewModel extends GetxController {
  ApiResponse _getInviteCodeResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getInviteCodeResponse => _getInviteCodeResponse;

  Future<void> getInviteCodeViewModel({
    bool isLoading = true,
  }) async {
    if (isLoading) {
      _getInviteCodeResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      GetInviteCodeResponseModel response =
          await GetInviteCodeRepo.getInviteCodeRepo();
      if (kDebugMode) {
        print("GetInviteCodeResponseModel==>$response");
      }

      _getInviteCodeResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("GetInviteCodeResponseModel Error==>$e==");
      }
      _getInviteCodeResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
