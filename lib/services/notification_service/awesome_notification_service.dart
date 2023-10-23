import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../get_storage_services/get_storage_service.dart';
import '../../viewModel/get_header_data_view_model.dart';
import '../../viewModel/get_status_data_view_model.dart';
import '../../viewModel/message_view_model.dart';
import '../../viewModel/notification_log_view_model.dart';
import 'package:http/http.dart' as http;

class NotificationController {
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();
  static ReceivedAction? initialAction;

  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
        onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
        onFcmTokenHandle: NotificationController.myFcmTokenHandle,
        onNativeTokenHandle: NotificationController.myNativeTokenHandle,
        licenseKeys: [
          // me.carda.awesomeNotificationsFcmExample
          'B3J3yxQbzzyz0KmkQR6rDlWB5N68sTWTEMV7k9HcPBroUh4RZ/Og2Fv6Wc/lE'
              '2YaKuVY4FUERlDaSN4WJ0lMiiVoYIRtrwJBX6/fpPCbGNkSGuhrx0Rekk'
              '+yUTQU3C3WCVf2D534rNF3OnYKUjshNgQN8do0KAihTK7n83eUD60=',

          // me.carda.awesome_notifications_fcm_example
          'UzRlt+SJ7XyVgmD1WV+7dDMaRitmKCKOivKaVsNkfAQfQfechRveuKblFnCp4'
              'zifTPgRUGdFmJDiw1R/rfEtTIlZCBgK3Wa8MzUV4dypZZc5wQIIVsiqi0Zhaq'
              'YtTevjLl3/wKvK8fWaEmUxdOJfFihY8FnlrSA48FW94XWIcFY=',
        ],
        debug: debug);
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);
    if (receivedAction == null) return;

    print('Notification action launched app: $receivedAction');
  }

  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    // Fluttertoast.showToast(
    //     msg: 'Silent data received',
    //     backgroundColor: Colors.blueAccent,
    //     textColor: Colors.white,
    //     fontSize: 16);

    print('"SilentData": ${silentData.toString()}');

    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      print("bg");
      // executeLongTaskInBackground();
    } else {
      print("FOREGROUND");
    }

    print('mySilentDataHandle received a FcmSilentData execution');
    await executeLongTaskInBackground();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************

  static Future<void> executeLongTaskInBackground() async {
    print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    print(re.body);
    print("long task done");
  }

  static NotificationLogViewModel notificationLogViewModel =
      Get.put(NotificationLogViewModel());

  static GetStatusDataViewModel getStatusDataViewModel =
      Get.put(GetStatusDataViewModel());

  static GetHeaderDataViewModel getHeaderDataViewModel =
      Get.put(GetHeaderDataViewModel());

  static MessageViewModel messageViewModel = Get.put(MessageViewModel());

  // static Future initializeNotification() async {
  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  // }

  /// To get FCM token of the device:
  // static Future getFcmToken() async {
  //   // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //
  //   try {
  //     String? token = await firebaseMessaging.getToken();
  //     debugPrint("=========fcm-token===$token");
  //     await GetStorageServices.setFCMToken(token!);
  //     return token;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  /// Request FCM token to Firebase AWESOME_FCM
  static Future<String> getFirebaseMessagingToken() async {
    String firebaseAppToken = '';
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        firebaseAppToken =
            await AwesomeNotificationsFcm().requestFirebaseAppToken();
        await GetStorageServices.setFCMToken(firebaseAppToken);
        log('FCM TOKEN==${firebaseAppToken}');
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }
    return firebaseAppToken;
  }

  // static void showMsgHandler() async {
  //   try {
  //     FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
  //       RemoteNotification? notification = message!.notification;
  //
  //       try {
  //         debugPrint('Notification Title  ${notification!.title}');
  //         debugPrint('Notification Body   ${notification.body}');
  //         debugPrint("JSON==>>${message.data}");
  //       } catch (e) {
  //         // TODO
  //       }
  //
  //       try {
  //         if (message.data['id'] == "status_update") {
  //           getStatusDataViewModel.getStatusData();
  //           getHeaderDataViewModel.getHeaderData();
  //         } else if (message.data['id'] == "chat_msg") {
  //           messageViewModel.loadMessages();
  //         }
  //       } catch (e) {
  //         // TODO
  //       }
  //
  //       try {
  //         notificationLogViewModel
  //             .updateLogs2('notification received: ${message.data.toString()}');
  //       } catch (e) {
  //         // TODO
  //       }
  //
  //       if (Platform.isAndroid) {
  //         AndroidForegroundService.startAndroidForegroundService(
  //           foregroundStartMode: ForegroundStartMode.stick,
  //           foregroundServiceType: ForegroundServiceType.phoneCall,
  //           content: NotificationContent(
  //               id: 2341234,
  //               body: notification?.body ?? "test",
  //               title: notification?.title ?? "test",
  //               channelKey: 'alerts',
  //               category: NotificationCategory.Service),
  //         );
  //       }
  //     });
  //   } on FirebaseException catch (e) {
  //     debugPrint('notification error ${e.message}');
  //     return null;
  //   }
  //   return null;
  // }

  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    // Fluttertoast.showToast(
    //     msg: 'Fcm token received',
    //     backgroundColor: Colors.blueAccent,
    //     textColor: Colors.white,
    //     fontSize: 16);
    debugPrint('Firebase Token:"$token"');
    //
    // _instance._firebaseToken = token;
    // _instance.notifyListeners();
  }

  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    // Fluttertoast.showToast(
    //     msg: 'Native token received',
    //     backgroundColor: Colors.blueAccent,
    //     textColor: Colors.white,
    //     fontSize: 16);
    debugPrint('Native Token:"$token"');
  }

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
            channelKey: 'alerts',
            channelName: 'Callout Alerts',
            channelDescription: 'Callout alerts',
            playSound: true,
            onlyAlertOnce: false,
            criticalAlerts: true,
            soundSource: 'resource://raw/bleeper',
            importance: NotificationImportance.Max,
            defaultPrivacy: NotificationPrivacy.Public,
          ),
          NotificationChannel(
            channelKey: 'drivers',
            channelName: 'Low Driver Alert',
            channelDescription: 'Low driver alert',
            playSound: true,
            onlyAlertOnce: true,
            criticalAlerts: false,
            soundSource: 'resource://raw/horn',
            importance: NotificationImportance.Default,
            defaultPrivacy: NotificationPrivacy.Public,
          ),
          NotificationChannel(
            channelKey: 'chat',
            channelName: 'Chat Notification',
            channelDescription: 'Chat notification',
            playSound: true,
            onlyAlertOnce: true,
            criticalAlerts: false,
            soundSource: 'resource://raw/ping',
            importance: NotificationImportance.Default,
            defaultPrivacy: NotificationPrivacy.Public,
          ),
          NotificationChannel(
            channelKey: 'standard',
            channelName: 'Standard notifications',
            channelDescription: 'Standard notifications',
            playSound: true,
            onlyAlertOnce: true,
            importance: NotificationImportance.Default,
            defaultPrivacy: NotificationPrivacy.Private,
          ),
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    print('Message sent via notification input: ${receivedAction.payload}');
    print('Message Title: ${receivedAction.title}');
    print('Message Body: ${receivedAction.body}');

    try {
      if (receivedAction.payload != null) {
        if (receivedAction.payload!['id'] == "status_update") {
          getStatusDataViewModel.getStatusData();
          getHeaderDataViewModel.getHeaderData();
        } else if (receivedAction.payload!['id'] == "chat_msg") {
          messageViewModel.loadMessages();
        }
      }
    } catch (e) {
      // TODO
    }

    if (receivedAction.title != null && receivedAction.body != null) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: receivedAction.id ?? 2341234,
            channelKey: 'alerts',
            title: receivedAction.title,
            body: receivedAction.body),
      );
    }

    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      print('Received Silent Action');
      // For background actions, you must hold the execution until the end
    } else {}
  }
}
