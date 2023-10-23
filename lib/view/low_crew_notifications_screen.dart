import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_text.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/components/description_widget.dart';
import 'package:news_app/constant/api_const.dart';
import 'package:news_app/constant/color_const.dart';
import 'package:news_app/constant/image_const.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/repo/change_crew_minimum_level_repo.dart';
import 'package:news_app/view/main_screen.dart';

import '../components/banner_widget.dart';
import '../components/connectivity_checker.dart';
import '../models/response_model/low_crew_notification_response_model.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import '../viewModel/get_banner_view_model.dart';
import '../viewModel/get_low_crew_notifications_view_model.dart';

class LowCrewNotificationScreen extends StatefulWidget {
  const LowCrewNotificationScreen({super.key});

  @override
  State<LowCrewNotificationScreen> createState() =>
      _LowCrewNotificationScreenState();
}

class _LowCrewNotificationScreenState extends State<LowCrewNotificationScreen> {
  GetLowCrewNotificationsViewModel getLowCrewNotificationsViewModel =
      Get.put(GetLowCrewNotificationsViewModel());

  GetBannerViewModel getBannerViewModel = Get.put(GetBannerViewModel());

  final NavigationService _navigationService = NavigationService();

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  @override
  void initState() {
    getBannerViewModel.getBannerInfo(screenId: Banners.lowCrewNotifications);
    getLowCrewNotificationsViewModel.getLowCrewNotificationsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: Builder(
      builder: (context) {
        final progress = ProgressHUD.of(context);
        return Scaffold(
          backgroundColor: const Color(0xfff2f2f4),
          appBar: CommonWidget.commonAppBar(
            title: LowCrewNotificationStrings.lowCrewNotifications,
          ),
          body: GetBuilder<ConnectivityChecker>(
            builder: (controller) {
              return controller.isConnected
                  ? Column(
                      children: [
                        BannerWidget(),
                        const DescriptionWidget(
                            description: LowCrewNotificationStrings
                                .receiveNotifications),
                        GetBuilder<GetLowCrewNotificationsViewModel>(
                          builder: (controller) {
                            if (controller
                                    .getLowCrewNotificationResponse.status ==
                                Status.LOADING) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50.sp),
                                  child: const CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (controller
                                    .getLowCrewNotificationResponse.status ==
                                Status.COMPLETE) {
                              LowCrewNotificationResponseModel
                                  lowCrewNotificationsData = controller
                                      .getLowCrewNotificationResponse.data;
                              if (lowCrewNotificationsData
                                  .data!.minLevels!.isNotEmpty) {
                                return Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    child: SafeArea(
                                      child: ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        itemCount: lowCrewNotificationsData
                                            .data!.minLevels!.length,
                                        itemBuilder: (context, index) {
                                          final lowCrewData =
                                              lowCrewNotificationsData
                                                  .data!.minLevels![index];
                                          return Material(
                                            color: Colors.white,
                                            child: ListTile(
                                              horizontalTitleGap: 1,
                                              onTap: () {
                                                buildChangeLevelSheet(context,
                                                    code: lowCrewData.code!,
                                                    progress: progress);
                                              },
                                              minVerticalPadding: 0,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 13.sp),
                                              leading: CachedNetworkImage(
                                                  fadeInDuration: Duration.zero,
                                                  imageUrl:
                                                      AppImages.appImagePrefix +
                                                          lowCrewData.imgId!,
                                                  width: 24.sp,
                                                  height: 24.sp),
                                              title: Text(lowCrewData.text ??
                                                  "No Text Found"),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CommonText.textBoldWeight400(
                                                    text: lowCrewData.detail!,
                                                    color: CommonColor.blue,
                                                  ),
                                                  SizedBox(
                                                    width: 10.sp,
                                                  ),
                                                  const Icon(
                                                      Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.sp),
                                          child: const Divider(
                                            height: 0,
                                            thickness: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: CommonText.textBoldWeight500(
                                      text: "No following crew found"),
                                );
                              }
                            } else {
                              return const SizedBox();
                            }
                          },
                        )
                      ],
                    )
                  : NoInternetWidget(
                      onPressed: () {
                        connectivityChecker.checkInterNet();
                        getBannerViewModel.getBannerInfo(
                            screenId: 'low_crew_notifications');
                        getLowCrewNotificationsViewModel
                            .getLowCrewNotificationsData();
                      },
                    );
            },
          ),
          drawer: DrawerWidget(isLowCrewNotification: true),
        );
      },
    ));
  }

  /// Change Level Sheet:
  Future<dynamic> buildChangeLevelSheet(
    BuildContext context, {
    required String code,
    final progress,
  }) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: List.generate(
        20,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: "${index + 1}", color: CommonColor.blue),
          onPressed: (context) async {
            Navigator.pop(context);
            progress!.show();
            await ChangeCrewMinimumLevelRepo.changeLevel(
                code: code, level: "${index + 1}");
            await getLowCrewNotificationsViewModel.getLowCrewNotificationsData(
                isLoading: false);

            progress.dismiss();
          },
        ),
      ),
      cancelAction: CancelAction(
        title: CommonText.textBoldWeight700(text: AppStrings.cancel),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }
}
