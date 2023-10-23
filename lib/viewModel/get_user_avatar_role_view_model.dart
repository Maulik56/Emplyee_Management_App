import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/models/response_model/status_response_model.dart';
import 'package:news_app/repo/get_avatar_list_repo.dart';
import 'package:news_app/repo/get_qualification_list_repo.dart';
import 'package:news_app/repo/get_role_list_repo.dart';
import '../models/response_model/avatar_response_model.dart';
import '../models/response_model/qualification_response_model.dart';
import '../models/response_model/role_response_model.dart';
import '../services/api_service/api_response.dart';

class GetUserAvatarRoleViewModel extends GetxController {

  TextEditingController position = TextEditingController();

  setPosition(TextEditingController value){
    position=value;
    update();
  }


  ApiResponse _getAvatarListResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getAvatarListResponse => _getAvatarListResponse;

  Future<void> getAvatarList({bool isLoading = true}) async {
    if (isLoading) {
      _getAvatarListResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      AvatarResponseModel response = await GetAvatarListRepo.getAvatarList();
      if (kDebugMode) {
        print("AvatarResponseModel==>$response");
      }

      _getAvatarListResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("AvatarResponseModel Error==>$e==");
      }
      _getAvatarListResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
  RoleResponseModel? response;

  ApiResponse _getRoleListResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getRoleListResponse => _getRoleListResponse;

  Future<void> getRoleList({bool isLoading = true}) async {
    if (isLoading) {
      _getRoleListResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
       response = await GetRoleListRepo.getRoleList();
      if (kDebugMode) {
        print("RoleResponseModel==>$response");
      }

      _getRoleListResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("RoleResponseModel Error==>$e==");
      }
      _getRoleListResponse = ApiResponse.error(message: 'error');
    }
    update();
  }

  List qualificationList = [];
  List tempQualificationList = [];

  void addQualification(String value) {
    if (qualificationList.contains(value)) {
      qualificationList.remove(value);
    } else {
      qualificationList.add(value);
    }
    update();
  }

  List qualificationImageIdList = [];
  List tempQualificationImageIdList = [];

  void addQualificationImageId(String value) {
    if (qualificationImageIdList.contains(value)) {
      qualificationImageIdList.remove(value);
    } else {
      qualificationImageIdList.add(value);
    }
    update();
  }

  void updateQualification(List value) {
    qualificationList = value;
    tempQualificationList = [...qualificationList];

    update();
  }

  void updateQualificationImageId(List value) {
    qualificationImageIdList = value;
    tempQualificationImageIdList = [...qualificationImageIdList];
    update();
  }

  void clearQualification() {
    qualificationList.clear();
    update();
  }

  void clearQualificationImageId() {
    qualificationImageIdList.clear();
    update();
  }

  ApiResponse _getQualificationListResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getQualificationListResponse => _getQualificationListResponse;

  Future<void> getQualificationList({bool isLoading = true}) async {
    if (isLoading) {
      _getQualificationListResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      QualificationResponseModel response =
          await GetQualificationListRepo.getQualificationList();
      if (kDebugMode) {
        print("QualificationResponseModel==>$response");
      }

      _getQualificationListResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("QualificationResponseModel Error==>$e==");
      }
      _getQualificationListResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
