import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_widget.dart';
import '../constant/image_const.dart';
import '../models/response_model/qualification_response_model.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import '../viewModel/get_user_avatar_role_view_model.dart';
import '../viewModel/get_user_detail_view_model.dart';

class SelectQualificationScreen extends StatefulWidget {
  const SelectQualificationScreen({Key? key}) : super(key: key);

  @override
  State<SelectQualificationScreen> createState() =>
      _SelectQualificationScreenState();
}

class _SelectQualificationScreenState extends State<SelectQualificationScreen> {
  final NavigationService _navigationService = NavigationService();

  int roleSelected = -1;

  GetUserAvatarRoleViewModel getUserAvatarRoleViewModel =
      Get.put(GetUserAvatarRoleViewModel());

  GetUserDetailViewModel getUserDetailViewModel =
      Get.put(GetUserDetailViewModel());

  String searchText = "";

  TextEditingController searchController = TextEditingController();

  List temQualification = [];

  var userInfo;

  populateUserDetail() async {
    await getUserDetailViewModel.getUserDetailDataWithoutModel();
    final userDetails =
        getUserDetailViewModel.getUserDetailResponseWithoutModel.data;
    userInfo = userDetails['data'];
    setState(() {});
  }

  InputDecoration inputDecoration = InputDecoration(
    filled: true,
    contentPadding: EdgeInsets.only(top: 15.sp, left: 25.sp),
    fillColor: Colors.white,
    border: InputBorder.none,
    hintText: "SEARCH",
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(30),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(30),
    ),
  );

  @override
  void initState() {
    getUserAvatarRoleViewModel.getQualificationList();
    populateUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Qualification==>${getUserAvatarRoleViewModel.qualificationList}");
    print("Image ID==>${getUserAvatarRoleViewModel.qualificationImageIdList}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.commonAppBar(
          title: "Select Qualifications",
          leading: IconButton(
            onPressed: () async {
              getUserDetailViewModel.updateQualification(
                  getUserAvatarRoleViewModel.qualificationList);

              getUserDetailViewModel.updateQualificationImageList(
                  getUserAvatarRoleViewModel.qualificationImageIdList);

              _navigationService.pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          actions: [
            TextButton(
              onPressed: () {
                try {
                  getUserDetailViewModel.updateQualification(
                      getUserAvatarRoleViewModel.tempQualificationList);

                  getUserDetailViewModel.updateQualificationImageList(
                      getUserAvatarRoleViewModel.tempQualificationImageIdList);
                } catch (e) {
                  // TODO
                }
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
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                  color: const Color(0xffeeeef2),
                  child: Center(
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) {
                          searchText = value;
                          setState(() {});
                        },
                        decoration: inputDecoration,
                      ),
                    ),
                  ),
                ),
                GetBuilder<GetUserAvatarRoleViewModel>(
                  builder: (controller) {
                    if (controller.getQualificationListResponse.status ==
                        Status.LOADING) {
                      return Padding(
                        padding: EdgeInsets.only(top: 100.sp),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (controller.getQualificationListResponse.status ==
                        Status.COMPLETE) {
                      QualificationResponseModel qualificationResponseModel =
                          controller.getQualificationListResponse.data;

                      var qualificationList = qualificationResponseModel
                          .data!.qualifications!
                          .where((element) => element.text!
                              .toLowerCase()
                              .contains(searchText.toLowerCase()))
                          .toList();

                      return Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return ListTile(
                                  onTap: () {
                                    controller.addQualification(
                                        qualificationList[index].text!);
                                    controller.addQualificationImageId(
                                        qualificationList[index].imgId!);
                                  },
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15.sp),
                                  leading: CachedNetworkImage(
                                      fadeInDuration: Duration.zero,
                                      imageUrl: AppImages.appImagePrefix +
                                          qualificationList[index].imgId!,
                                      width: 24.sp,
                                      height: 24.sp),
                                  title: Text(qualificationList[index].text!),
                                  trailing: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.blue, width: 2)),
                                    child: controller.qualificationList
                                            .contains(
                                                qualificationList[index].text!)
                                        ? Container(
                                            height: 10,
                                            width: 10,
                                            decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                        : const SizedBox(
                                            height: 10,
                                            width: 10,
                                          ),
                                  ));
                            },
                            separatorBuilder: (context, index) => Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.sp),
                                  child: const Divider(
                                    height: 0,
                                  ),
                                ),
                            itemCount: qualificationList.length),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
