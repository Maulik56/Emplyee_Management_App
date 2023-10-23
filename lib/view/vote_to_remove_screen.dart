import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/repo/update_user_vote_repo.dart';
import 'package:news_app/services/navigation_service/navigation_service.dart';
import '../components/common_text.dart';
import '../constant/color_const.dart';
import '../constant/routes_const.dart';
import '../services/api_service/api_response.dart';
import '../viewModel/get_user_detail_view_model.dart';

class VoteToRemoveScreen extends StatefulWidget {
  final String targetUserId;

  const VoteToRemoveScreen({super.key, required this.targetUserId});

  @override
  State<VoteToRemoveScreen> createState() => _VoteToRemoveScreenState();
}

class _VoteToRemoveScreenState extends State<VoteToRemoveScreen> {
  final NavigationService _navigationService = NavigationService();

  GetUserDetailViewModel getUserDetailViewModel =
      Get.put(GetUserDetailViewModel());

  @override
  void initState() {
    getUserDetailViewModel.getUserVoteDetail(targetUserId: widget.targetUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: Builder(
      builder: (context) {
        final progress = ProgressHUD.of(context);
        return Scaffold(
          backgroundColor: const Color(0xfff2f2f4),
          appBar: CommonWidget.commonAppBar(
            title: VoteToRemoveStrings.voteToRemove,
            leading: InkResponse(
              onTap: () {
                _navigationService.pop();
              },
              child: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Description:
              Padding(
                padding: EdgeInsets.only(
                    left: 10.sp, right: 10.sp, top: 22.sp, bottom: 22.sp),
                child: CommonText.textBoldWeight400(
                    text: VoteToRemoveStrings.removingUsersRequires,
                    textAlign: TextAlign.center,
                    color: CommonColor.greyColor838589,
                    fontSize: 13.sp),
              ),

              /// Team member and current votes:
              GetBuilder<GetUserDetailViewModel>(
                builder: (controller) {
                  if (controller.getUserVoteDetailResponse.status ==
                      Status.LOADING) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.getUserVoteDetailResponse.status ==
                      Status.COMPLETE) {
                    final voteDetail =
                        controller.getUserVoteDetailResponse.data;
                    final userVoteInfo = voteDetail['data'];

                    print("IS VOTED==>${userVoteInfo['voted']}");
                    return Column(
                      children: [
                        const Divider(
                          height: 0,
                          thickness: 1,
                        ),
                        Material(
                          color: Colors.white,
                          child: ListTile(
                            minVerticalPadding: 0,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 13.sp),
                            title: const Text(
                              VoteToRemoveStrings.teamMember,
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xff7a7a6d)),
                            ),
                            trailing: Text(
                              userVoteInfo['name'],
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 0,
                          thickness: 1,
                        ),
                        Material(
                          color: Colors.white,
                          child: ListTile(
                            minVerticalPadding: 0,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 13.sp),
                            title: const Text(
                              VoteToRemoveStrings.currentVotes,
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xff7a7a6d)),
                            ),
                            trailing: Text(
                              "${userVoteInfo['current_votes']} of ${userVoteInfo['required_votes']}",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 0,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 30.sp,
                        ),
                        addMyVoteButton(
                            isVoted: userVoteInfo['voted'], progress: progress)
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        );
      },
    ));
  }

  /// Add My Vote Button:
  Widget addMyVoteButton({required bool isVoted, var progress}) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(
              height: 0,
            ),
            ListTile(
              onTap: () async {
                progress!.show();
                var response = await UpdateUserVoteRepo.updateUserVote(
                    targetUserId: widget.targetUserId, isVoted: isVoted);

                if (response['success'] == true) {
                  if (response['data']['user_removed'] == true) {
                    progress.dismiss();
                    CommonWidget.getSnackBar(context,
                        color: CommonColor.blue,
                        duration: 1,
                        message: response['data']['message'].toString());

                    _navigationService.navigateTo(AppRoutes.mainScreen,
                        clearStack: true);
                  } else {
                    progress.dismiss();
                    getUserDetailViewModel.getUserVoteDetail(
                        targetUserId: widget.targetUserId, isLoading: false);

                    showOkAlertDialog(
                      context: context,
                      builder: (context, child) => AdaptiveDialogBox(
                        message: response['data']['message'].toString(),
                      ),
                    );
                  }
                } else {
                  progress.dismiss();
                  getUserDetailViewModel.getUserVoteDetail(
                      targetUserId: widget.targetUserId, isLoading: false);

                  showOkAlertDialog(
                    context: context,
                    builder: (context, child) => AdaptiveDialogBox(
                      message: response['data']['message'].toString(),
                    ),
                  );
                }
              },
              title: Text(
                !isVoted
                    ? VoteToRemoveStrings.addMyVote
                    : VoteToRemoveStrings.removeMyVote,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: CommonColor.blue,
                  fontWeight: FontWeight.w600,
                ),
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
}
