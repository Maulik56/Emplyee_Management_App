import 'package:flutter/material.dart';
import 'package:news_app/components/common_text.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/color_const.dart';
import 'package:news_app/constant/image_const.dart';
import 'package:news_app/constant/routes_const.dart';
import '../repo/get_startup_data_repo.dart';
import '../services/navigation_service/navigation_service.dart';

class NoInternetScreen extends StatelessWidget {
  NoInternetScreen({Key? key}) : super(key: key);

  final NavigationService _navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.noInternet,
              height: 100,
            ),
            const SizedBox(
              height: 35,
            ),
            CommonText.textBoldWeight500(
                text: "No Internet Connection", fontSize: 20),
            const SizedBox(
              height: 18,
            ),
            CommonText.textBoldWeight400(
                text:
                    "Make sure wifi or cellular data is turned on and then try again",
                textAlign: TextAlign.center,
                fontSize: 15,
                color: CommonColor.greyColor838589),
            const SizedBox(
              height: 25,
            ),
            CommonWidget.commonButton(
              onTap: () async {
                try {
                  bool status = await GetStartupDataRepo.getStartupData();
                  if (status) {
                    _navigationService.navigateTo(AppRoutes.mainScreen,
                        clearStack: true);
                  } else {
                    _navigationService.navigateTo(AppRoutes.registerScreen,
                        clearStack: true);
                  }
                } on Exception catch (e) {
                  // TODO
                }
              },
              text: "Retry",
              color: CommonColor.red,
            ),
          ],
        ),
      ),
    );
  }
}
