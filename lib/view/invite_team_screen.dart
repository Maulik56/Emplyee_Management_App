import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/common_text.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/models/response_model/get_invite_code_response_model.dart';
import 'package:news_app/services/api_service/api_response.dart';
import 'package:news_app/services/navigation_service/navigation_service.dart';
import 'package:news_app/viewModel/get_invite_code_view_model.dart';
import 'package:share_plus/share_plus.dart';
import '../components/connectivity_checker.dart';
import '../components/intercepters.dart';
import '../constant/color_const.dart';
import '../constant/image_const.dart';

class InviteTeamScreen extends StatefulWidget {
  const InviteTeamScreen({Key? key}) : super(key: key);

  @override
  State<InviteTeamScreen> createState() => _InviteTeamScreenState();
}

class _InviteTeamScreenState extends State<InviteTeamScreen> {
  final NavigationService _navigationService = NavigationService();

  GetInviteCodeViewModel getInviteCodeViewModel =
      Get.put(GetInviteCodeViewModel());

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  @override
  void initState() {
    getInviteCodeViewModel.getInviteCodeViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidget.commonAppBar(
        title: InviteTeamStrings.inviteTeamMembers,
        leading: InkResponse(
          onTap: () {
            Interceptors.mainScreenInterceptor();
            _navigationService.pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 65.sp,
          ),
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.network(
                  AppImages.profilePicture,
                  height: 55.sp,
                ),
                Positioned(
                  bottom: -22.sp,
                  right: -20.sp,
                  child: Container(
                    height: 40.sp,
                    width: 40.sp,
                    decoration: BoxDecoration(
                      color: const Color(0xff4189eb),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: CommonColor.lightGrayColor300,
                            blurRadius: 1,
                            spreadRadius: 1.5)
                      ],
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 40.sp,
          ),
          CommonText.textBoldWeight400(
            text: InviteTeamStrings.inviteCodeInfo,
            textAlign: TextAlign.center,
            fontSize: 17.sp,
          ),
          SizedBox(
            height: 37.sp,
          ),
          GetBuilder<GetInviteCodeViewModel>(
            builder: (controller) {
              if (controller.getInviteCodeResponse.status == Status.COMPLETE) {
                GetInviteCodeResponseModel responseModel =
                    controller.getInviteCodeResponse.data;
                return Column(
                  children: [
                    CommonText.textBoldWeight500(
                        text: responseModel.data?.inviteCode ?? '',
                        color: CommonColor.blue,
                        fontSize: 28.sp),
                    SizedBox(
                      height: 37.sp,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35.sp),
                      child: CommonWidget.commonButton(
                        onTap: () {
                          Share.share(responseModel.data?.inviteText ?? '');
                        },
                        text: "Share Invite Code",
                      ),
                    )
                  ],
                );
              } else {
                if (controller.getInviteCodeResponse.status == Status.LOADING) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return NoInternetWidget(
                    onPressed: () {
                      connectivityChecker.checkInterNet().then((value) =>
                          {getInviteCodeViewModel.getInviteCodeViewModel()});
                    },
                  );
                }
              }
            },
          )
        ],
      ),
    );
  }
}
