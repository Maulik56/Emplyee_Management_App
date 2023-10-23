import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:news_app/models/response_model/get_team_summary_response_model.dart';
import 'package:news_app/repo/get_team_summary_repo.dart';
import 'package:news_app/services/api_service/api_response.dart';

class GetTeamSummaryViewModel extends GetxController {
  DateTime date = DateTime.now();

  void updateDate() {
    date = DateTime.now();
    update();
  }

  Future weekRange(
      {required DateTime currentDate, bool isIncrement = false}) async {
    if (isIncrement) {
      date = currentDate.add(Duration(days: 1));
      getNextSummaryViewModel();
      getTeamSummaryViewModel();
    } else {
      date = currentDate.add(Duration(days: -1));
      getPrevSummaryViewModel();
      getTeamSummaryViewModel();
    }
    update();
  }

  ApiResponse _getTeamSummaryResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getTeamSummaryResponse => _getTeamSummaryResponse;

  Future<void> getTeamSummaryViewModel({
    bool isLoading = true,
  }) async {
    if (isLoading) {
      _getTeamSummaryResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      GetTeamSummaryResponseModel response =
          await GetTeamSummaryRepo.getTeamSummaryRepo();
      if (kDebugMode) {
        print("GetTeamSummaryViewModel==>$response");
      }

      _getTeamSummaryResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("GetTeamSummaryViewModel Error==>$e==");
      }
      _getTeamSummaryResponse = ApiResponse.error(message: 'error');
    }
    update();
  }

  /// Prev ////
  ApiResponse _getPrevSummaryResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getPrevSummaryResponse => _getPrevSummaryResponse;

  Future<void> getPrevSummaryViewModel({
    bool isLoading = true,
  }) async {
    if (isLoading) {
      _getPrevSummaryResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      GetTeamSummaryResponseModel response =
          await GetTeamSummaryRepo.getPrevRepo();
      if (kDebugMode) {
        print("GetTeamSummaryViewModel==>$response");
      }

      _getPrevSummaryResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("GetTeamSummaryViewModel Error==>$e==");
      }
      _getPrevSummaryResponse = ApiResponse.error(message: 'error');
    }
    update();
  }

  /// Next ////
  ApiResponse _getNextSummaryResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getNextSummaryResponse => _getNextSummaryResponse;

  Future<void> getNextSummaryViewModel({
    bool isLoading = true,
  }) async {
    if (isLoading) {
      _getNextSummaryResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      GetTeamSummaryResponseModel response =
          await GetTeamSummaryRepo.getNextRepo();
      if (kDebugMode) {
        print("GetTeamSummaryViewModel==>$response");
      }

      _getNextSummaryResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("GetTeamSummaryViewModel Error==>$e==");
      }
      _getNextSummaryResponse = ApiResponse.error(message: 'error');
    }
    update();
  }

  /// CurrentDate ////

  ApiResponse _getCurrentSummaryResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getCurrentSummaryResponse => _getCurrentSummaryResponse;

  Future<void> getCurrentSummaryViewModel(
      {bool isLoading = true, DateTime? date}) async {
    if (isLoading) {
      _getCurrentSummaryResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      GetTeamSummaryResponseModel response =
          await GetTeamSummaryRepo.getCurrentDateRepo(date: date);
      if (kDebugMode) {
        print("GetTeamSummaryViewModel==>$response");
      }
      _getCurrentSummaryResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("getCurrentDateRepo Error==>$e==");
      }
      _getCurrentSummaryResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
