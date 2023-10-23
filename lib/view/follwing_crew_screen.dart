import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_text.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/image_const.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/view/main_screen.dart';
import 'package:news_app/viewModel/get_banner_view_model.dart';
import '../components/banner_widget.dart';
import '../components/connectivity_checker.dart';
import '../components/description_widget.dart';
import '../constant/api_const.dart';
import '../models/response_model/following_crew_response_model.dart';
import '../repo/change_following_crew_status_repo.dart';
import '../services/api_service/api_response.dart';
import '../viewModel/get_following_crew_view_model.dart';

class FollowingCrewScreen extends StatefulWidget {
  const FollowingCrewScreen({super.key});

  @override
  State<FollowingCrewScreen> createState() => _FollowingCrewScreenState();
}

class _FollowingCrewScreenState extends State<FollowingCrewScreen> {
  GetFollowingCrewViewModel getFollowingCrewViewModel =
      Get.put(GetFollowingCrewViewModel());

  GetBannerViewModel getBannerViewModel = Get.put(GetBannerViewModel());

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  @override
  void initState() {
    connectivityChecker.checkInterNet();
    getBannerViewModel.getBannerInfo(screenId: Banners.followingCrew);
    getFollowingCrewViewModel.getFollowingCrewData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          final progress = ProgressHUD.of(context);
          return Scaffold(
            backgroundColor: const Color(0xfff2f2f4),
            appBar: CommonWidget.commonAppBar(
              title: FollowingCrewStrings.followingCrew,
            ),
            body: GetBuilder<ConnectivityChecker>(
              builder: (controller) {
                return controller.isConnected
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BannerWidget(),
                          const DescriptionWidget(
                            description:
                                FollowingCrewStrings.receiveNotifications,
                          ),
                          GetBuilder<GetFollowingCrewViewModel>(
                            builder: (controller) {
                              if (controller.getFollowingCrewResponse.status ==
                                  Status.LOADING) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 50.sp),
                                    child: const CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (controller.getFollowingCrewResponse.status ==
                                  Status.COMPLETE) {
                                FollowingCrewResponseModel followingCrewData =
                                    controller.getFollowingCrewResponse.data;
                                if (followingCrewData.data!.team!.isNotEmpty) {
                                  return Expanded(
                                    child: Container(
                                      color: Colors.white,
                                      child: SafeArea(
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          itemCount: followingCrewData
                                              .data!.team!.length,
                                          itemBuilder: (context, index) {
                                            final crews = followingCrewData
                                                .data!.team![index];
                                            return ListTile(
                                              minVerticalPadding: 0,
                                              horizontalTitleGap: 1,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 13.sp),
                                              leading: CachedNetworkImage(
                                                  fadeInDuration: Duration.zero,
                                                  imageUrl:
                                                      AppImages.appImagePrefix +
                                                          crews.imageId!,
                                                  width: 24.sp,
                                                  height: 24.sp),
                                              title: Text(utf8convert(
                                                  crews.name ??
                                                      "No Name Found")),
                                              trailing: SwitchWidget(
                                                  isSwitched: crews.checked!,
                                                  contId: crews.id,
                                                  getFollowingCrewViewModel:
                                                      getFollowingCrewViewModel,
                                                  progress: progress),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.sp),
                                            child: const Divider(
                                              thickness: 1,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: CommonText.textBoldWeight500(
                                        text: "No following crew found"),
                                  );
                                }
                              } else {
                                return const SizedBox();
                              }
                            },
                          )
                        ],
                      )
                    : NoInternetWidget(
                        onPressed: () {
                          connectivityChecker.checkInterNet();
                          getBannerViewModel.getBannerInfo(
                              screenId: 'following_crew');
                          getFollowingCrewViewModel.getFollowingCrewData();
                        },
                      );
              },
            ),
            drawer: DrawerWidget(isFollowingCrew: true),
          );
        },
      ),
    );
  }
}

class SwitchWidget extends StatefulWidget {
  bool isSwitched;
  String? contId;
  GetFollowingCrewViewModel? getFollowingCrewViewModel;
  final progress;

  SwitchWidget(
      {super.key,
      this.isSwitched = false,
      this.contId,
      this.getFollowingCrewViewModel,
      this.progress});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: widget.isSwitched,
      onChanged: (value) async {
        widget.progress!.show();
        widget.isSwitched = value;
        await ChangeFollowingCrewStatusRepo.changeStatus(
            contId: widget.contId!, isFollow: value);
        await widget.getFollowingCrewViewModel!
            .getFollowingCrewData(isLoading: false);
        widget.progress.dismiss();
      },
    );
  }
}
