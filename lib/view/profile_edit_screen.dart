import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/common_text.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/color_const.dart';
import 'package:news_app/constant/image_const.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/viewModel/get_user_detail_view_model.dart';
import '../constant/routes_const.dart';
import '../get_storage_services/get_storage_service.dart';
import '../repo/edit_user_details_repo.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import 'package:get/get.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final NavigationService _navigationService = NavigationService();

  GetUserDetailViewModel getUserDetailViewModel =
      Get.put(GetUserDetailViewModel());

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getUserDetailViewModel.getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return ProgressHUD(child: Builder(
      builder: (context) {
        final progress = ProgressHUD.of(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonWidget.commonAppBar(
              title: AppStrings.yourProfile,
              leading: InkResponse(
                onTap: () {
                  _navigationService.navigateTo(AppRoutes.registerScreen,
                      clearStack: true);
                },
                child: const Icon(Icons.arrow_back_ios_new),
              ),
              actions: [
                args['isFromOnBoarding']
                    ? const SizedBox()
                    : TextButton(
                        onPressed: () {},
                        child: CommonText.textBoldWeight400(
                            text: EditProfileStrings.save,
                            fontSize: 19.sp,
                            color: CupertinoColors.activeBlue)),
              ]),
          body: GetBuilder<GetUserDetailViewModel>(
            builder: (controller) {
              if (controller.getUserDetailResponse.status == Status.LOADING) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.getUserDetailResponse.status == Status.COMPLETE) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.sp),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 35.sp,
                          ),
                          Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Image.network(
                                  AppImages.profilePicture,
                                  height: 90.sp,
                                ),
                                Positioned(
                                  bottom: -20.sp,
                                  right: -18.sp,
                                  child: Container(
                                    height: 38,
                                    width: 38,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff4189eb),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  CommonColor.lightGrayColor300,
                                              blurRadius: 1,
                                              spreadRadius: 1.5)
                                        ]),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35.sp,
                          ),
                          CommonWidget.textFormField(
                            prefix: const Icon(Icons.badge_outlined),
                            controller: controller.firstName!,
                            textCapitalization: TextCapitalization.words,
                            hintText: EditProfileStrings.firstName,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "First Name can not be empty";
                              }
                            },
                          ),
                          SizedBox(
                            height: 15.sp,
                          ),
                          CommonWidget.textFormField(
                            prefix: const Icon(Icons.badge_outlined),
                            controller: controller.lastName!,
                            textCapitalization: TextCapitalization.words,
                            hintText: EditProfileStrings.lastName,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Last Name can not be empty";
                              }
                            },
                          ),
                          SizedBox(
                            height: 15.sp,
                          ),
                          CommonWidget.textFormField(
                            prefix: const Icon(Icons.phone_iphone_outlined),
                            controller: controller.mobileNumber!,
                            keyBoardType:
                                defaultTargetPlatform == TargetPlatform.iOS
                                    ? const TextInputType.numberWithOptions(
                                        decimal: true, signed: true)
                                    : TextInputType.number,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            hintText: EditProfileStrings.mobileNumber,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Mobile Number can not be empty";
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(child: SizedBox());
              }
            },
          ),
          bottomNavigationBar: args['isFromOnBoarding']
              ? Container(
                  height: Platform.isAndroid ? 80.sp : 100.sp,
                  padding: EdgeInsets.all(15.sp),
                  color: const Color(0xfff2f2f2),
                  child: Column(
                    children: [
                      CommonWidget.commonButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            progress!.show();
                            var userInfo =
                                getUserDetailViewModel.response!.data;

                            var response =
                                await EditUserProfileRepo.editUserProfile(
                              id: userInfo!.id!,
                              firstName: userInfo.firstName != null
                                  ? getUserDetailViewModel.firstName!.text
                                  : userInfo.firstName!,
                              lastName: userInfo.lastName != null
                                  ? getUserDetailViewModel.lastName!.text
                                  : userInfo.lastName!,
                              mobile: userInfo.mobile != null
                                  ? getUserDetailViewModel.mobileNumber!.text
                                  : userInfo.mobile!,
                              email:
                                  userInfo.email != null ? userInfo.email! : "",
                            );
                            if (response['success'] == true) {
                              try {
                                if (response['next_page'] == 'team_options') {
                                  _navigationService.navigateTo(
                                    AppRoutes.teamOptionsScreen,
                                  );
                                } else {
                                  _navigationService.navigateTo(
                                      AppRoutes.mainScreen,
                                      clearStack: true);
                                }
                              } catch (e) {
                                _navigationService.navigateTo(
                                    AppRoutes.mainScreen,
                                    clearStack: true);
                              }
                              progress.dismiss();
                            } else {
                              progress.dismiss();
                              CommonWidget.getSnackBar(context,
                                  color: CommonColor.red,
                                  duration: 2,
                                  message: "Please try again!");
                            }
                          }
                        },
                        text: AppStrings.continueText,
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        );
      },
    ));
  }
}
