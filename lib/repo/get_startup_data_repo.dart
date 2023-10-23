import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/constant/app_info.dart';
import 'package:news_app/get_storage_services/get_storage_service.dart';
import 'package:news_app/repo/update_subscription_event_repo.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../constant/api_const.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../services/in_app_purchase_service/revenue_cat_service.dart';

class GetStartupDataRepo {
  static Future<bool> getStartupData() async {
    final deviceId = await PlatformDeviceId.getDeviceId;
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;

    final allInfo = deviceInfo.data;
    await AppInfo.getPackageInfo();

    //i/f (Platform.isIOS) {
    await RevenueCatServices.initPlatformState();
    //}

    CustomerInfo? customerInfo;

    //if (Platform.isIOS) {
    customerInfo = await Purchases.getCustomerInfo();
    //}

    if (kDebugMode) {
      print("Device Id===>>$deviceId");
    }

    var header = {"uuid": "$deviceId"};

    var reqBody = {
      "app_version": AppInfo.version,
      "app_build": AppInfo.buildNumber,
      "device_info": allInfo
    };

    http.Response response = await http.post(
      Uri.parse(
        BaseUrl.baseUrl + EndPoints.startup,
      ),
      headers: header,
      body: json.encode(reqBody),
    );

    var result = jsonDecode(response.body);

    try {
      /// Save UUID in local storage:
      GetStorageServices.setUuid(deviceId!);
    } catch (e) {}

    if (kDebugMode) {
      print("------- STARTUP API CALLED----------");
      print('-------LOGO ID-----${result['data']['logo_id']}');
      print('-------STARTUP RESPONSE-----${result['success']}');
    }

    try {
      //if (Platform.isIOS) {
      if (customerInfo.entitlements.active.isNotEmpty) {
        await UpdateSubscriptionEventRepo.updateSubscription('subscribed');
      } else {
        await UpdateSubscriptionEventRepo.updateSubscription('unsbscribed');
      }
      //}
    } catch (e) {
      // TODO
    }

    return result['success'];
  }
}
