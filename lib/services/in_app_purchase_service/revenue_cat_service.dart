import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/services/in_app_purchase_service/paywall.dart';
import 'package:news_app/services/in_app_purchase_service/singletons_data.dart';
import 'package:news_app/services/in_app_purchase_service/store_config.dart';
import 'package:news_app/services/in_app_purchase_service/styles.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../components/common_widget.dart';
import '../../repo/update_subscription_event_repo.dart';
import 'constant.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class RevenueCatServices {
  static Future<void> initPlatformState() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setLogLevel(LogLevel.debug);

    /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) {
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = null
        ..observerMode = false;
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = null
        ..observerMode = false;
    }
    await Purchases.configure(configuration);

    appData.appUserID = await Purchases.appUserID;

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      appData.appUserID = await Purchases.appUserID;

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      (customerInfo.entitlements.all[entitlementID] != null &&
              customerInfo.entitlements.all[entitlementID]!.isActive)
          ? appData.entitlementIsActive = true
          : appData.entitlementIsActive = false;
    });
  }

  static manageUser(String task, String newAppUserID, BuildContext context,
      CustomerInfo customerInfo) async {
    /*
      How to login and identify your users with the Purchases SDK.

      Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    */

    try {
      if (task == "login") {
        await Purchases.logIn(newAppUserID);
      } else if (task == "logout") {
        await Purchases.logOut();
      } else if (task == "restore") {
        await Purchases.restorePurchases();
        if (customerInfo.entitlements.active.isNotEmpty) {
          await UpdateSubscriptionEventRepo.updateSubscription('subscribed');
          showOkAlertDialog(
              context: context,
              builder: (context, child) => AdaptiveDialogBox(
                    message: 'Subscription restored successfully',
                  ));
        } else {
          await UpdateSubscriptionEventRepo.updateSubscription('unsubscribed');
          showOkAlertDialog(
              context: context,
              builder: (context, child) => AdaptiveDialogBox(
                    message: 'Unable to find active subscription',
                  ));
        }
      }

      appData.appUserID = await Purchases.appUserID;
    } on PlatformException catch (e) {
      await showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
              title: "Error", content: e.message!, buttonText: 'OK'));
    }
  }

  static void showPurchaseSheet(BuildContext context) async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]!.isActive == true) {
    } else {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        await showDialog(
            context: context,
            builder: (BuildContext context) => ShowDialogToDismiss(
                title: "Error", content: e.message!, buttonText: 'OK'));
      }

      if (offerings == null || offerings.current == null) {
        // offerings are empty, show a message to your user
      } else {
        // current offering is available, show paywall
        await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          backgroundColor: kColorBackground,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Paywall(
                offering: offerings!.current!,
              );
            });
          },
        );
      }
    }
  }
}
