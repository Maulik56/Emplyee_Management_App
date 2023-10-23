import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/banner_widget.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/api_const.dart';
import 'package:news_app/constant/color_const.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/repo/send_autobook_value_repo.dart';
import '../components/common_text.dart';
import '../constant/image_const.dart';
import '../models/response_model/auto_book_on_response_model.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import 'package:get/get.dart';
import '../viewModel/get_auto_book_on_view_model.dart';
import '../viewModel/get_banner_view_model.dart';

enum AutoBookTimings { time, duration }

class AutoBookOnScreen extends StatefulWidget {
  const AutoBookOnScreen({super.key});

  @override
  State<AutoBookOnScreen> createState() => _AutoBookOnScreenState();
}

class _AutoBookOnScreenState extends State<AutoBookOnScreen> {
  final NavigationService _navigationService = NavigationService();

  GetAutoBookOnViewModel getAutoBookOnViewModel =
      Get.put(GetAutoBookOnViewModel());

  GetBannerViewModel getBannerViewModel = Get.put(GetBannerViewModel());

  @override
  void initState() {
    getBannerViewModel.getBannerInfo(screenId: Banners.autoBook);
    getAutoBookOnViewModel.getAutoBookOnData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          final progress = ProgressHUD.of(context);
          return Scaffold(
            backgroundColor: const Color(0xfff2f2f4),
            appBar: CommonWidget.commonAppBar(
              title: AutoBookOnStrings.autoBookOn,
              leadingWidth: 100.sp,
              leading: TextButton(
                onPressed: () async {
                  progress!.show();
                  await getBannerViewModel.getBannerInfo(
                      screenId: Banners.mainScreen);
                  _navigationService.pop();
                  progress.dismiss();
                },
                child: Text(
                  "Dismiss",
                  style: TextStyle(
                      fontSize: 14.sp, color: CommonColor.appBarButtonColor),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  BannerWidget(),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 13.sp, right: 13.sp, top: 25.sp, bottom: 15.sp),
                    child: CommonText.textBoldWeight400(
                        text: AutoBookOnStrings.selectAnOptionBelow,
                        textAlign: TextAlign.center,
                        color: CommonColor.blackColor0C1A30,
                        fontSize: 13.sp),
                  ),
                  GetBuilder<GetAutoBookOnViewModel>(
                    builder: (controller) {
                      if (controller.getAutoBookOnResponse.status ==
                          Status.LOADING) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (controller.getAutoBookOnResponse.status ==
                          Status.COMPLETE) {
                        AutoBookOnResponseModel autoBookOnResponseModel =
                            controller.getAutoBookOnResponse.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Cupertino Sliding Segmented Control:
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.sp, vertical: 10.sp),
                              color: Colors.white,
                              child: Center(
                                child: CupertinoSlidingSegmentedControl<
                                    AutoBookTimings>(
                                  backgroundColor: CupertinoColors.systemGrey5,

                                  thumbColor: Colors.white,
                                  // This represents the currently selected segmented control.
                                  groupValue: controller.selectedSegment,
                                  // Callback that sets the selected segmented control.

                                  onValueChanged: (AutoBookTimings? value) {
                                    if (value != null) {
                                      controller.changeSegment(value);
                                      switch (value) {
                                        case AutoBookTimings.time:
                                          break;
                                        case AutoBookTimings.duration:
                                          break;
                                      }
                                    }
                                  },
                                  children: <AutoBookTimings, Widget>{
                                    AutoBookTimings.time: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.sp),
                                      child: Text(
                                        autoBookOnResponseModel
                                            .data!.categories!.first.text!,
                                        style: TextStyle(
                                            color: CupertinoColors.black,
                                            fontSize: 12.sp),
                                      ),
                                    ),
                                    AutoBookTimings.duration: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.sp),
                                      child: Text(
                                        autoBookOnResponseModel
                                            .data!.categories!.last.text!,
                                        style: TextStyle(
                                            color: CupertinoColors.black,
                                            fontSize: 12.sp),
                                      ),
                                    ),
                                  },
                                ),
                              ),
                            ),
                            const Divider(
                              height: 0,
                              thickness: 1,
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              itemCount: controller.selectedSegment ==
                                      AutoBookTimings.time
                                  ? autoBookOnResponseModel
                                      .data!.items!.time!.length
                                  : autoBookOnResponseModel
                                      .data!.items!.duration!.length,
                              itemBuilder: (context, index) {
                                Duration? timeList;
                                Duration? durationList;
                                if (controller.selectedSegment ==
                                    AutoBookTimings.time) {
                                  timeList = autoBookOnResponseModel
                                      .data!.items?.time![index];
                                } else {
                                  durationList = autoBookOnResponseModel
                                      .data!.items?.duration![index];
                                }
                                return Material(
                                  color: Colors.white,
                                  child: ListTile(
                                    onTap: () async {
                                      progress!.show();
                                      var response = await SendAutoBookValueRepo
                                          .sendAutoBookValue(
                                              id: controller.selectedSegment ==
                                                      AutoBookTimings.time
                                                  ? timeList!.id!
                                                  : durationList!.id!,
                                              value:
                                                  controller.selectedSegment ==
                                                          AutoBookTimings.time
                                                      ? timeList!.value!
                                                      : durationList!.value!);

                                      if (response['success'] == true) {
                                        await getBannerViewModel.getBannerInfo(
                                            screenId: Banners.mainScreen);
                                        _navigationService.pop();
                                      } else {
                                        showOkAlertDialog(
                                          context: context,
                                          builder: (context, child) =>
                                              AdaptiveDialogBox(
                                            message: response['error'],
                                          ),
                                        );
                                      }
                                      progress.dismiss();
                                    },
                                    minVerticalPadding: 0,
                                    leading: buildCachedNetworkImage(
                                        controller, timeList, durationList),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 13.sp),
                                    title: Text(
                                      controller.selectedSegment ==
                                              AutoBookTimings.time
                                          ? timeList!.text!
                                          : durationList!.text!,
                                      style: TextStyle(
                                          color: controller.selectedSegment ==
                                                  AutoBookTimings.time
                                              ? timeList!.fontColor != null
                                                  ? Color(int.parse(
                                                      "0xff${timeList.fontColor!.replaceAll("#", "").removeAllWhitespace}f"))
                                                  : Colors.black
                                              : durationList!.fontColor != null
                                                  ? Color(int.parse(
                                                      "0xff${durationList.fontColor!.replaceAll("#", "").removeAllWhitespace}f"))
                                                  : Colors.black),
                                    ),
                                    trailing: const Icon(Icons.chevron_right),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) => Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.sp),
                                child: const Divider(
                                  height: 0,
                                  thickness: 1,
                                ),
                              ),
                            ),
                            const Divider(
                              height: 0,
                              thickness: 1,
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCachedNetworkImage(GetAutoBookOnViewModel controller,
      Duration? timeList, Duration? durationList) {
    try {
      return CachedNetworkImage(
          errorWidget: (context, url, error) =>
              SizedBox(width: 24.sp, height: 24.sp),
          imageUrl: controller.selectedSegment == AutoBookTimings.time
              ? AppImages.appImagePrefix + timeList!.imageId!
              : AppImages.appImagePrefix + durationList!.imageId!,
          width: 24.sp,
          height: 24.sp);
    } catch (e) {
      return SizedBox(width: 24.sp, height: 24.sp);
    }
  }
}
