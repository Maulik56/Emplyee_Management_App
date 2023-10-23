import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:news_app/view/auto_book_on_screen.dart';
import '../models/response_model/auto_book_on_response_model.dart';
import '../repo/get_auto_book_on_data_repo.dart';
import '../services/api_service/api_response.dart';

class GetAutoBookOnViewModel extends GetxController {
  AutoBookTimings selectedSegment = AutoBookTimings.time;

  void changeSegment(AutoBookTimings value) {
    selectedSegment = value;
    update();
  }

  ApiResponse _getAutoBookOnResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getAutoBookOnResponse => _getAutoBookOnResponse;

  Future<void> getAutoBookOnData({bool isLoading = true}) async {
    if (isLoading) {
      _getAutoBookOnResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      AutoBookOnResponseModel response =
          await GetAutoBookOnDataRepo.getAutoBookOnData();
      if (kDebugMode) {
        print("AutoBookOnResponseModel==>$response");
      }

      _getAutoBookOnResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("AutoBookOnResponseModel Error==>$e==");
      }
      _getAutoBookOnResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
