import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/banner_widget.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/api_const.dart';
import 'package:news_app/constant/color_const.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/repo/send_alert_repo.dart';
import 'package:news_app/view/main_screen.dart';
import '../components/common_text.dart';
import '../constant/image_const.dart';
import '../models/response_model/alert_list_reponse_model.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import 'package:get/get.dart';
import '../viewModel/alert_view_model.dart';
import '../viewModel/get_banner_view_model.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class AlertTeamScreen extends StatefulWidget {
  const AlertTeamScreen({super.key});

  @override
  State<AlertTeamScreen> createState() => _AlertTeamScreenState();
}

class _AlertTeamScreenState extends State<AlertTeamScreen> {
  final NavigationService _navigationService = NavigationService();

  AlertViewModel alertViewModel = Get.put(AlertViewModel());

  GetBannerViewModel getBannerViewModel = Get.put(GetBannerViewModel());

  @override
  void initState() {
    getBannerViewModel.getBannerInfo(screenId: Banners.teamAlerts);
    alertViewModel.getAlertList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: Builder(builder: (context) {
      final progress = ProgressHUD.of(context);
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidget.commonAppBar(
          title: AlertTeamStrings.alertTeamMembers,
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
              style: TextStyle(fontSize: 14.sp, color: Colors.blue),
            ),
          ),
        ),
        body: Column(
          children: [
            BannerWidget(),
            Padding(
              padding: EdgeInsets.only(left: 13.sp, right: 13.sp, top: 16.sp),
              child: CommonText.textBoldWeight400(
                  text: AlertTeamStrings.warning.toUpperCase(),
                  textAlign: TextAlign.center,
                  color: CommonColor.red,
                  fontSize: 16.sp),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 6.sp, right: 6.sp, top: 10.sp, bottom: 18.sp),
              child: CommonText.textBoldWeight400(
                  text: AlertTeamStrings.allAlerts,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                  fontSize: 12.sp),
            ),
            Expanded(child: SingleChildScrollView(
              child: GetBuilder<AlertViewModel>(
                builder: (controller) {
                  if (controller.getAlertListResponse.status ==
                      Status.LOADING) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (controller.getAlertListResponse.status ==
                      Status.COMPLETE) {
                    AlertListResponseModel alertListResponseModel =
                        controller.getAlertListResponse.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          height: 0,
                          thickness: 1,
                        ),
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: alertListResponseModel.data!.items!.length,
                          itemBuilder: (context, index) {
                            final alertList =
                                alertListResponseModel.data!.items![index];
                            print('EMOJI${utf8convert(alertList.title!)}');
                            return alertList.type == 'header'
                                ? Container(
                                    height: 30.sp,
                                    color: const Color(0xfff2f2f4),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 15.sp,
                                        ),
                                        Text(alertList.title!),
                                      ],
                                    ),
                                  )
                                : Material(
                                    color: Colors.white,
                                    child: ListTile(
                                      onTap: () async {
                                        if (alertList.enabled!) {
                                          buildChangeActionSheet(context,
                                              alertId: alertList.id!);
                                        } else {
                                          showOkAlertDialog(
                                            context: context,
                                            builder: (context, child) =>
                                                AdaptiveDialogBox(
                                              message: alertList.message!,
                                            ),
                                          );
                                        }
                                      },
                                      minVerticalPadding: 10,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 13.sp),
                                      leading: CachedNetworkImage(
                                        fadeInDuration: Duration.zero,
                                        imageUrl: AppImages.appImagePrefix +
                                            alertList.imgId!,
                                        width: 26.sp,
                                        height: 40.sp,
                                        alignment: Alignment.center,
                                      ),
                                      title: CommonText.textBoldWeight400(
                                          text: utf8convert(
                                              alertList.title.toString())),
                                      subtitle: Text(alertList.subTitle!),
                                      trailing: const Icon(Icons.chevron_right),
                                    ),
                                  );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            height: 0,
                            thickness: 1,
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
            ))
          ],
        ),
      );
    }));
  }

  /// Send Alert Action Sheet:
  Future<dynamic> buildChangeActionSheet(BuildContext bottomSheetContext,
      {required String alertId}) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: List.generate(
        1,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: "YES, SEND ALERT", color: CommonColor.red),
          onPressed: (context) async {
            Navigator.of(bottomSheetContext).pop();
            var response = await SendAlertRepo.sendAlert(alertId: alertId);

            if (response['success'] == true) {
              CommonWidget.getSnackBar(bottomSheetContext,
                  color: CommonColor.blue,
                  duration: 2,
                  message: response['data']['message']);
            } else {
              CommonWidget.getSnackBar(bottomSheetContext,
                  color: CommonColor.red,
                  duration: 2,
                  message: response['error']);
            }
          },
        ),
      ),
      cancelAction: CancelAction(
        title: CommonText.textBoldWeight700(text: AppStrings.cancel),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }
}
