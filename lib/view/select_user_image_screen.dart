import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_widget.dart';

import '../constant/image_const.dart';
import '../models/response_model/avatar_response_model.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import '../viewModel/get_user_avatar_role_view_model.dart';
import '../viewModel/get_user_detail_view_model.dart';

class SelectUserImageScreen extends StatefulWidget {
  const SelectUserImageScreen({Key? key}) : super(key: key);

  @override
  State<SelectUserImageScreen> createState() => _SelectUserImageScreenState();
}

class _SelectUserImageScreenState extends State<SelectUserImageScreen> {
  final NavigationService _navigationService = NavigationService();

  int avatarSelected = -1;

  GetUserAvatarRoleViewModel getUserAvatarRoleViewModel =
      Get.put(GetUserAvatarRoleViewModel());

  GetUserDetailViewModel getUserDetailViewModel =
      Get.put(GetUserDetailViewModel());

  @override
  void initState() {
    getUserAvatarRoleViewModel.getAvatarList();
    super.initState();
  }

  String? tempAvatar;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.commonAppBar(
          title: "Select User Image",
          leading: IconButton(
            onPressed: () {
              _navigationService.pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          actions: [
            TextButton(
              onPressed: () {
                getUserDetailViewModel.updateUserAvatar(args['previousAvatar']);
                _navigationService.pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
              ),
            )
          ]),
      body: ProgressHUD(child: Builder(
        builder: (context) {
          final progress = ProgressHUD.of(context);
          return Scaffold(
            body: GetBuilder<GetUserAvatarRoleViewModel>(
              builder: (controller) {
                if (controller.getAvatarListResponse.status == Status.LOADING) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.getAvatarListResponse.status ==
                    Status.COMPLETE) {
                  AvatarResponseModel avatarResponseModel =
                      controller.getAvatarListResponse.data;

                  return ListView.separated(
                      itemBuilder: (context, index) {
                        final avatarList =
                            avatarResponseModel.data!.avatars![index];
                        return GetBuilder<GetUserDetailViewModel>(
                          builder: (controller) => RadioListTile(
                            //activeColor: Colors.green,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.sp,
                              vertical: 5.sp,
                            ),
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CachedNetworkImage(
                                    errorWidget: (context, url, error) =>
                                        SizedBox(width: 24.sp, height: 24.sp),
                                    fadeInDuration: Duration.zero,
                                    imageUrl: AppImages.appImagePrefix +
                                        avatarList.id!,
                                    width: 48.sp,
                                    height: 48.sp),
                                SizedBox(
                                  width: 15.sp,
                                ),
                                Text(avatarList.text!),
                              ],
                            ),
                            value: index,
                            groupValue:
                                avatarList.id == controller.userAvatar ||
                                        avatarList.id == tempAvatar
                                    ? index
                                    : -1,
                            onChanged: (value) {
                              avatarSelected = value!;
                              tempAvatar = avatarList.id;
                              getUserDetailViewModel
                                  .updateUserAvatar(avatarList.id!);
                              setState(() {});
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.sp),
                            child: const Divider(
                              height: 0,
                            ),
                          ),
                      itemCount: avatarResponseModel.data!.avatars!.length);
                }

                return const SizedBox();
              },
            ),
          );
        },
      )),
    );
  }
}
