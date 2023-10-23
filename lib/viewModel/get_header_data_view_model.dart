import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../models/response_model/main_screen_header_model.dart';
import '../repo/get_status_data_repo.dart';
import '../services/api_service/api_response.dart';
import '../services/google_ads_service/google_ads_service.dart';

class GetHeaderDataViewModel extends GetxController {
  BannerAd? bannerAd;

  ApiResponse _getHeaderDataResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get getHeaderDataResponse => _getHeaderDataResponse;

  Future<void> getHeaderData({bool isLoading = true}) async {
    if (isLoading) {
      _getHeaderDataResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      MainScreenHeaderModel response = await GetStatusRepo.getHeaderData();
      if (kDebugMode) {
        print("HeaderResponseModel==>${response.data!.header!.text}");
      }

      _getHeaderDataResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("HeaderResponseModel Error==>$e==");
      }
      _getHeaderDataResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
