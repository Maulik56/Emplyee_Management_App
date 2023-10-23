import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_text.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/repo/join_team_repo.dart';
import 'package:news_app/viewModel/loader_view_model.dart';
import 'package:pinput/pinput.dart';
import '../components/common_widget.dart';
import '../constant/color_const.dart';
import '../constant/image_const.dart';
import '../constant/routes_const.dart';
import '../services/navigation_service/navigation_service.dart';

class JoinTeamScreen extends StatefulWidget {
  const JoinTeamScreen({Key? key}) : super(key: key);

  @override
  State<JoinTeamScreen> createState() => _JoinTeamScreenState();
}

class _JoinTeamScreenState extends State<JoinTeamScreen> {
  final NavigationService _navigationService = NavigationService();

  LoaderViewModel settingsViewModel = Get.put(LoaderViewModel());

  final _controller = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ProgressHUD(child: Builder(
        builder: (context) {
          final progress = ProgressHUD.of(context);
          return SafeArea(
            child: Column(
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
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30.sp,
                      ),
                      Container(
                        height: 50.sp,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(AppImages.joinTeam),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18.sp,
                      ),
                      CommonText.textBoldWeight700(
                        text: JoinTeamStrings.joinTeam,
                        fontSize: 26.sp,
                      ),
                      SizedBox(
                        height: 35.sp,
                      ),
                      CommonText.textBoldWeight400(
                          text: JoinTeamStrings.enterInviteCode,
                          fontSize: 15.sp,
                          textAlign: TextAlign.center),
                      CommonWidget.commonSizedBox(height: 60.sp),
                      Center(
                        child: Pinput(
                          autofocus: true,
                          keyboardType: TextInputType.text,
                          defaultPinTheme: defaultPinTheme,
                          controller: _controller,
                          textCapitalization: TextCapitalization.characters,
                          length: 6,
                          onCompleted: (pin) async {
                            progress!.show();

                            bool? status = await JoinTeamRepo.joinTeam(
                              inviteCode: pin,
                            );

                            if (status) {
                              _navigationService.navigateTo(
                                  AppRoutes.userProfileScreen,
                                  arguments: {'isFromOnBoarding': true});
                              progress.dismiss();
                              _controller.clear();
                            } else {
                              progress.dismiss();
                              CommonWidget.getSnackBar(context,
                                  color: CommonColor.red,
                                  duration: 2,
                                  message: "Please enter valid code");
                              _controller.clear();
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      CommonWidget.commonSizedBox(height: 50.sp),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
