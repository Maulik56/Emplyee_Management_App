import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_text.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/viewModel/loader_view_model.dart';

import '../constant/color_const.dart';
import '../constant/routes_const.dart';
import '../get_storage_services/get_storage_service.dart';
import '../repo/get_startup_data_repo.dart';
import '../repo/leave_team_repo.dart';
import '../services/navigation_service/navigation_service.dart';

class LeaveTeamScreen extends StatefulWidget {
  const LeaveTeamScreen({Key? key}) : super(key: key);

  @override
  State<LeaveTeamScreen> createState() => _LeaveTeamScreenState();
}

class _LeaveTeamScreenState extends State<LeaveTeamScreen> {
  final NavigationService _navigationService = NavigationService();

  LoaderViewModel settingsViewModel = Get.put(LoaderViewModel());

  String leaveTeam = "";

  final leaveController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: Builder(
      builder: (context) {
        final progress = ProgressHUD.of(context);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: CommonWidget.commonAppBar(
            title: AppStrings.leaveTeam,
            leading: InkResponse(
              onTap: () {
                _navigationService.pop();
              },
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 30.sp,
                  ),
                  CommonText.textBoldWeight500(text: AppStrings.typeLeave),
                  SizedBox(
                    height: 50.sp,
                  ),
                  CommonWidget.textFormField(
                    hintText: "Leave",
                    prefix: const Icon(Icons.exit_to_app),
                    controller: leaveController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter 'leave' word to leave the team";
                      } else if (leaveTeam.toLowerCase().trim() !=
                          AppStrings.leave.toLowerCase()) {
                        return "'leave' word doesn't match";
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        leaveTeam = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 35.sp,
                  ),
                  GetBuilder<LoaderViewModel>(
                    builder: (controller) => CommonWidget.commonButton(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          buildChangeActionSheet(context, progress: progress);
                        }
                      },
                      text: AppStrings.leaveTeam,
                      isLoading: controller.isLoading,
                      color: CommonColor.red,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  /// Leave team action sheet:
  Future<dynamic> buildChangeActionSheet(BuildContext bottomSheetContext,
      {final progress}) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: List.generate(
        1,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: "Yes, leave team", color: CommonColor.red),
          onPressed: (context) async {
            Navigator.of(bottomSheetContext).pop();
            progress!.show();
            bool status = await LeaveTeamRepo.leaveTeam();

            if (status) {
              await DefaultCacheManager().emptyCache();
              leaveTeam = "";
              leaveController.clear();
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
