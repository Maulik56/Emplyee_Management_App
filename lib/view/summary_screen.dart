import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_app/constant/color_const.dart';
import 'package:news_app/models/response_model/get_team_summary_response_model.dart'
    as ts;
import 'package:news_app/repo/get_team_summary_repo.dart';
import 'package:news_app/services/api_service/api_response.dart';
import 'package:news_app/viewModel/get_team_summary_view_model.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  GetTeamSummaryViewModel summaryViewModel = Get.put(GetTeamSummaryViewModel());
  final format = new DateFormat.yMMMEd('en-US');

  @override
  void initState() {
    summaryViewModel.updateDate();
    GetTeamSummaryRepo.getCurrentDateRepo(
        date: DateTime.parse(DateTime.now().toUtc().toIso8601String()));
    summaryViewModel.getTeamSummaryViewModel();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<GetTeamSummaryViewModel>(builder: (controller) {
        if (controller.getTeamSummaryResponse.status == Status.LOADING) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.getTeamSummaryResponse.status ==
            Status.COMPLETE) {
          ts.GetTeamSummaryResponseModel response =
              controller.getTeamSummaryResponse.data;
          if (response.data == null) {
            return Center(
              child: Text('No Data Found'),
            );
          } else {
            return Column(
              children: [
                Container(
                  height: 60.sp,
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.grey.withOpacity(0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkResponse(
                        onTap: () {
                          controller.weekRange(
                              currentDate: controller.date, isIncrement: false);
                        },
                        child: Icon(
                          Icons.chevron_left,
                          color: CommonColor.blue,
                        ),
                      ),
                      Text(
                          DateFormat("EEEE, dd MMM, yyyy")
                              .format(controller.date)
                              .toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  color: CommonColor.blue,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.36.sp)),
                      InkResponse(
                          onTap: () {
                            controller.weekRange(
                                currentDate: controller.date,
                                isIncrement: true);
                          },
                          child: Icon(
                            Icons.chevron_right,
                            color: CommonColor.blue,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: response.data!.summary!.length,
                    separatorBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: const Divider(
                        thickness: 1,
                        height: 0,
                      ),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 50.sp,
                        width: Get.width,
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.25,
                                      child: Text(
                                        '${response.data!.summary![index].name}',
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 9.sp,
                                        child: ListView.builder(
                                          itemCount: response.data!
                                              .summary![index].hours!.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder:
                                              (BuildContext context, int index1) {
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0.5),
                                                child: Container(
                                                  height: 8.sp,
                                                  width: 8.sp,
                                                  color: response
                                                          .data!
                                                          .summary![index]
                                                          .hours![index1]
                                                          .toString()
                                                          .contains(
                                                              '${response.data!.colors!.first.char}')
                                                      ? Color(int.parse(
                                                          "0xff${response.data!.colors!.first.color.toString().split('#').last}"))
                                                      : Color(
                                                          int.parse(
                                                              "0xff${response.data!.colors!.last.color.toString().split('#').last}"),
                                                        ),
                                                ));
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }
        } else if (controller.getTeamSummaryResponse.status == Status.ERROR) {
          return Center(
            child: Text('Something Went Wrong'),
          );
        } else {
          return Center(
            child: Text('Something Went Wrong'),
          );
        }
      }),
    );
  }
}
