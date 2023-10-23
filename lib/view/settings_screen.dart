import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/image_const.dart';
import 'package:news_app/constant/routes_const.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/repo/sign_out_repo.dart';
import 'package:news_app/view/main_screen.dart';
import 'package:news_app/view/show_privacy_terms_screen.dart';
import 'package:news_app/viewModel/loader_view_model.dart';
import '../components/common_text.dart';
import '../constant/app_info.dart';
import '../constant/color_const.dart';
import '../get_storage_services/get_storage_service.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import 'package:in_app_review/in_app_review.dart';

import '../viewModel/get_team_info_view_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final deleteController = TextEditingController();

  String deleteAccount = "";

  LoaderViewModel settingsViewModel = Get.put(LoaderViewModel());

  final NavigationService _navigationService = NavigationService();

  final InAppReview inAppReview = InAppReview.instance;

  GetTeamInfoViewModel getTeamInfoViewModel = Get.put(GetTeamInfoViewModel());

  @override
  void initState() {
    getTeamInfoViewModel.getTeamInfo();
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
            title: AppStrings.settingsScreen,
          ),
          body: GetBuilder<GetTeamInfoViewModel>(
            builder: (controller) {
              if (controller.getTeamInfoResponse.status == Status.LOADING) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.getTeamInfoResponse.status == Status.COMPLETE) {
                var teamInfo = controller.getTeamInfoResponse.data;

                return ListView(
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: [
                      buildDivider(),
                      ListTile(
                        tileColor: Colors.white,
                        title: Text(AppStrings.appName),
                        trailing: Text(AppInfo.version),
                        minVerticalPadding: 0,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.sp, vertical: 0),
                        leading: Image.network(
                          'https://user-images.githubusercontent.com/1161351/225875139-a5fda3b9-f113-40b3-8368-20caec026fbe.png',
                          width: 24.sp,
                          height: 24.sp,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        title: const Text("Rate App"),
                        onTap: () async {
                          if (await inAppReview.isAvailable()) {
                            inAppReview.requestReview();
                          }
                        },
                        trailing: const Icon(Icons.chevron_right),
                        leading: Image.network(
                          'https://user-images.githubusercontent.com/1161351/225875145-8e5a37b8-87cf-4ebb-ab80-d1343c38addd.png',
                          width: 24.sp,
                          height: 24.sp,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        title: const Text("Get In Touch"),
                        onTap: () async {
                          _navigationService
                              .navigateTo(AppRoutes.contactUsScreen);
                        },
                        trailing: const Icon(Icons.chevron_right),
                        leading: Image.asset(
                          AppImages.message,
                          width: 24.sp,
                          height: 24.sp,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                      buildDivider(),
                      ListTile(
                        tileColor: Colors.white,
                        title: Text(teamInfo['data']['name'] ?? "Station"),
                        onTap: () async {
                          _navigationService
                              .navigateTo(AppRoutes.stationDetailScreen);
                        },
                        trailing: const Icon(Icons.chevron_right),
                        leading: Image.asset(
                          AppImages.station,
                          width: 24.sp,
                          height: 24.sp,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                      buildDivider(),
                      ListTile(
                        tileColor: Colors.white,
                        title: const Text("View Privacy Policy"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ShowPrivacyTermsScreen(docType: 'privacy'),
                            ),
                          );
                        },
                        trailing: const Icon(Icons.chevron_right),
                        leading: Image.asset(
                          AppImages.privacyPolicy,
                          width: 24.sp,
                          height: 24.sp,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        title: const Text("View Terms & Conditions"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ShowPrivacyTermsScreen(docType: 'terms'),
                            ),
                          );
                        },
                        trailing: const Icon(Icons.chevron_right),
                        leading: Image.asset(
                          AppImages.termsAndConditions,
                          width: 24.sp,
                          height: 24.sp,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                      buildDivider(),
                      ListTile(
                        tileColor: Colors.white,
                        title: const Text("Open App Settings"),
                        onTap: () {
                          AppSettings.openAppSettings();
                        },
                        trailing: const Icon(Icons.chevron_right),
                        leading: Image.network(
                          'https://cdn-icons-png.flaticon.com/512/7891/7891732.png',
                          width: 24.sp,
                          height: 24.sp,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                      buildDivider(),
                      ListTile(
                        tileColor: Colors.white,
                        title: const Text("Leave Team"),
                        onTap: () {
                          _navigationService
                              .navigateTo(AppRoutes.leaveTeamScreen);
                        },
                        trailing: const Icon(Icons.chevron_right),
                        leading: Image.network(
                          'https://user-images.githubusercontent.com/1161351/225875144-1397a334-c08c-4101-a92d-01f4c4dbcc0f.png',
                          width: 24.sp,
                          height: 24.sp,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        title: const Text("Delete Account"),
                        onTap: () {
                          _navigationService
                              .navigateTo(AppRoutes.deleteAccountScreen);
                        },
                        trailing: const Icon(Icons.chevron_right),
                        leading: Image.network(
                          'https://user-images.githubusercontent.com/1161351/225875137-bded4d0f-c8e4-45fd-9cde-f45e5fbe2d0f.png',
                          width: 24.sp,
                          height: 24.sp,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        title: const Text("Sign out on this device"),
                        onTap: () {
                          buildSignOutActionSheet(context, progress: progress);
                        },
                        trailing: const Icon(Icons.chevron_right),
                        leading: Image.asset(
                          AppImages.signOut,
                          width: 24.sp,
                          height: 24.sp,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(),
                        ),
                      ),
                      buildDivider(),
                    ],
                  ).toList(),
                );
              }

              return SizedBox();
            },
          ),
          drawer: DrawerWidget(isSettings: true),
        );
      },
    ));
  }

  /// Divider:
  Container buildDivider() {
    return Container(
      height: 30.sp,
      width: double.infinity,
      color: const Color(0xfff2f2f4),
    );
  }

  /// Sign out action sheet:
  Future<dynamic> buildSignOutActionSheet(BuildContext bottomSheetContext,
      {final progress}) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: List.generate(
        1,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: "Yes, Sign out on this device", color: CommonColor.red),
          onPressed: (context) async {
            Navigator.of(bottomSheetContext).pop();
            progress!.show();
            bool status = await SignOutRepo.signOut();

            if (status) {
              await DefaultCacheManager().emptyCache();
              GetStorageServices.logOut();
              _navigationService.navigateTo(AppRoutes.registerScreen,
                  clearStack: true);
            } else {
              progress.dismiss();
              CommonWidget.getSnackBar(context,
                  color: CommonColor.red,
                  duration: 2,
                  message: "Something went wrong!");
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
