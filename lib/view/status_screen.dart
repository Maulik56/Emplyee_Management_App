import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/common_text.dart';
import 'package:news_app/constant/image_const.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/models/response_model/status_response_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../components/common_widget.dart';
import 'package:get/get.dart';
import '../components/connectivity_checker.dart';
import '../constant/color_const.dart';
import '../services/api_service/api_response.dart';
import '../viewModel/get_header_data_view_model.dart';
import '../viewModel/get_status_data_view_model.dart';
import 'package:flutter/services.dart';
import 'main_screen.dart';
import 'my_profile_screen.dart';

enum StatusList { all, available, unavailable }

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  GetStatusDataViewModel getStatusDataViewModel =
      Get.put(GetStatusDataViewModel());

  GetHeaderDataViewModel getHeaderDataViewModel =
      Get.put(GetHeaderDataViewModel());

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  void refreshTeamList() {
    getHeaderDataViewModel.getHeaderData(isLoading: false);
    setState(() {});
    switch (getStatusDataViewModel.selectedSegment) {
      case StatusList.available:
        getStatusDataViewModel.getStatusData(
            needFilter: true,
            queryParameter: AppStrings.available.toLowerCase(),
            isLoading: false);
        break;
      case StatusList.unavailable:
        getStatusDataViewModel.getStatusData(
            needFilter: true,
            queryParameter: AppStrings.unavailable.toLowerCase(),
            isLoading: false);
        break;
      case StatusList.all:
        getStatusDataViewModel.getStatusData(isLoading: false);
        break;
    }
  }

  @override
  void initState() {
    if (getStatusDataViewModel.isRefreshed) {
      getStatusDataViewModel.isRefreshed = false;
      getStatusDataViewModel.getStatusData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<GetStatusDataViewModel>(
        builder: (controller) {
          if (controller.getStatusApiResponse.status == Status.LOADING) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (controller.getStatusApiResponse.status == Status.COMPLETE) {
            StatusResponseModel statusResponseModel =
                controller.getStatusApiResponse.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Bars:
                Column(
                  children: List.generate(
                    statusResponseModel.data!.header!.bars!.length,
                    (index) {
                      final bars =
                          statusResponseModel.data!.header!.bars![index];

                      final pos =
                          bars.pos != 0 ? double.parse(bars.pos.toString()) : 0;

                      final max = num.parse(bars.max.toString()) != 0
                          ? double.parse(bars.max.toString())
                          : 0;

                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.sp, vertical: 12.sp),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80.sp,
                                  child: CommonText.textBoldWeight500(
                                      text: bars.text!, fontSize: 13.sp),
                                ),
                                CommonWidget.commonSizedBox(width: 10.sp),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: Colors.black54)),
                                    child: LinearProgressIndicator(
                                      color: bars.color != null
                                          ? Color(int.parse(
                                              "0xff${bars.color!.replaceAll("#", "").removeAllWhitespace}"))
                                          : CommonColor.lightGrayColor400,
                                      backgroundColor: Colors.transparent,
                                      value:
                                          pos == 0 || max == 0 ? 0 : pos / max,
                                      minHeight: 8.sp,
                                    ),
                                  ),
                                ),
                                CommonWidget.commonSizedBox(width: 10.sp),
                                SizedBox(
                                    width: 40.sp,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CommonText.textBoldWeight400(
                                            fontSize: 13,
                                            text: "${bars.pos}/${bars.max}",
                                            color: Colors.blue),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                        ],
                      );
                    },
                  ),
                ),

                /// Cupertino Sliding Segmented Control:
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                  color: Colors.white,
                  child: CupertinoSlidingSegmentedControl<StatusList>(
                    backgroundColor: CupertinoColors.systemGrey5,
                    thumbColor: Colors.white,
                    // This represents the currently selected segmented control.
                    groupValue: controller.selectedSegment,
                    // Callback that sets the selected segmented control.
                    onValueChanged: (StatusList? value) async {
                      await connectivityChecker
                          .checkInterNet()
                          .then((value) => {});

                      if (connectivityChecker.isConnected) {
                        if (value != null) {
                          try {
                            controller.changeSegment(value);
                            refreshTeamList();
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(noConnectionSnackBar);
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(noConnectionSnackBar);
                      }
                    },
                    children: <StatusList, Widget>{
                      StatusList.all: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: Text(
                          AppStrings.all,
                          style: TextStyle(
                              color: CupertinoColors.black, fontSize: 12.sp),
                        ),
                      ),
                      StatusList.available: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: Text(
                          AppStrings.available,
                          style: TextStyle(
                              color: CupertinoColors.black, fontSize: 12.sp),
                        ),
                      ),
                      StatusList.unavailable: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: Text(
                          AppStrings.unavailable,
                          style: TextStyle(
                              color: CupertinoColors.black, fontSize: 12.sp),
                        ),
                      ),
                    },
                  ),
                ),

                /// ListView:
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: statusResponseModel.data!.header!.team!.isEmpty
                        ? Center(
                            child: CommonText.textBoldWeight400(
                                text: AppStrings.noTeamMembers,
                                fontSize: 22.sp,
                                color: Colors.grey.shade400),
                          )
                        : SmartRefresher(
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 8.sp),
                              itemCount: statusResponseModel
                                  .data!.header!.team!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final teamData = statusResponseModel
                                    .data!.header!.team![index];
                                return Column(
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        onTap: () {
                                          connectivityChecker
                                              .checkInterNet()
                                              .then((value) {
                                            if (connectivityChecker
                                                .isConnected) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyProfileScreen(
                                                          needDrawer: false,
                                                          isAnotherUser:
                                                              teamData.nameBold ??
                                                                      false
                                                                  ? false
                                                                  : true,
                                                          userId: teamData.id),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(
                                                    noConnectionSnackBar);
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.sp, vertical: 8.sp),
                                          child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                  fadeInDuration: Duration.zero,
                                                  imageUrl:
                                                      AppImages.appImagePrefix +
                                                          teamData.imageId!,
                                                  height: 25.sp,
                                                  width: 25.sp),
                                              SizedBox(
                                                width: 10.sp,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CommonText.textBoldWeight400(
                                                      text: utf8convert(teamData
                                                          .displayName!),
                                                      fontSize: 13.sp,
                                                      fontWeight: teamData
                                                                  .nameBold ==
                                                              true
                                                          ? FontWeight.bold
                                                          : FontWeight.w400),
                                                  teamData.detailText != null
                                                      ? CommonText
                                                          .textBoldWeight400(
                                                          text: teamData
                                                              .detailText!
                                                              .text!,
                                                          fontSize: 11.sp,
                                                          color: teamData
                                                                      .detailText!
                                                                      .color !=
                                                                  null
                                                              ? Color(int.parse(
                                                                  "0xff${teamData.detailText!.color!.replaceAll("#", "").removeAllWhitespace}"))
                                                              : Colors.black,
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                              const Spacer(),
                                              CachedNetworkImage(
                                                  fadeInDuration: Duration.zero,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          SizedBox(
                                                              height: 15.sp,
                                                              width: 15.sp),
                                                  imageUrl:
                                                      AppImages.appImagePrefix +
                                                          teamData.icons![0],
                                                  height: 15.sp,
                                                  width: 15.sp),
                                              SizedBox(
                                                width: 6.sp,
                                              ),
                                              CachedNetworkImage(
                                                  fadeInDuration: Duration.zero,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          SizedBox(
                                                              height: 15.sp,
                                                              width: 15.sp),
                                                  imageUrl:
                                                      AppImages.appImagePrefix +
                                                          teamData.icons![1],
                                                  height: 15.sp,
                                                  width: 15.sp),
                                              SizedBox(
                                                width: 6.sp,
                                              ),
                                              CachedNetworkImage(
                                                  fadeInDuration: Duration.zero,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          SizedBox(
                                                              height: 15.sp,
                                                              width: 15.sp),
                                                  imageUrl:
                                                      AppImages.appImagePrefix +
                                                          teamData.icons![2],
                                                  height: 15.sp,
                                                  width: 15.sp),
                                              SizedBox(
                                                width: 6.sp,
                                              ),
                                              CachedNetworkImage(
                                                  fadeInDuration: Duration.zero,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          SizedBox(
                                                              height: 15.sp,
                                                              width: 15.sp),
                                                  imageUrl:
                                                      AppImages.appImagePrefix +
                                                          teamData.icons![3],
                                                  height: 15.sp,
                                                  width: 15.sp),
                                              SizedBox(
                                                width: 25.sp,
                                              ),
                                              CachedNetworkImage(
                                                  fadeInDuration: Duration.zero,
                                                  imageUrl: AppImages
                                                          .appImagePrefix +
                                                      teamData.imageRightId!,
                                                  height: 21.sp,
                                                  width: 21.sp),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      height: 0,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  /// On Pull To Refresh:
  void _onRefresh() async {
    try {
      HapticFeedback.lightImpact();
      refreshTeamList();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshCompleted();
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(noConnectionSnackBar);
    }
  }
}
