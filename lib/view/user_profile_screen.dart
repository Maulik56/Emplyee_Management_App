import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_text.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/color_const.dart';
import 'package:news_app/constant/routes_const.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/repo/send_user_detail_repo.dart';
import 'package:news_app/view/main_screen.dart';

import '../components/intercepters.dart';
import '../constant/image_const.dart';
import '../models/response_model/qualification_response_model.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import '../viewModel/get_user_avatar_role_view_model.dart';
import '../viewModel/get_user_detail_view_model.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final NavigationService _navigationService = NavigationService();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController crewNumber = TextEditingController();
  TextEditingController displayName = TextEditingController();

  final formKey = GlobalKey<FormState>();

  GetUserDetailViewModel userDetailViewModel =
      Get.put(GetUserDetailViewModel());

  GetUserAvatarRoleViewModel getUserAvatarRoleViewModel =
      Get.put(GetUserAvatarRoleViewModel());

  GetUserDetailViewModel getUserDetailViewModel =
      Get.put(GetUserDetailViewModel());

  String? userPhoneNo;

  var userInfo;

  Map controllers = {};
  Map tempControllers = {};

  void addNewTextEditingController(
      String title, TextEditingController newController) {
    controllers.addAll({
      title: newController,
    });
    tempControllers = {...controllers};
  }

  populateUserDetail() async {
    try {
      await userDetailViewModel.getUserDetailDataWithoutModel(
          userId: userDetailViewModel.userId,
          isAnotherUser: userDetailViewModel.isAnotherUser);
    } catch (e) {
      // TODO
    }

    final userDetails =
        await userDetailViewModel.getUserDetailResponseWithoutModel.data;
    userInfo = userDetails['data'];

    try {
      userInfo['extra_fields'].forEach((element) {
        element['fields'].forEach((element1) {
          addNewTextEditingController(
            element1['name'].toString(),
            TextEditingController(
              text: element1['value'] ??
                  tempControllers[element1['name'].toString()],
            ),
          );
        });
      });
    } catch (e) {
      // TODO
    }

    try {
      firstName = TextEditingController(text: userInfo['first_name']);
      lastName = TextEditingController(text: userInfo['last_name']);
      getUserAvatarRoleViewModel.position =
          TextEditingController(text: userInfo['role']);
      crewNumber = TextEditingController(text: userInfo['crew_number']);
      displayName = TextEditingController(text: userInfo['display_name']);
      userPhoneNo = userInfo['mobile'];
      userDetailViewModel.updateUserAvatar(userInfo['image_id']);

      List qualifications = [];
      List qualificationImageId = [];

      userInfo['qualifications'].forEach((element) {
        qualifications.add(element['text']);
        qualificationImageId.add(element['image_id']);
      });

      userDetailViewModel.updateQualification(qualifications);
      userDetailViewModel.updateQualificationImageList(qualificationImageId);
      getUserAvatarRoleViewModel.updateQualification(qualifications);

      getUserAvatarRoleViewModel
          .updateQualificationImageId(qualificationImageId);
    } catch (e) {
      // TODO
    }
    setState(() {});
  }

  @override
  void initState() {
    getUserAvatarRoleViewModel.getRoleList();
    populateUserDetail();
    getUserAvatarRoleViewModel.getQualificationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    if (args['isFromOnBoarding'] == false) {
      mobileNo = TextEditingController(text: userPhoneNo ?? "");
    }
    return ProgressHUD(child: Builder(
      builder: (context) {
        final progress = ProgressHUD.of(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: args['isFromOnBoarding'] == true
              ? CommonWidget.commonAppBar(
                  title: "User Profile",
                  leadingWidth: 60.sp,
                  leading: InkResponse(
                    onTap: () {
                      Interceptors.mainScreenInterceptor();

                      _navigationService.pop();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                )
              : CommonWidget.commonAppBar(
                  title: "User Profile",
                  leadingWidth: 60.sp,
                  leading: TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        progress!.show();

                        final userQualifications = getUserAvatarRoleViewModel
                            .qualificationList
                            .toString()
                            .replaceAll("[", '')
                            .replaceAll("]", '')
                            .replaceAll(",", "|");

                        var response;

                        if (userInfo['extra_fields'] != null) {
                          Map<String, dynamic> extraFields = {};

                          extraFields.addAll({
                            "id": userInfo['id'],
                            "first_name": firstName.text,
                            "last_name": lastName.text,
                            "mobile": mobileNo.text,
                            "avatar": userDetailViewModel.userAvatar != null
                                ? userDetailViewModel.userAvatar!
                                : "",
                            "position":
                                getUserAvatarRoleViewModel.position.text,
                            "crew_number": crewNumber.text,
                            "display_name": displayName.text,
                            "qualification": userQualifications,
                          });

                          tempControllers.forEach((key, value) {
                            extraFields.addAll({key: value.text});
                          });

                          response = await SendUserDetailRepo.sendUserDetail(
                              userId: userInfo['id'],
                              firstName: firstName.text,
                              lastName: lastName.text,
                              mobile: mobileNo.text,
                              avatar: userDetailViewModel.userAvatar != null
                                  ? userDetailViewModel.userAvatar!
                                  : "",
                              position:
                                  getUserAvatarRoleViewModel.position.text,
                              crewNumber: crewNumber.text,
                              displayName: displayName.text,
                              qualification: userQualifications,
                              isContainsExtraField: true,
                              reqBodyWithExtraField: extraFields);
                        } else {
                          response = await SendUserDetailRepo.sendUserDetail(
                              userId: userInfo['id'],
                              firstName: firstName.text,
                              lastName: lastName.text,
                              mobile: mobileNo.text,
                              avatar: userDetailViewModel.userAvatar != null
                                  ? userDetailViewModel.userAvatar!
                                  : "",
                              position:
                                  getUserAvatarRoleViewModel.position.text,
                              crewNumber: crewNumber.text,
                              displayName: displayName.text,
                              qualification: userQualifications);
                        }

                        if (response['success'] == true) {
                          progress.dismiss();
                          userDetailViewModel.getUserDetailDataWithoutModel(
                              isLoading: false,
                              userId: userDetailViewModel.userId,
                              isAnotherUser: userDetailViewModel.isAnotherUser);
                          CommonWidget.getSnackBar(context,
                              color: CommonColor.blue,
                              duration: 1,
                              message: "Profile updated successfully!");
                          Interceptors.mainScreenInterceptor();
                          _navigationService.pop();
                        } else {
                          progress.dismiss();
                          CommonWidget.getSnackBar(context,
                              color: CommonColor.red,
                              duration: 1,
                              message: response['error']);
                        }
                      }
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: 15.sp, color: Colors.blue),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Interceptors.mainScreenInterceptor();
                        try {
                          userDetailViewModel.updateQualification([]);
                          userDetailViewModel.updateQualificationImageList([]);
                          getUserAvatarRoleViewModel.updateQualification([]);
                          getUserAvatarRoleViewModel
                              .updateQualificationImageId([]);
                        } catch (e) {
                          // TODO
                        }
                        _navigationService.pop();
                      },
                      child: Text(
                        "Cancel",
                        style:
                            TextStyle(fontSize: 15.sp, color: CommonColor.red),
                      ),
                    ),
                  ],
                ),
          body: GetBuilder<GetUserDetailViewModel>(
            builder: (controller) {
              if (controller.getUserDetailResponseWithoutModel.status ==
                  Status.LOADING) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (controller.getUserDetailResponseWithoutModel.status ==
                  Status.COMPLETE) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 35.sp,
                                ),
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      _navigationService.navigateTo(
                                        AppRoutes.selectUserImageScreen,
                                        arguments: {
                                          'previousAvatar':
                                              userDetailViewModel.userAvatar ??
                                                  ""
                                        },
                                      );
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        CachedNetworkImage(
                                            fadeInDuration: Duration.zero,
                                            imageUrl:
                                                controller.userAvatar != null
                                                    ? AppImages.appImagePrefix +
                                                        controller.userAvatar!
                                                    : AppImages.profilePicture,
                                            width: 75.sp,
                                            height: 75.sp),
                                        Positioned(
                                          bottom: -9.sp,
                                          right: -10.sp,
                                          child: Image.asset(
                                            AppImages.editIcon,
                                            height: 35.sp,
                                            width: 35.sp,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 35.sp,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CommonWidget.textFormField(
                                        prefix:
                                            const Icon(Icons.badge_outlined),
                                        controller: firstName,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        hintText: EditProfileStrings.firstName,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "First Name can not be empty";
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15.sp,
                                    ),
                                    Expanded(
                                      child: CommonWidget.textFormField(
                                        controller: lastName,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        hintText: EditProfileStrings.lastName,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Last Name can not be empty";
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.sp,
                                ),
                                CommonWidget.textFormField(
                                  prefix: const Icon(Icons.badge_outlined),
                                  controller: displayName,
                                  textCapitalization: TextCapitalization.words,
                                  hintText: EditProfileStrings.displayName,
                                ),
                                SizedBox(
                                  height: 15.sp,
                                ),
                                CommonWidget.textFormField(
                                  prefix:
                                      const Icon(Icons.phone_iphone_outlined),
                                  controller: mobileNo,
                                  keyBoardType: defaultTargetPlatform ==
                                          TargetPlatform.iOS
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
                                SizedBox(
                                  height: 35.sp,
                                ),
                                CommonWidget.textFormField(
                                  prefix: const Icon(Icons.badge_outlined),
                                  controller: crewNumber,
                                  textCapitalization: TextCapitalization.words,
                                  keyBoardType: defaultTargetPlatform ==
                                          TargetPlatform.iOS
                                      ? const TextInputType.numberWithOptions(
                                          decimal: true, signed: true)
                                      : TextInputType.number,
                                  inputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  hintText: "Crew Number",
                                ),
                                SizedBox(
                                  height: 15.sp,
                                ),
                                GetBuilder<GetUserAvatarRoleViewModel>(
                                  builder: (controller) {
                                    return CommonWidget.textFormField(
                                      autoValidateMode:
                                          getUserAvatarRoleViewModel
                                                  .position.text.isNotEmpty
                                              ? AutovalidateMode.always
                                              : AutovalidateMode
                                                  .onUserInteraction,
                                      onTap: () {
                                        buildShowAdaptiveActionSheet(context,
                                            actionsValueList:
                                                getUserAvatarRoleViewModel
                                                    .response!.data!.roles!);
                                      },
                                      prefix: const Icon(Icons.badge_outlined),
                                      suffix: const Icon(
                                          Icons.chevron_right_outlined),
                                      controller: controller.position,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      hintText: "Position",
                                      readOnly: true,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Position can not be empty";
                                        }
                                      },
                                    );
                                  },
                                ),
                                userInfo['extra_fields'] != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List.generate(
                                          userInfo['extra_fields'].length,
                                          (index) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 35.sp,
                                              ),
                                              CommonText.textBoldWeight600(
                                                  text: userInfo['extra_fields']
                                                      [index]['title']),
                                              SizedBox(
                                                height: 15.sp,
                                              ),
                                              ListView.separated(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index1) {
                                                  return CommonWidget
                                                      .textFormField(
                                                          prefix: const Icon(Icons
                                                              .phone_android),
                                                          controller: tempControllers[
                                                              userInfo['extra_fields'][index]
                                                                              ['fields']
                                                                          [index1]
                                                                      ['name']
                                                                  .toString()],
                                                          hintText: userInfo[
                                                                      'extra_fields']
                                                                  [
                                                                  index]['fields']
                                                              [index1]['title'],
                                                          onChanged: (val) {
                                                            print(
                                                                'VALUE==$val');
                                                          });
                                                },
                                                separatorBuilder:
                                                    (context, index) =>
                                                        SizedBox(
                                                  height: 15.sp,
                                                ),
                                                itemCount:
                                                    userInfo['extra_fields']
                                                            [index]['fields']
                                                        .length,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                  height: 35.sp,
                                ),
                                CommonText.textBoldWeight600(
                                    text: "QUALIFICATIONS"),
                                GetBuilder<GetUserAvatarRoleViewModel>(
                                  builder: (controller) {
                                    if (controller.getQualificationListResponse
                                            .status ==
                                        Status.LOADING) {
                                      return Padding(
                                        padding: EdgeInsets.only(top: 100.sp),
                                        child: const Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    }
                                    if (controller.getQualificationListResponse
                                            .status ==
                                        Status.COMPLETE) {
                                      QualificationResponseModel
                                          qualificationResponseModel =
                                          controller
                                              .getQualificationListResponse
                                              .data;
                                      final qualificationList =
                                          qualificationResponseModel
                                              .data!.qualifications!;
                                      return ListView.separated(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                                onTap: () {
                                                  controller.addQualification(
                                                      qualificationList[index]
                                                          .text!);
                                                  controller
                                                      .addQualificationImageId(
                                                          qualificationList[
                                                                  index]
                                                              .imgId!);
                                                },
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 15.sp),
                                                leading: CachedNetworkImage(
                                                    fadeInDuration:
                                                        Duration.zero,
                                                    imageUrl: AppImages
                                                            .appImagePrefix +
                                                        qualificationList[index]
                                                            .imgId!,
                                                    width: 24.sp,
                                                    height: 24.sp),
                                                title: Text(
                                                    qualificationList[index]
                                                        .text!),
                                                trailing: Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.blue,
                                                          width: 2)),
                                                  child: controller
                                                          .qualificationList
                                                          .contains(
                                                              qualificationList[
                                                                      index]
                                                                  .text!)
                                                      ? Container(
                                                          height: 10,
                                                          width: 10,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.blue,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        )
                                                      : const SizedBox(
                                                          height: 10,
                                                          width: 10,
                                                        ),
                                                ));
                                          },
                                          separatorBuilder: (context, index) =>
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.sp),
                                                child: const Divider(
                                                  height: 0,
                                                ),
                                              ),
                                          itemCount: qualificationList.length);
                                    }

                                    return const SizedBox();
                                  },
                                ),
                                SizedBox(
                                  height: 50.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          bottomNavigationBar: args['isFromOnBoarding'] == true
              ? SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20.sp),
                    child: CommonWidget.commonButton(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            progress!.show();

                            final userQualifications =
                                getUserAvatarRoleViewModel.qualificationList
                                    .toString()
                                    .replaceAll("[", '')
                                    .replaceAll("]", '')
                                    .replaceAll(",", "|");

                            var response;

                            if (userInfo['extra_fields'] != null) {
                              Map<String, dynamic> extraFields = {};

                              tempControllers.forEach((key, value) {
                                extraFields.addAll({key: value.text});
                              });

                              extraFields.addAll({
                                "first_name": firstName.text,
                                "last_name": lastName.text,
                                "mobile": mobileNo.text,
                                "avatar": userDetailViewModel.userAvatar != null
                                    ? userDetailViewModel.userAvatar!
                                    : "",
                                "position":
                                    getUserAvatarRoleViewModel.position.text,
                                "crew_number": crewNumber.text,
                                "display_name": displayName.text,
                                "qualification": userQualifications
                              });

                              response =
                                  await SendUserDetailRepo.sendUserDetail(
                                      isFromOnBoarding: true,
                                      firstName: firstName.text,
                                      lastName: lastName.text,
                                      mobile: mobileNo.text,
                                      avatar:
                                          userDetailViewModel.userAvatar != null
                                              ? userDetailViewModel.userAvatar!
                                              : "",
                                      position: getUserAvatarRoleViewModel
                                          .position.text,
                                      crewNumber: crewNumber.text,
                                      displayName: displayName.text,
                                      qualification: userQualifications,
                                      isContainsExtraField: true,
                                      reqBodyWithExtraField: extraFields);
                            } else {
                              response =
                                  await SendUserDetailRepo.sendUserDetail(
                                      firstName: firstName.text,
                                      lastName: lastName.text,
                                      mobile: mobileNo.text,
                                      avatar:
                                          userDetailViewModel.userAvatar != null
                                              ? userDetailViewModel.userAvatar!
                                              : "",
                                      position: getUserAvatarRoleViewModel
                                          .position.text,
                                      crewNumber: crewNumber.text,
                                      displayName: displayName.text,
                                      qualification: userQualifications);
                            }

                            if (response['success'] == true) {
                              if (Platform.isAndroid) {
                                _navigationService
                                    .navigateTo(AppRoutes.allSetScreen);
                              } else {
                                _navigationService.navigateTo(
                                    AppRoutes.enableNotificationScreen);
                              }

                              progress.dismiss();
                            } else {
                              CommonWidget.getSnackBar(context,
                                  color: CommonColor.red,
                                  duration: 1,
                                  message: response['error']);
                            }
                          } else {
                            if (getUserAvatarRoleViewModel
                                .position.text.isEmpty) {
                              CommonWidget.getSnackBar(context,
                                  color: CommonColor.red,
                                  duration: 1,
                                  message: "Please select the position");
                            }
                            if (firstName.text.isEmpty) {
                              CommonWidget.getSnackBar(context,
                                  color: CommonColor.red,
                                  duration: 1,
                                  message: "Please enter the First Name");
                            }
                            if (lastName.text.isEmpty) {
                              CommonWidget.getSnackBar(context,
                                  color: CommonColor.red,
                                  duration: 1,
                                  message: "Please enter the Last Name");
                            }
                          }
                        },
                        text: AppStrings.continueText),
                  ),
                )
              : const SizedBox(),
        );
      },
    ));
  }

  /// Change Status Action Sheet:
  Future<dynamic> buildShowAdaptiveActionSheet(
    BuildContext bottomSheetContext, {
    List<String>? actionsValueList,
  }) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: List.generate(
        actionsValueList!.length,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: utf8convert(actionsValueList[index].toString()),
              color: CommonColor.blue),
          onPressed: (context) async {
            getUserAvatarRoleViewModel.setPosition(TextEditingController(
                text: actionsValueList[index].toString()));
            Navigator.pop(context);
          },
        ),
      ),
      cancelAction: CancelAction(
        title: CommonText.textBoldWeight700(text: AppStrings.cancel),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }
}
