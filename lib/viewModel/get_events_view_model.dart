import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/response_model/events_response_model.dart';
import '../models/response_model/get_events_detail_response_model.dart';
import '../repo/get_event_detail_repo.dart';
import '../repo/get_events_repo.dart';
import '../services/api_service/api_response.dart';

class GetEventsViewModel extends GetxController {
  ApiResponse _getEventsResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getEventsResponse => _getEventsResponse;

  Future<void> getEventList({
    bool isLoading = true,
    required String year,
    required String month,
  }) async {
    if (isLoading) {
      _getEventsResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      EventsResponseModel response =
          await GetEventsRepo.getEvents(year: year, month: month);
      if (kDebugMode) {
        print("EventsResponseModel==>${response.data!.events!.length}");
      }

      _getEventsResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("EventsResponseModel Error==>$e==");
      }
      _getEventsResponse = ApiResponse.error(message: 'error');
    }
    update();
  }

  ApiResponse _getEventDetailResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getEventDetailResponse => _getEventDetailResponse;

  Future<void> getEventDetail(
      {bool isLoading = true,
      required String year,
      required String month,
      required String day}) async {
    if (isLoading) {
      _getEventDetailResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      EventsDetailResponseModel response =
          await GetEventDetailRepo.getEventDetail(
              year: year, month: month, day: day);
      if (kDebugMode) {
        print("EventsDetailResponseModel==>${response.data!.events!.length}");
      }

      _getEventDetailResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("EventsDetailResponseModel Error==>$e==");
      }
      _getEventDetailResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
