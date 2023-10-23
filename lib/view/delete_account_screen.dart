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
import '../repo/delete_account_repo.dart';
import '../repo/get_startup_data_repo.dart';
import '../services/navigation_service/navigation_service.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final NavigationService _navigationService = NavigationService();

  LoaderViewModel settingsViewModel = Get.put(LoaderViewModel());

  String deleteAccount = "";

  final deleteController = TextEditingController();

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
            title: AppStrings.deleteAccount,
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
                  CommonText.textBoldWeight500(text: AppStrings.typeDelete),
                  SizedBox(
                    height: 50.sp,
                  ),
                  CommonWidget.textFormField(
                    controller: deleteController,
                    hintText: "Delete",
                    prefix: const Icon(Icons.delete_outline),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter 'delete' word to delete the account";
                      } else if (deleteAccount.toLowerCase().trim() !=
                          AppStrings.delete.toLowerCase()) {
                        return "'delete' word doesn't match";
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        deleteAccount = value;
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
                        text: AppStrings.deleteAccount,
                        color: CommonColor.red,
                        isLoading: controller.isLoading),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  /// Delete account action sheet:
  Future<dynamic> buildChangeActionSheet(BuildContext bottomSheetContext,
      {final progress}) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: List.generate(
        1,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: "Yes, delete account", color: CommonColor.red),
          onPressed: (context) async {
            Navigator.of(bottomSheetContext).pop();
            progress!.show();
            bool status = await DeleteAccountRepo.deleteAccount();

            if (status) {
              await DefaultCacheManager().emptyCache();
              deleteAccount = "";
              deleteController.clear();
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
