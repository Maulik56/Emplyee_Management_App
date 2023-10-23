import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:news_app/repo/get_filter_country_repo.dart';
import 'package:news_app/repo/get_sector_list_repo.dart';
import 'package:news_app/repo/get_timezone_list_repo.dart';
import '../models/response_model/filter_country_response_model.dart';
import '../models/response_model/get_timezone_list_response_model.dart';
import '../models/response_model/sector_list_response_model.dart';
import '../services/api_service/api_response.dart';

class CreateTeamViewModel extends GetxController {
  String? selectedValue;

  void updateValue(String value) {
    selectedValue = value;
    update();
  }

  ApiResponse _getTimeZoneListResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getTimeZoneListResponse => _getTimeZoneListResponse;

  Future<void> getTimeZoneList(
      {bool isLoading = true, required String country}) async {
    if (isLoading) {
      _getTimeZoneListResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      GetTimeZoneListResponseModel response =
          await GetTimeZoneListRepo.getTimeZoneList(country: country);
      if (kDebugMode) {
        print("GetTimeZoneListResponseModel==>${response.data!.timezones}");
      }

      _getTimeZoneListResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("GetTimeZoneListResponseModel Error==>$e==");
      }
      _getTimeZoneListResponse = ApiResponse.error(message: 'error');
    }
    update();
  }

  ApiResponse _getFilterCountryListResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getFilterCountryListResponse => _getFilterCountryListResponse;

  Future<void> getFilterCountyList({bool isLoading = true}) async {
    if (isLoading) {
      _getFilterCountryListResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      FilterCountryResponseModel response =
          await GetFilterCountryRepo.getCountries();
      if (kDebugMode) {
        print("FilterCountryResponseModel==>$response");
      }

      _getFilterCountryListResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("FilterCountryResponseModel Error==>$e==");
      }
      _getFilterCountryListResponse = ApiResponse.error(message: 'error');
    }
    update();
  }

  ApiResponse _getSectorListResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getSectorListResponse => _getSectorListResponse;

  Future<void> getSectorList({bool isLoading = true}) async {
    if (isLoading) {
      _getSectorListResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      SectorListResponseModel response =
          await GetSectorListRepo.getSectorList();
      if (kDebugMode) {
        print("SectorListResponseModel==>$response");
      }

      _getSectorListResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("SectorListResponseModel Error==>$e==");
      }
      _getSectorListResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
