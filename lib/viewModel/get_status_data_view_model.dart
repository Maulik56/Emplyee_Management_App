import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news_app/repo/get_status_data_repo.dart';
import 'package:news_app/services/google_ads_service/google_ads_service.dart';

import '../models/response_model/status_response_model.dart';
import '../services/api_service/api_response.dart';
import '../view/status_screen.dart';

class GetStatusDataViewModel extends GetxController {
  bool isRefreshed = true;

  Timer? timer;

  StatusList selectedSegment = StatusList.all;

  void changeSegment(StatusList value) {
    selectedSegment = value;
    update();
  }

  void changeRefreshStatus(bool value) {
    isRefreshed = value;
    update();
  }

  ApiResponse _getStatusApiResponse =
      ApiResponse.initial(message: 'Initialization');
  ApiResponse get getStatusApiResponse => _getStatusApiResponse;

  Future<void> getStatusData(
      {bool isLoading = true,
      bool? needFilter = false,
      String? queryParameter}) async {
    if (isLoading) {
      _getStatusApiResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      StatusResponseModel response = await GetStatusRepo.getStatusData(
          needFilter: needFilter, queryParameter: queryParameter);
      if (kDebugMode) {
        print("StatusResponseModel==>$response");
      }

      _getStatusApiResponse = ApiResponse.complete(response);
      update();
    } catch (e) {
      if (kDebugMode) {
        print("StatusResponseModel Error==>$e==");
      }
      _getStatusApiResponse = ApiResponse.error(message: 'error');
      rethrow;
    }
  }
}
