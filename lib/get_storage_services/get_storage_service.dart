import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_app/services/firebase_service/apple_auth_service.dart';
import 'package:news_app/services/firebase_service/google_auth_service.dart';
import '../services/api_service/api_response.dart';
import '../viewModel/get_header_data_view_model.dart';
import '../viewModel/get_status_data_view_model.dart';
import 'package:get/get.dart';

import '../viewModel/get_user_detail_view_model.dart';

class GetStorageServices {
  static GetStorage getStorage = GetStorage();

  static GetStatusDataViewModel getStatusDataViewModel =
      Get.put(GetStatusDataViewModel());

  static GetHeaderDataViewModel getHeaderDataViewModel =
      Get.put(GetHeaderDataViewModel());

  static GetUserDetailViewModel getUserDetailViewModel =
      Get.put(GetUserDetailViewModel());

  /// user uid
  static setUuid(String userUid) {
    getStorage.write('uuid', userUid);
  }

  static getUuid() {
    return getStorage.read('uuid');
  }

  /// Set email:
  static setUserEmail(String email) {
    getStorage.write('email', email);
  }

  static getUserEmail() {
    return getStorage.read('email');
  }

  /// Set Next Screen Preference:
  static setNextScreen(String screen) {
    getStorage.write('screen', screen);
  }

  static getNextScreen() {
    return getStorage.read('screen');
  }

  /// Set FCM token:
  static setFCMToken(String token) {
    getStorage.write('token', token);
  }

  static getFCMToken() {
    return getStorage.read('token');
  }

  /// Set code:
  static setCode(String code) {
    getStorage.write('code', code);
  }

  static getCode() {
    return getStorage.read('code');
  }

  /// Set userId:
  static setUserId(String id) {
    getStorage.write('id', id);
  }

  static getUserId() {
    return getStorage.read('id');
  }

  static logOut() {
    try {
      getStatusDataViewModel.changeRefreshStatus(true);
      getHeaderDataViewModel.getHeaderDataResponse.status == Status.LOADING;
      getUserDetailViewModel.getUserId("");
      getUserDetailViewModel.getIsAnotherUser(false);
    } catch (e) {
      // TODO
    }
    getStorage.remove('isUserLoggedIn');
    getStorage.remove('screen');
    getStorage.remove('email');
    getStorage.remove('id');

    try {
      GoogleAuthService.signOut();
    } catch (e) {
      // TODO
    }

    try {
      AppleAuthService.signOut();
    } catch (e) {
      // TODO
    }

    try {
      FirebaseAuth.instance.signOut();
    } catch (e) {
      // TODO
    }
  }
}
