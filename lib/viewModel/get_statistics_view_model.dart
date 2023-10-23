import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/response_model/statistics_response_model.dart';
import '../repo/get_statistics_repo.dart';
import '../services/api_service/api_response.dart';

class GetStatisticsViewModel extends GetxController {
  ApiResponse _getStatisticsResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getStatisticsResponse => _getStatisticsResponse;

  Future<void> getStatisticsData({bool isLoading = true}) async {
    if (isLoading) {
      _getStatisticsResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      StatisticsResponseModel response =
          await GetStatisticsRepo.getStatistics();
      if (kDebugMode) {
        print("StatisticsResponseModel==>$response");
      }

      _getStatisticsResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("StatisticsResponseModel Error==>$e==");
      }
      _getStatisticsResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
