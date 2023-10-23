import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_critical_alert_permission_ios/flutter_critical_alert_permission_ios.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_text.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/services/navigation_service/navigation_service.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/connectivity_checker.dart';
import '../constant/color_const.dart';
import '../constant/image_const.dart';
import '../constant/routes_const.dart';
import '../services/notification_service/awesome_notification_service.dart';

class EnableNotificationScreen extends StatefulWidget {
  const EnableNotificationScreen({Key? key}) : super(key: key);

  @override
  State<EnableNotificationScreen> createState() =>
      _EnableNotificationScreenState();
}

class _EnableNotificationScreenState extends State<EnableNotificationScreen> {
  final NavigationService _navigationService = NavigationService();

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  @override
  void initState() {
    connectivityChecker.checkInterNet();
    initPlatformState();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25, top: 25.sp),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkResponse(
                  onTap: () {
                    _navigationService.pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            GetBuilder<ConnectivityChecker>(
              builder: (controller) {
                if (controller.isConnected) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 30.sp,
                      ),
                      Container(
                        height: 50.sp,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppImages.notification),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18.sp,
                      ),
                      CommonText.textBoldWeight700(
                        text: EnableNotificationStrings.enableNotification,
                        fontSize: 26.sp,
                      ),
                      SizedBox(
                        height: 18.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20.sp,
                            right: 20.sp,
                            top: 25.sp,
                            bottom: 25.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText.textBoldWeight400(
                                text: EnableNotificationStrings
                                    .receiveImportantNotification,
                                textAlign: TextAlign.center,
                                color: CommonColor.greyColor838589,
                                fontSize: 13.sp),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50.sp,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.sp),
                        child: CommonWidget.commonButton(
                          onTap: () async {
                            try {
                              await Permission.notification.isDenied
                                  .then((value) {
                                if (value) {
                                  Permission.notification.request();
                                }
                              });

                              await NotificationController
                                  .initializeLocalNotifications();

                              /// Request critical alert permission:
                              if (Platform.isIOS) {
                                _navigationService
                                    .navigateTo(AppRoutes.allSetScreen);
                                try {
                                  await FlutterCriticalAlertPermissionIos
                                      .requestCriticalAlertPermission();
                                } catch (e) {
                                  // TODO
                                }
                              }
                            } catch (e) {
                              _navigationService
                                  .navigateTo(AppRoutes.allSetScreen);
                              // TODO
                            }
                            _navigationService
                                .navigateTo(AppRoutes.allSetScreen);
                          },
                          text: EnableNotificationStrings.enableNotificationNow,
                        ),
                      ),
                      SizedBox(
                        height: 30.sp,
                      ),
                      TextButton(
                        onPressed: () {
                          _navigationService.navigateTo(AppRoutes.allSetScreen);
                        },
                        child: const Text(
                          EnableNotificationStrings.maybeLater,
                          style: TextStyle(
                            color: Color(0xffaaaaaa),
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return NoInternetWidget(
                    onPressed: () {},
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
