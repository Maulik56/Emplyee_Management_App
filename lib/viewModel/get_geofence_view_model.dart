import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/response_model/geofence_response_model.dart';
import '../repo/get_geofence_repo.dart';
import '../services/api_service/api_response.dart';

class GetGeoFenceViewModel extends GetxController {
  ApiResponse _getGeoFenceResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getGeoFenceResponse => _getGeoFenceResponse;

  Future<void> getGeoFenceData({bool isLoading = true}) async {
    if (isLoading) {
      _getGeoFenceResponse = ApiResponse.loading(message: 'Loading');
    }

    try {
      GeofenceResponseModel response =
          await GetGeoFenceDataRepo.getGeoFenceData();
      if (kDebugMode) {
        print("GeofenceResponseModel==>$response");
      }

      _getGeoFenceResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("GeofenceResponseModel Error==>$e==");
      }
      _getGeoFenceResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
