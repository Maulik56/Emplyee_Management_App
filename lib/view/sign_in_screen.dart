import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/color_const.dart';
import 'package:news_app/constant/image_const.dart';
import 'package:news_app/constant/routes_const.dart';
import 'package:news_app/constant/size_const.dart';
import 'package:news_app/get_storage_services/get_storage_service.dart';
import 'package:news_app/repo/apple_auth_repo.dart';
import 'package:news_app/services/firebase_service/apple_auth_service.dart';
import 'package:news_app/services/firebase_service/google_auth_service.dart';
import '../components/common_text.dart';
import '../constant/strings_const.dart';
import '../repo/google_auth_repo.dart';
import '../repo/login_repo.dart';
import '../repo/register_user_repo.dart';
import '../services/navigation_service/navigation_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final NavigationService _navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColor.backgroundColor,
      body: ProgressHUD(child: Builder(
        builder: (context) {
          final progress = ProgressHUD.of(context);
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: CommonSize.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonWidget.commonSizedBox(height: 60),
                    Center(
                      child: CachedNetworkImage(
                        height: 80,
                        imageUrl: AppImages.registerScreenImage,
                        errorWidget: (context, url, error) => const SizedBox(),
                      ),
                    ),
                    CommonWidget.commonSizedBox(height: 30),
                    Center(
                      child: CommonText.textBoldWeight700(
                          text: AppStrings.welcomeTo,
                          fontSize: 26.sp,
                          color: CommonColor.blackColor0C1A30),
                    ),

                    CommonWidget.commonSizedBox(height: 6),
                    Center(
                      child: CommonText.textBoldWeight700(
                          text: AppStrings.appName,
                          fontSize: 23,
                          color: CommonColor.themColor309D9D),
                    ),

                    CommonWidget.commonSizedBox(height: 30),
                    Center(
                      child: CommonText.textBoldWeight400(
                          text: AppStrings.registerDescription,
                          textAlign: TextAlign.center,
                          color: const Color(0xff757575)),
                    ),
                    CommonWidget.commonSizedBox(height: 30),

                    Form(
                      key: _formKey,
                      child: CommonWidget.textFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email can not be empty";
                            }
                          },
                          prefix: const Icon(Icons.email_outlined),
                          keyBoardType: TextInputType.emailAddress,
                          controller: _emailController,
                          hintText: AppStrings.email),
                    ),
                    CommonWidget.commonSizedBox(height: 17),
                    CommonWidget.commonButton(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            progress!.show();
                            var response = await RegisterUserRepo.registerUser(
                                context,
                                email: _emailController.text.trim(),
                                uuid: GetStorageServices.getUuid() ?? "",
                                progress: progress);

                            if (response['success'] == true) {
                              GetStorageServices.setUserEmail(
                                  _emailController.text.trim());
                              _navigationService.navigateTo(
                                AppRoutes.verificationScreen,
                              );

                              progress.dismiss();
                            } else {
                              progress.dismiss();
                              CommonWidget.getSnackBar(context,
                                  color: CommonColor.red,
                                  duration: 2,
                                  message: response['error']);
                            }
                          }
                        },
                        text: AppStrings.register),
                    CommonWidget.commonSizedBox(height: 23),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Expanded(
                              child: Divider(
                            color: CommonColor.greyBorderColor,
                            thickness: 1.3,
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          CommonText.textBoldWeight500(
                              text: 'or',
                              fontSize: 25,
                              color: const Color(0xff999999)),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Divider(
                            color: CommonColor.greyBorderColor,
                            thickness: 1.3,
                          ))
                        ],
                      ),
                    ),
                    CommonWidget.commonSizedBox(height: 23),

                    /// Google Auth Button:
                    OutlinedButton(
                      onPressed: () {
                        GoogleAuthService.signInWithGoogle()
                            .then((value) async {
                          if (value != null) {
                            progress!.show();
                            bool? status =
                                await GoogleAuthRepo.sendGoogleAuthUserData(
                              displayName: value.displayName != null
                                  ? value.displayName!
                                  : "",
                              email: value.email != null ? value.email! : "",
                              uid: value.uid,
                              uuid: GetStorageServices.getUuid() ?? "",
                            );

                            if (status) {
                              GetStorageServices.setUserEmail(
                                  _emailController.text.trim());
                              bool status = await LoginRepo.login();
                              if (status) {
                                _navigationService.navigateTo(
                                    AppRoutes.mainScreen,
                                    clearStack: true);
                              } else {
                                progress.dismiss();
                                _navigationService.navigateTo(
                                  AppRoutes.teamOptionsScreen,
                                );
                              }
                              progress.dismiss();
                            } else {
                              progress.dismiss();
                              CommonWidget.getSnackBar(context,
                                  color: CommonColor.red,
                                  duration: 2,
                                  message: "Something went wrong");
                            }
                          } else {
                            CommonWidget.getSnackBar(context,
                                color: CommonColor.red,
                                duration: 2,
                                message: "Something went wrong");
                          }
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        side: BorderSide(
                            width: 1.3, color: CommonColor.lightGrayColor300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppImages.googleIcon,
                              height: 23,
                              width: 23,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            CommonText.textBoldWeight500(
                                text: "Continue with Google",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)
                          ],
                        ),
                      ),
                    ),

                    /// Apple Auth Button:
                    Platform.isAndroid
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonWidget.commonSizedBox(height: 13),
                              OutlinedButton(
                                onPressed: () {
                                  AppleAuthService.signInWithApple()
                                      .then((value) async {
                                    if (value != null) {
                                      progress!.show();

                                      bool status = await AppleAuthRepo
                                          .sendAppleAuthUserData(
                                        displayName: value.displayName != null
                                            ? value.displayName!
                                            : "",
                                        email: value.email != null
                                            ? value.email!
                                            : "",
                                        uid: value.uid,
                                        uuid: GetStorageServices.getUuid(),
                                      );

                                      if (status) {
                                        GetStorageServices.setUserEmail(
                                            _emailController.text.trim());

                                        bool status = await LoginRepo.login();
                                        if (status) {
                                          _navigationService.navigateTo(
                                              AppRoutes.mainScreen,
                                              clearStack: true);
                                        } else {
                                          progress.dismiss();
                                          _navigationService.navigateTo(
                                            AppRoutes.teamOptionsScreen,
                                          );
                                        }
                                        progress.dismiss();
                                      } else {
                                        progress.dismiss();
                                      }
                                    } else {}
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                      width: 1.3,
                                      color: CommonColor.lightGrayColor300),
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          AppImages.appleIcon,
                                          height: 23,
                                          width: 23,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      CommonText.textBoldWeight500(
                                          text: "Continue with Apple",
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      )),
    );
  }
}
