import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/constant/routes_const.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/get_storage_services/get_storage_service.dart';
import 'package:news_app/repo/login_repo.dart';
import '../components/common_text.dart';
import '../components/common_widget.dart';
import '../constant/color_const.dart';
import '../constant/image_const.dart';
import '../constant/size_const.dart';
import '../repo/push_token_repo.dart';
import '../repo/resend_code_repo.dart';
import '../repo/verify_code_repo.dart';
import '../services/navigation_service/navigation_service.dart';
import 'package:pinput/pinput.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController? _controller;

  final NavigationService _navigationService = NavigationService();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(214, 218, 221, 1)),
      borderRadius: BorderRadius.circular(10),
    ),
  );

  @override
  void initState() {
    try {
      _controller = TextEditingController(text: GetStorageServices.getCode());
    } catch (e) {
      _controller = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProgressHUD(child: Builder(
      builder: (context) {
        final progress = ProgressHUD.of(context);
        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: CommonSize.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidget.commonSizedBox(height: 20.sp),
                  InkResponse(
                      onTap: () {
                        _navigationService.pop();
                      },
                      child: const Icon(Icons.arrow_back_ios)),
                  CommonWidget.commonSizedBox(height: 20.sp),
                  Center(
                    child: CachedNetworkImage(
                      height: 80,
                      imageUrl: AppImages.verificationScreenIconUrl,
                    ),
                  ),
                  CommonWidget.commonSizedBox(height: 28.sp),
                  Center(
                    child: CommonText.textBoldWeight700(
                        text: AppStrings.verification,
                        fontSize: 26.sp,
                        color: CommonColor.blackColor0C1A30),
                  ),
                  CommonWidget.commonSizedBox(height: 23.sp),
                  Align(
                    alignment: Alignment.center,
                    child: CommonText.textBoldWeight400(
                        text: AppStrings.enterTheCode,
                        fontSize: 16.sp,
                        color: CommonColor.blackColor0C1A30),
                  ),
                  CommonWidget.commonSizedBox(height: 17.sp),
                  Center(
                    child: CommonText.textBoldWeight400(
                      text: GetStorageServices.getUserEmail(),
                      fontSize: 13.sp,
                      color: const Color(0xff0099ff),
                    ),
                  ),
                  CommonWidget.commonSizedBox(height: 60.sp),
                  Center(
                    child: Pinput(
                      defaultPinTheme: defaultPinTheme,
                      controller: _controller,
                      length: 4,
                      keyboardType: TextInputType.number,
                      onCompleted: (pin) async {
                        progress!.show();

                        try {
                          bool? status = await VerifyCodeRepo.verifyCode(
                              code: _controller!.text,
                              uuid: GetStorageServices.getUuid());

                          if (status) {
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
                            _controller!.clear();
                          } else {
                            progress.dismiss();
                            _controller!.clear();
                            setState(() {});
                            CommonWidget.getSnackBar(context,
                                color: CommonColor.red,
                                duration: 2,
                                message: "Please enter valid code");
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(noConnectionSnackBar);
                          progress.dismiss();
                        }
                      },
                    ),
                  ),
                  CommonWidget.commonSizedBox(height: 50.sp),
                  Align(
                    alignment: Alignment.center,
                    child: CommonText.textBoldWeight500(
                        text: AppStrings.didNotReceiveCode,
                        fontSize: 15.sp,
                        color: CommonColor.greyColor838589),
                  ),
                  CommonWidget.commonSizedBox(height: 5.sp),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () async {
                        progress!.show();
                        try {
                          bool status = await ResendCodeRepo.resendCode();

                          if (status) {
                            progress.dismiss();
                            CommonWidget.getSnackBar(context,
                                duration: 2,
                                message: "Code sent successfully!");
                          } else {
                            progress.dismiss();
                            CommonWidget.getSnackBar(context,
                                color: CommonColor.red,
                                duration: 2,
                                message: "Please enter valid code");
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(noConnectionSnackBar);
                          progress.dismiss();
                        }
                      },
                      child: CommonText.textBoldWeight500(
                          text: AppStrings.resend,
                          fontSize: 15.sp,
                          textDecoration: TextDecoration.underline,
                          color: CommonColor.greyColor838589),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    )));
  }
}
