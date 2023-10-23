import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_text.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/color_const.dart';
import 'package:news_app/repo/send_notification_repo.dart';
import 'package:news_app/view/main_screen.dart';
import '../services/notification_service/app_notification_service.dart';
import '../viewModel/notification_log_view_model.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  NotificationLogViewModel notificationLogViewModel =
      Get.put(NotificationLogViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.commonAppBar(title: 'Notification Logs', actions: [
        TextButton(
            onPressed: () {
              notificationLogViewModel.clearLogs();
            },
            child: Text(
              "Clear",
              style: TextStyle(
                  fontSize: 15.sp, color: CommonColor.appBarButtonColor),
            ))
      ]),
      body: GetBuilder<NotificationLogViewModel>(
        builder: (controller) {
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(15.0),
            itemCount: controller.notificationLogs.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.sp),
                  child: SelectableText(
                    controller.notificationLogs[index],
                    style: const TextStyle(fontSize: 15),
                  ),
                )
              ],
            ),
          );
        },
      ),
      drawer: DrawerWidget(isLogScreen: true),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 20.sp),
        child: SafeArea(
          child: CommonWidget.commonButton(
              onTap: () async {
                await SendNotificationRepo.sendNotificationRepo();
              },
              text: "Send a test notification"),
        ),
      ),
    );
  }
}
