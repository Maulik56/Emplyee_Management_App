import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ConnectivityChecker extends GetxController {
  ConnectivityResult? subscription;

  bool isConnected = true;

  Future checkInterNet() async {
    subscription = await (Connectivity().checkConnectivity());
    if (subscription == ConnectivityResult.mobile) {
      if (kDebugMode) {
        print('I am  connected to internet mobile');
      }
      isConnected = true;
      // I am connected to a mobile network.
    } else if (subscription == ConnectivityResult.wifi) {
      if (kDebugMode) {
        print('I am  connected to internet wifi');
      }
      isConnected = true;
      // I am connected to a wifi network.
    } else {
      if (kDebugMode) {
        print('I am not connected to internet');
      }
      isConnected = false;
    }
    update();
  }
}
