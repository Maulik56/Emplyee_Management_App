import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_text.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/color_const.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/view/status_screen.dart';
import 'package:news_app/view/vote_to_remove_screen.dart';
import 'package:news_app/viewModel/get_user_detail_view_model.dart';

import '../components/connectivity_checker.dart';
import '../constant/image_const.dart';
import '../constant/routes_const.dart';
import '../models/response_model/main_screen_header_model.dart';
import '../repo/update_status_repo.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import '../viewModel/get_header_data_view_model.dart';
import '../viewModel/get_status_data_view_model.dart';
import 'auto_book_on_screen.dart';
import 'main_screen.dart';
import 'package:flutter_sms/flutter_sms.dart';

class MyProfileScreen extends StatefulWidget {
  final bool isAnotherUser;
  final String? userId;
  final bool? needDrawer;

  const MyProfileScreen(
      {super.key,
      this.isAnotherUser = false,
      this.userId,
      this.needDrawer = true});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final NavigationService _navigationService = NavigationService();

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  GetUserDetailViewModel getUserDetailViewModel =
      Get.put(GetUserDetailViewModel());

  GetStatusDataViewModel getStatusDataViewModel =
      Get.put(GetStatusDataViewModel());

  GetHeaderDataViewModel getHeaderDataViewModel =
      Get.put(GetHeaderDataViewModel());

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  @override
  void initState() {
    try {
      getUserDetailViewModel.getUserDetailDataWithoutModel(
          isAnotherUser: widget.isAnotherUser, userId: widget.userId);
    } catch (e) {
      // TODO
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetUserDetailViewModel>(
      builder: (controller) {
        if (controller.getUserDetailResponseWithoutModel.status ==
            Status.LOADING) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (controller.getUserDetailResponseWithoutModel.status ==
            Status.COMPLETE) {
          final userDetails =
              getUserDetailViewModel.getUserDetailResponseWithoutModel.data;

          final userInfo = userDetails['data'];

          MainScreenHeaderModel? mainScreenHeaderModel;

          if (userInfo['can_edit'] == true) {
            mainScreenHeaderModel =
                getHeaderDataViewModel.getHeaderDataResponse.data;
          }

          return userInfo != null
              ? ProgressHUD(child: Builder(
                  builder: (context) {
                    final progress = ProgressHUD.of(context);
                    return Scaffold(
                      backgroundColor: const Color(0xfff2f2f4),
                      appBar: widget.needDrawer == false
                          ? widget.isAnotherUser
                              ? CommonWidget.commonAppBar(
                                  leading: InkResponse(
                                    onTap: () {
                                      _navigationService.pop();
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                    ),
                                  ),
                                  title: UserProfileStrings.userProfile,
                                  actions: [
                                    userInfo['can_edit'] == true
                                        ? TextButton(
                                            onPressed: () {
                                              try {
                                                getUserDetailViewModel
                                                    .getUserId(
                                                        widget.userId ?? "");
                                                getUserDetailViewModel
                                                    .getIsAnotherUser(
                                                        widget.isAnotherUser);
                                              } catch (e) {
                                                // TODO
                                              }

                                              _navigationService.navigateTo(
                                                  AppRoutes.userProfileScreen,
                                                  arguments: {
                                                    'isFromOnBoarding': false
                                                  });
                                            },
                                            child: Text(
                                              "Edit",
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: CommonColor
                                                      .appBarButtonColor),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                )
                              : CommonWidget.commonAppBar(
                                  title: UserProfileStrings.userProfile,
                                  leading: InkResponse(
                                    onTap: () {
                                      _navigationService.pop();
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                    ),
                                  ),
                                  actions: [
                                    userInfo['can_edit'] == true
                                        ? TextButton(
                                            onPressed: () {
                                              try {
                                                getUserDetailViewModel
                                                    .getUserId(
                                                        widget.userId ?? "");
                                                getUserDetailViewModel
                                                    .getIsAnotherUser(
                                                        widget.isAnotherUser);
                                              } catch (e) {
                                                // TODO
                                              }

                                              _navigationService.navigateTo(
                                                  AppRoutes.userProfileScreen,
                                                  arguments: {
                                                    'isFromOnBoarding':
                                                        widget.needDrawer ==
                                                                false
                                                            ? false
                                                            : true
                                                  });
                                            },
                                            child: Text(
                                              "Edit",
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: CommonColor
                                                      .appBarButtonColor),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                )
                          : CommonWidget.commonAppBar(
                              title: UserProfileStrings.userProfile,
                              actions: [
                                  userInfo['can_edit'] == true
                                      ? TextButton(
                                          onPressed: () {
                                            try {
                                              getUserDetailViewModel.getUserId(
                                                  widget.userId ?? "");
                                              getUserDetailViewModel
                                                  .getIsAnotherUser(
                                                      widget.isAnotherUser);
                                            } catch (e) {
                                              // TODO
                                            }

                                            _navigationService.navigateTo(
                                                AppRoutes.userProfileScreen,
                                                arguments: {
                                                  'isFromOnBoarding': false
                                                });
                                          },
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: CommonColor
                                                    .appBarButtonColor),
                                          ),
                                        )
                                      : const SizedBox(),
                                ]),
                      drawer: widget.needDrawer == true
                          ? DrawerWidget(isMyProfileScreen: true)
                          : null,
                      body: Column(
                        children: [
                          const Divider(
                            height: 0,
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.sp, vertical: 23.sp),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                    fadeInDuration: Duration.zero,
                                    errorWidget: (context, url, error) =>
                                        SizedBox(width: 90.sp, height: 90.sp),
                                    imageUrl: AppImages.appImagePrefix +
                                        userInfo['image_id'],
                                    width: 90.sp,
                                    height: 90.sp),
                                SizedBox(
                                  width: 15.sp,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText.textBoldWeight700(
                                        text:
                                            "${userInfo['first_name']} ${userInfo['last_name']}",
                                        color: Colors.black,
                                        fontSize: 16.sp),
                                    SizedBox(
                                      height: 15.sp,
                                    ),
                                    CommonText.textBoldWeight400(
                                        text: 'Test Team 1',
                                        textAlign: TextAlign.center,
                                        color: CommonColor.greyColor838589,
                                        fontSize: 15.sp),
                                    SizedBox(
                                      height: 7.sp,
                                    ),
                                    CommonText.textBoldWeight400(
                                        text: userInfo['role'],
                                        textAlign: TextAlign.center,
                                        color: CommonColor.greyColor838589,
                                        fontSize: 15.sp),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () async {
                                        await FlutterPhoneDirectCaller
                                            .callNumber(userInfo['mobile'] ??
                                                '0000000000');
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                          width: 1,
                                          color: Color(0xff9d9d9d),
                                        ),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.sp),
                                        child: const Text(
                                          "Call",
                                          style: TextStyle(
                                            color: Color(0xff9d9d9d),
                                          ),
                                        ),
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        _sendSMS("Test Message", [
                                          userInfo['mobile'] ?? '0000000000'
                                        ]);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                          width: 1,
                                          color: Color(0xff9d9d9d),
                                        ),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 27.sp),
                                        child: const Text(
                                          "SMS",
                                          style: TextStyle(
                                            color: Color(0xff9d9d9d),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(), // new
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(
                                    height: 0,
                                  ),
                                  const ListTile(
                                      title: Text(
                                    "CURRENT STATUS 1",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      color: Color.fromARGB(150, 0, 0, 0),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                                  const Divider(
                                    height: 0,
                                  ),
                                  Material(
                                    color: Colors.white,
                                    child: ListTile(
                                      onTap: () {
                                        connectivityChecker
                                            .checkInterNet()
                                            .then((value) {
                                          if (connectivityChecker.isConnected) {
                                            buildShowAdaptiveActionSheet(
                                                context,
                                                actionsValueList:
                                                    mainScreenHeaderModel!
                                                        .data!
                                                        .header!
                                                        .button!
                                                        .dropDown,
                                                progress: progress);
                                            setState(() {});
                                          } else {
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(
                                                  noConnectionSnackBar);
                                          }
                                        });
                                      },
                                      minVerticalPadding: 0,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 13.sp),
                                      minLeadingWidth: 0,
                                      leading: CachedNetworkImage(
                                          fadeInDuration: Duration.zero,
                                          errorWidget: (context, url, error) =>
                                              SizedBox(
                                                  width: 24.sp, height: 24.sp),
                                          imageUrl: AppImages.appImagePrefix +
                                              userInfo['availability']
                                                  ['image_id'],
                                          width: 24.sp,
                                          height: 24.sp),
                                      title: Text(
                                          userInfo['availability']['text']),
                                      trailing: userInfo['can_edit'] == true
                                          ? const Icon(Icons.chevron_right)
                                          : const SizedBox(),
                                    ),
                                  ),
                                  const Divider(
                                    height: 0,
                                  ),
                                  buildColumn(userInfo),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      bottomNavigationBar: userInfo['allow_remove_vote'] == true
                          ? voteToRemoveUserButton()
                          : const SizedBox(),
                    );
                  },
                ))
              : const SizedBox();
        }
        return const SizedBox();
      },
    );
  }

  SafeArea voteToRemoveUserButton() {
    return SafeArea(
      child: Material(
        color: const Color(0xffe8e8ec),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(
              height: 0,
            ),
            ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VoteToRemoveScreen(targetUserId: widget.userId!),
                      ));
                },
                title: Text(
                  "Vote to remove user",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: CommonColor.red,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            const Divider(
              height: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildColumn(userInfo) {
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
              title: Text(
            "QUALIFICATIONS",
            style: TextStyle(
              fontSize: 13.0,
              color: Color.fromARGB(150, 0, 0, 0),
              fontWeight: FontWeight.w600,
            ),
          )),
          const Divider(
            height: 0,
          ),
          Column(
            children: List.generate(
                userInfo['qualifications'].length ?? 0,
                (index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                          color: Colors.white,
                          child: ListTile(
                            minVerticalPadding: 0,
                            minLeadingWidth: 0,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 13.sp),
                            leading: CachedNetworkImage(
                                fadeInDuration: Duration.zero,
                                errorWidget: (context, url, error) =>
                                    SizedBox(width: 24.sp, height: 24.sp),
                                imageUrl: AppImages.appImagePrefix +
                                    userInfo['qualifications'][index]
                                        ['image_id'],
                                width: 24.sp,
                                height: 24.sp),
                            title:
                                Text(userInfo['qualifications'][index]['text']),
                          ),
                        ),
                        const Divider(
                          height: 0,
                        ),
                      ],
                    )),
          ),
        ],
      );
    } catch (e) {
      return const SizedBox();
    }
  }

  /// Change Status Action Sheet:
  Future<dynamic> buildShowAdaptiveActionSheet(
    BuildContext bottomSheetContext, {
    List<DropDowns>? actionsValueList,
    final progress,
  }) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: List.generate(
        actionsValueList!.length,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: utf8convert(actionsValueList[index].text.toString()),
              color: CommonColor.blue),
          onPressed: (context) async {
            await connectivityChecker.checkInterNet();
            Navigator.pop(context);

            if (connectivityChecker.isConnected) {
              progress!.show();
              var response;

              try {
                response = await UpdateStatusRepo.updateStatus(
                    context: context,
                    id: actionsValueList[index].id!,
                    contId: widget.userId!);
              } catch (e) {}

              /// Open Auto Book Screen:
              try {
                if (response['data']['select_auto_book'] == true) {
                  showModalBottomSheet(
                      context: bottomSheetContext,
                      useSafeArea: true,
                      builder: (context) => AutoBookOnScreen(),
                      isScrollControlled: true);
                }
              } catch (e) {
                // TODO
              }

              /// Action(Call/SMS):
              try {
                if (response['data']['action'] != null) {
                  if (response['data']['action']['type'] == 'call') {
                    await FlutterPhoneDirectCaller.callNumber(
                        response['data']['action']['num'].toString());
                  } else if (response['data']['action']['type'] == 'sms') {
                    _sendSMS(response['data']['action']['message'],
                        [response['data']['action']['num']]);
                  }
                }
              } catch (e) {
                // TODO
              }

              await getHeaderDataViewModel.getHeaderData(isLoading: false);

              await getUserDetailViewModel.getUserDetailDataWithoutModel(
                  isAnotherUser: widget.isAnotherUser,
                  userId: widget.userId,
                  isLoading: false);

              switch (getStatusDataViewModel.selectedSegment) {
                case StatusList.available:
                  await getStatusDataViewModel.getStatusData(
                      needFilter: true,
                      queryParameter: AppStrings.available.toLowerCase(),
                      isLoading: false);
                  break;
                case StatusList.unavailable:
                  await getStatusDataViewModel.getStatusData(
                      needFilter: true,
                      queryParameter: AppStrings.unavailable.toLowerCase(),
                      isLoading: false);
                  break;
                case StatusList.all:
                  await getStatusDataViewModel.getStatusData(isLoading: false);
                  break;
              }

              progress.dismiss();
            } else {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(noConnectionSnackBar);
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
