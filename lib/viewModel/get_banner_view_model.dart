import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:news_app/repo/get_banner_repo.dart';
import '../models/response_model/banner_response_model.dart';
import '../services/api_service/api_response.dart';

class GetBannerViewModel extends GetxController {
  ApiResponse _getBannerResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getBannerResponse => _getBannerResponse;

  bool isVisible = true;

  Future<void>  getBannerInfo(
      {bool isLoading = true, required String screenId}) async {
    if (isLoading) {
      _getBannerResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      BannerResponseModel response =
          await GetBannerRepo.getBannerInfo(screenId: screenId);

      isVisible = response.data?.visible ?? false;

      if (kDebugMode) {
        print("BannerResponseModel==>$response");
      }

      _getBannerResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("BannerResponseModel Error==>$e==");
      }
      _getBannerResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
