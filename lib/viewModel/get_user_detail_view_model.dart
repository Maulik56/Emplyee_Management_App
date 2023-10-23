import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/repo/get_user_detail_repo.dart';
import 'package:news_app/repo/get_user_vote_detail_repo.dart';
import '../models/response_model/user_detail_response_model.dart';
import '../services/api_service/api_response.dart';

class GetUserDetailViewModel extends GetxController {
  TextEditingController position = TextEditingController();
  TextEditingController BookOn = TextEditingController();

  List qualifications = [];

  List qualificationImageIdList = [];

  String? userAvatar;

  String? userId;

  void getUserId(String value) {
    userId = value;
    update();
  }

  bool isAnotherUser = false;

  void getIsAnotherUser(bool value) {
    isAnotherUser = value;
    update();
  }

  void updateUserAvatar(String value) {
    userAvatar = value;
    update();
  }

  String? userRole;

  void updateUserRole(String value) {
    userRole = value;
    update();
  }

  void clearUserRole() {
    userRole = '';
    update();
  }

  void updateUserPosition(String value) {
    position = TextEditingController(text: value);
    update();
  }

  void updateQualification(List value) {
    qualifications = value;
    update();
  }

  void updateQualificationImageList(List value) {
    qualificationImageIdList = value;

    update();
  }

  void addQualification(String value) {
    if (qualifications.contains(value)) {
    } else {
      qualifications.add(value);
    }
    update();
  }

  void addQualificationImageList(String value) {
    if (qualificationImageIdList.contains(value)) {
    } else {
      qualificationImageIdList.add(value);
    }
    update();
  }

  File? image;

  pickImage(ImageSource imageSource) async {
    final obtainedFile = await ImagePicker().pickImage(
      source: imageSource,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (obtainedFile != null) {
      image = File(obtainedFile.path);
      update();
    }
  }

  UserDetailResponseModel? response;

  TextEditingController? firstName;
  TextEditingController? lastName;
  TextEditingController? mobileNumber;
  TextEditingController? emailAddress;

  bool isRefreshed = true;

  void updateRefreshValue(bool value) {
    isRefreshed = value;
    update();
  }

  bool isRefreshed1 = true;

  void updateRefreshValue1(bool value) {
    isRefreshed = value;
    update();
  }

  ApiResponse _getUserDetailResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getUserDetailResponse => _getUserDetailResponse;

  Future<void> getUserDetail({
    bool isLoading = true,
  }) async {
    if (isLoading) {
      _getUserDetailResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      response = await GetUserDetailRepo.getUserDetail();
      if (kDebugMode) {
        print("UserDetailResponseModel==>${response!.data}");
      }
      _getUserDetailResponse = ApiResponse.complete(response);

      firstName = TextEditingController(text: response!.data!.firstName);
      lastName = TextEditingController(text: response!.data!.lastName);
      mobileNumber = TextEditingController(text: response!.data!.mobile);
      emailAddress = TextEditingController(text: response!.data!.email);
    } catch (e) {
      if (kDebugMode) {
        print("UserDetailResponseModel Error==>$e==");
      }
      _getUserDetailResponse = ApiResponse.error(message: 'error');
    }
    update();
  }

  ApiResponse _getUserDetailResponseWithoutModel =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getUserDetailResponseWithoutModel =>
      _getUserDetailResponseWithoutModel;

  Future<void> getUserDetailDataWithoutModel(
      {bool isLoading = true,
      bool isAnotherUser = false,
      String? userId}) async {
    if (isLoading) {
      _getUserDetailResponseWithoutModel =
          ApiResponse.loading(message: 'Loading');
    }
    try {
      var data = await GetUserDetailRepo.getUserDetailWithoutModel(
          userId: userId, isAnotherUser: isAnotherUser);
      if (kDebugMode) {
        print("UserDetailResponseWithoutModel==>$data");
      }
      _getUserDetailResponseWithoutModel = ApiResponse.complete(data);
    } catch (e) {
      if (kDebugMode) {
        print("UserDetailResponseWithoutModel Error==>$e==");
      }
      _getUserDetailResponseWithoutModel = ApiResponse.error(message: 'error');
    }
    update();
  }

  ApiResponse _getUserVoteDetailResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getUserVoteDetailResponse => _getUserVoteDetailResponse;

  Future<void> getUserVoteDetail(
      {bool isLoading = true, required String targetUserId}) async {
    if (isLoading) {
      _getUserVoteDetailResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      var data = await GetUserVoteDetailRepo.getUserVoteDetail(
        targetUserId: targetUserId,
      );
      if (kDebugMode) {
        print("GetUserVoteDetailResponse==>$data");
      }
      _getUserVoteDetailResponse = ApiResponse.complete(data);
    } catch (e) {
      if (kDebugMode) {
        print("GetUserVoteDetailResponse Error==>$e==");
      }
      _getUserVoteDetailResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
