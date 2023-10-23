import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:news_app/repo/get_low_crew_notifications_data_repo.dart';
import '../models/response_model/low_crew_notification_response_model.dart';
import '../services/api_service/api_response.dart';

class GetLowCrewNotificationsViewModel extends GetxController {
  ApiResponse _getLowCrewNotificationResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getLowCrewNotificationResponse =>
      _getLowCrewNotificationResponse;

  Future<void> getLowCrewNotificationsData({
    bool isLoading = true,
  }) async {
    if (isLoading) {
      _getLowCrewNotificationResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      LowCrewNotificationResponseModel response =
          await GetLowCrewNotificationsRepo.getLowCrewNotifications();
      if (kDebugMode) {
        print("LowCrewNotificationResponseModel==>$response");
      }

      _getLowCrewNotificationResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("LowCrewNotificationResponseModel Error==>$e==");
      }
      _getLowCrewNotificationResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
