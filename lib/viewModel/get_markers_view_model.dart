import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/response_model/markers_response_model.dart';
import '../repo/get_markers_repo.dart';
import '../services/api_service/api_response.dart';

class GetMarkersViewModel extends GetxController {
  bool isRefreshed = true;

  Future changeRefreshStatus(bool value) async {
    isRefreshed = value;
    update();
  }

  ApiResponse _getMarkersResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getStatisticsResponse => _getMarkersResponse;

  Future<void> getMarkersList(
      {bool isLoading = true,
      required lat,
      required long,
      required zoom,
      required region}) async {
    if (isLoading) {
      _getMarkersResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      MarkersResponseModel response = await GetMarkersRepo.getMarkers(
          lat: lat, long: long, zoom: zoom, region: region);
      if (kDebugMode) {
        print("MarkersResponseModel==>$response");
      }

      _getMarkersResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("MarkersResponseModel Error==>$e==");
      }
      _getMarkersResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
