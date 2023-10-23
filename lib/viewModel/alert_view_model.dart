import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:news_app/repo/get_alert_list_repo.dart';
import '../models/response_model/alert_list_reponse_model.dart';
import '../services/api_service/api_response.dart';

class AlertViewModel extends GetxController {
  ApiResponse _getAlertListResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getAlertListResponse => _getAlertListResponse;

  Future<void> getAlertList({bool isLoading = true}) async {
    if (isLoading) {
      _getAlertListResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      AlertListResponseModel response = await GetAlertListRepo.getAlertList();
      if (kDebugMode) {
        print("AlertListResponseModel==>$response");
      }

      _getAlertListResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("AlertListResponseModel Error==>$e==");
      }
      _getAlertListResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
