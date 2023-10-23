import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_widget.dart';
import '../models/response_model/role_response_model.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import '../viewModel/get_user_avatar_role_view_model.dart';
import '../viewModel/get_user_detail_view_model.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({Key? key}) : super(key: key);

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  final NavigationService _navigationService = NavigationService();

  int roleSelected = -1;

  GetUserAvatarRoleViewModel getUserAvatarRoleViewModel =
      Get.put(GetUserAvatarRoleViewModel());

  GetUserDetailViewModel getUserDetailViewModel =
      Get.put(GetUserDetailViewModel());

  String searchText = "";

  TextEditingController searchController = TextEditingController();

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
    getUserAvatarRoleViewModel.getRoleList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.commonAppBar(
          title: "Select Role",
          leading: IconButton(
            onPressed: () async {
              _navigationService.pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          actions: [
            TextButton(
              onPressed: () {
                getUserDetailViewModel
                    .updateUserPosition(args['previousRole'] ?? "");
                getUserDetailViewModel.clearUserRole();
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
                    if (controller.getRoleListResponse.status ==
                        Status.LOADING) {
                      return Padding(
                        padding: EdgeInsets.only(top: 100.sp),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (controller.getRoleListResponse.status ==
                        Status.COMPLETE) {
                      RoleResponseModel roleResponseModel =
                          controller.getRoleListResponse.data;

                      var roleList = roleResponseModel.data!.roles!
                          .where((element) => element
                              .toLowerCase()
                              .contains(searchText.toLowerCase()))
                          .toList();

                      return Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10.sp),
                                title: Text(roleList[index]),
                                value: index,
                                groupValue: roleList[index] ==
                                    getUserAvatarRoleViewModel
                                                .position.text ||
                                        roleList[index] ==
                                            getUserDetailViewModel.userRole
                                    ? index
                                    : -1,
                                onChanged: (value) {
                                  roleSelected = value!;
                                  setState(() {});
                                  getUserDetailViewModel
                                      .updateUserRole(roleList[value]);
                                  getUserDetailViewModel.position =
                                      TextEditingController(
                                          text: roleList[value]);
                                },
                              );
                            },
                            separatorBuilder: (context, index) => Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.sp),
                                  child: const Divider(
                                    height: 0,
                                  ),
                                ),
                            itemCount: roleList.length),
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
