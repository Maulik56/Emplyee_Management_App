import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/response_model/resource_category_response_model.dart';
import '../repo/get_resource_category_repo.dart';
import '../services/api_service/api_response.dart';
import '../view/add_new_resource_screen.dart';

class GetResourceCategoryViewModel extends GetxController {
  File? image;

  Future pickImageFromCamera() async {
    final obtainedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (obtainedFile != null) {
      image = File(obtainedFile.path);
      update();
    }
  }

  CategoryList selectedSegment = CategoryList.category1;

  void changeSegment(CategoryList value) {
    selectedSegment = value;
    update();
  }

  ApiResponse _getResourceCategoryResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getResourceCategoryResponse => _getResourceCategoryResponse;

  Future<void> getResourceCategory({bool isLoading = true}) async {
    if (isLoading) {
      _getResourceCategoryResponse = ApiResponse.loading(message: 'Loading');
    }
    try {
      ResourceCategoryResponseModel response =
          await GetResourceCategoryRepo.getResourceCategory();
      if (kDebugMode) {
        print("ResourceCategoryResponseModel==>$response");
      }

      _getResourceCategoryResponse = ApiResponse.complete(response);
    } catch (e) {
      if (kDebugMode) {
        print("ResourceCategoryResponseModel Error==>$e==");
      }
      _getResourceCategoryResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
