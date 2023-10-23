import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_text.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/repo/login_repo.dart';
import 'package:news_app/services/navigation_service/navigation_service.dart';

import '../components/connectivity_checker.dart';
import '../constant/color_const.dart';
import '../constant/image_const.dart';
import '../constant/routes_const.dart';

class AllSetScreen extends StatefulWidget {
  const AllSetScreen({Key? key}) : super(key: key);

  @override
  State<AllSetScreen> createState() => _AllSetScreenState();
}

class _AllSetScreenState extends State<AllSetScreen> {
  final NavigationService _navigationService = NavigationService();

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: Builder(
      builder: (context) {
        final progress = ProgressHUD.of(context);
        return Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: 100.sp,
              ),
              Center(
                child: Image.asset(
                  AppImages.allSetLogo,
                  height: 75.sp,
                ),
              ),
              SizedBox(
                height: 25.sp,
              ),
              CommonText.textBoldWeight700(
                text: AllSetStrings.greatWork,
                fontSize: 26.sp,
              ),
              SizedBox(
                height: 60.sp,
              ),
              CommonText.textBoldWeight500(
                text: AllSetStrings.clickTheButton,
                fontSize: 15.sp,
              ),
              SizedBox(
                height: 50.sp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: CommonWidget.commonButton(
                    onTap: () async {
                      progress!.show();

                      bool status = await LoginRepo.login();

                      if (status) {
                        _navigationService.navigateTo(AppRoutes.mainScreen,
                            clearStack: true);
                        progress.dismiss();
                      } else {
                        progress.dismiss();
                        CommonWidget.getSnackBar(context,
                            color: CommonColor.red,
                            duration: 2,
                            message: "Something went wrong!");
                      }
                    },
                    text: AppStrings.continueText),
              )
            ],
          ),
        );
      },
    ));
  }
}
