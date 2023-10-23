import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/color_const.dart';
import 'package:news_app/repo/add_new_resource_repo.dart';
import '../models/response_model/resource_category_response_model.dart';
import '../services/api_service/api_response.dart';
import '../services/navigation_service/navigation_service.dart';
import 'package:get/get.dart';
import '../viewModel/get_resource_category_view_model.dart';

enum CategoryList { category1, category2 }

class AddNewResourceScreen extends StatefulWidget {
  final double lat;
  final double long;

  const AddNewResourceScreen(
      {super.key, required this.lat, required this.long});

  @override
  State<AddNewResourceScreen> createState() => _AddNewResourceScreenState();
}

class _AddNewResourceScreenState extends State<AddNewResourceScreen> {
  final NavigationService _navigationService = NavigationService();

  GetResourceCategoryViewModel resourceCategoryViewModel =
      Get.put(GetResourceCategoryViewModel());

  final descriptionController = TextEditingController();

  @override
  void initState() {
    resourceCategoryViewModel.getResourceCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: Builder(
      builder: (context) {
        final progress = ProgressHUD.of(context);
        return GetBuilder<GetResourceCategoryViewModel>(
          builder: (controller) {
            if (controller.getResourceCategoryResponse.status ==
                Status.LOADING) {
              return const Material(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (controller.getResourceCategoryResponse.status ==
                Status.COMPLETE) {
              ResourceCategoryResponseModel resourceCategoryResponseModel =
                  controller.getResourceCategoryResponse.data;
              return Scaffold(
                backgroundColor: const Color(0xffeeeeee),
                appBar: CommonWidget.commonAppBar(
                  title: "New Resource",
                  leadingWidth: 100,
                  leading: TextButton(
                    onPressed: () {
                      resourceCategoryViewModel.image = null;
                      descriptionController.clear();
                      _navigationService.pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 18.sp, color: CommonColor.red),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        if (resourceCategoryViewModel.image != null) {
                          progress!.show();
                          bool status =
                              await AddNewResourceRepo.addNewResourceRepo(
                                  category: controller.selectedSegment ==
                                          CategoryList.category1
                                      ? resourceCategoryResponseModel
                                          .data!.category!.first
                                      : resourceCategoryResponseModel
                                          .data!.category!.last,
                                  lat: widget.lat,
                                  long: widget.long,
                                  image: controller.image!);

                          if (status) {
                            _navigationService.pop();
                            resourceCategoryViewModel.image = null;
                          } else {
                            progress.dismiss();
                            CommonWidget.getSnackBar(
                              context,
                              color: CommonColor.red,
                              duration: 2,
                              message: 'Failed, Please try again!',
                            );
                            resourceCategoryViewModel.image = null;
                            _navigationService.pop();
                          }
                        } else {
                          CommonWidget.getSnackBar(
                            context,
                            color: CommonColor.red,
                            duration: 2,
                            message: 'Please take a picture!',
                          );
                        }
                      },
                      child: Text(
                        "Save",
                        style:
                            TextStyle(fontSize: 18.sp, color: CommonColor.blue),
                      ),
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.pickImageFromCamera();
                        },
                        child: Container(
                          height: 250,
                          margin: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: controller.image == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      size: 50.sp,
                                      color: CommonColor.lightGrayColor400,
                                    ),
                                    SizedBox(height: 15.sp),
                                    const Text("Tap here to take a picture")
                                  ],
                                )
                              : Image.file(
                                  controller.image!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),

                      /// Cupertino Sliding Segmented Control:
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.sp, vertical: 10.sp),
                        child: Center(
                          child: CupertinoSlidingSegmentedControl<CategoryList>(
                            backgroundColor: CommonColor.lightGrayColor400,
                            thumbColor: Colors.white,
                            groupValue: controller.selectedSegment,
                            onValueChanged: (CategoryList? value) {
                              if (value != null) {
                                controller.changeSegment(value);
                                switch (value) {
                                  case CategoryList.category1:
                                    break;
                                  case CategoryList.category2:
                                    break;
                                }
                              }
                            },
                            children: <CategoryList, Widget>{
                              CategoryList.category1: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 40.sp),
                                child: Text(
                                  resourceCategoryResponseModel
                                      .data!.category!.first,
                                  style: TextStyle(
                                      color: CupertinoColors.black,
                                      fontSize: 12.sp),
                                ),
                              ),
                              CategoryList.category2: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 40.sp),
                                child: Text(
                                  resourceCategoryResponseModel
                                      .data!.category!.last,
                                  style: TextStyle(
                                      color: CupertinoColors.black,
                                      fontSize: 12.sp),
                                ),
                              ),
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      const Divider(
                        height: 0,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 7,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: "Enter an optional description here",
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                      ),
                      const Divider(
                        height: 0,
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        );
      },
    ));
  }
}
