import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/routes_const.dart';
import 'package:news_app/constant/strings_const.dart';
import '../components/common_text.dart';
import '../constant/color_const.dart';
import '../constant/image_const.dart';
import '../services/navigation_service/navigation_service.dart';

class TeamOptionsScreen extends StatefulWidget {
  const TeamOptionsScreen({Key? key}) : super(key: key);

  @override
  State<TeamOptionsScreen> createState() => _TeamOptionsScreenState();
}

class _TeamOptionsScreenState extends State<TeamOptionsScreen> {
  final NavigationService _navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.sp, top: 25.sp),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkResponse(
                  onTap: () {
                    _navigationService.pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.sp),
              child: Column(
                children: [
                  SizedBox(
                    height: 25.sp,
                  ),
                  Container(
                    height: 50.sp,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(AppImages.teamOptions),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18.sp,
                  ),
                  CommonText.textBoldWeight700(
                    text: TeamOptionsStrings.teamOptions,
                    fontSize: 26.sp,
                  ),
                  SizedBox(
                    height: 15.sp,
                  ),
                  CommonText.textBoldWeight400(
                      text: TeamOptionsStrings.useInviteCode,
                      fontSize: 15.sp,
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 45.sp,
                  ),
                  CommonWidget.commonButton(
                    onTap: () {
                      _navigationService.navigateTo(AppRoutes.joinTeamScreen);
                    },
                    text: TeamOptionsStrings.joinExistingTeam,
                  ),
                  SizedBox(
                    height: 25.sp,
                  ),
                  Row(
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
                          text: TeamOptionsStrings.or, fontSize: 25),
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
                  SizedBox(
                    height: 25.sp,
                  ),
                  CommonWidget.commonButton(
                      onTap: () {
                        _navigationService
                            .navigateTo(AppRoutes.createTeamScreen);
                      },
                      text: TeamOptionsStrings.createNewTeam,
                      color: Colors.white,
                      needBorder: true,
                      borderColor: Colors.grey.shade400,
                      textColor: Colors.black),
                  SizedBox(
                    height: 35.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
