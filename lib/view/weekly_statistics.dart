import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/api_const.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/services/api_service/api_response.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../components/banner_widget.dart';
import '../components/common_text.dart';
import '../components/connectivity_checker.dart';
import '../components/intercepters.dart';
import '../constant/color_const.dart';
import '../constant/image_const.dart';
import '../constant/routes_const.dart';
import '../models/response_model/statistics_response_model.dart';
import '../services/navigation_service/navigation_service.dart';
import '../viewModel/get_banner_view_model.dart';
import '../viewModel/get_statistics_view_model.dart';

class WeeklyStatisticsScreen extends StatefulWidget {
  const WeeklyStatisticsScreen({super.key});

  @override
  State<WeeklyStatisticsScreen> createState() => _WeeklyStatisticsScreenState();
}

class _WeeklyStatisticsScreenState extends State<WeeklyStatisticsScreen> {
  final NavigationService _navigationService = NavigationService();

  TooltipBehavior? _thisWeekTooltipBehavior;
  TooltipBehavior? _previousWeekTooltipBehavior;

  GetStatisticsViewModel getStatisticsViewModel =
      Get.put(GetStatisticsViewModel());

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  GetBannerViewModel getBannerViewModel = Get.put(GetBannerViewModel());

  @override
  void initState() {
    connectivityChecker.checkInterNet();
    _thisWeekTooltipBehavior = TooltipBehavior(enable: true);
    _previousWeekTooltipBehavior = TooltipBehavior(enable: true);
    getBannerViewModel.getBannerInfo(screenId: Banners.weeklyStats);
    getStatisticsViewModel.getStatisticsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: Builder(builder: (context) {
      final progress = ProgressHUD.of(context);
      return GetBuilder<GetBannerViewModel>(
        builder: (bannerController) => Scaffold(
            backgroundColor: const Color(0xfff2f2f4),
            appBar: CommonWidget.commonAppBar(
                title: WeeklyStatisticsStrings.weeklyStatistics,
                leading: InkResponse(
                  onTap: () async {
                    progress!.show();
                    await getBannerViewModel.getBannerInfo(
                        screenId: Banners.mainScreen);
                    Interceptors.mainScreenInterceptor();
                    _navigationService.pop();
                    progress.dismiss();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
                bottomWidget: PreferredSize(
                  preferredSize: Size.fromHeight(
                    bannerController.isVisible ? 50.sp : 0,
                  ),
                  child: BannerWidget(),
                )),
            body: GetBuilder<ConnectivityChecker>(
              builder: (controller) {
                return controller.isConnected
                    ? GetBuilder<GetStatisticsViewModel>(
                        builder: (controller) {
                          if (controller.getStatisticsResponse.status ==
                              Status.LOADING) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (controller.getStatisticsResponse.status ==
                              Status.COMPLETE) {
                            StatisticsResponseModel statisticsResponseModel =
                                controller.getStatisticsResponse.data;
                            final thisWeek =
                                statisticsResponseModel.data!.thisWeek;
                            final prevWeek =
                                statisticsResponseModel.data!.prevWeeks;
                            final showHistory =
                                statisticsResponseModel.data?.showHistory;
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  thisWeek!.isNotEmpty
                                      ? SfCartesianChart(
                                          backgroundColor: Colors.white,
                                          tooltipBehavior:
                                              _thisWeekTooltipBehavior,
                                          title: ChartTitle(
                                              text: statisticsResponseModel
                                                      .data!.thisWeekTitle ??
                                                  "This Weeks"),
                                          primaryXAxis: CategoryAxis(
                                            majorGridLines:
                                                const MajorGridLines(width: 0),
                                          ),
                                          primaryYAxis: NumericAxis(
                                            majorGridLines:
                                                const MajorGridLines(width: 0),
                                          ),
                                          series: <ColumnSeries<Week, String>>[
                                            ColumnSeries<Week, String>(
                                              // Binding the chartData to the dataSource of the column series.
                                              dataSource: thisWeek,
                                              xValueMapper: (Week data, _) =>
                                                  data.label,
                                              yValueMapper: (Week data, _) =>
                                                  data.value,
                                            ),
                                          ],
                                        )
                                      : const Text(
                                          "No Data Found for this week"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  prevWeek!.isNotEmpty
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SfCartesianChart(
                                              backgroundColor: Colors.white,
                                              tooltipBehavior:
                                                  _previousWeekTooltipBehavior,
                                              title: ChartTitle(
                                                  text: "Previous Weeks"),
                                              primaryXAxis: CategoryAxis(
                                                majorGridLines:
                                                    const MajorGridLines(
                                                        width: 0),
                                              ),
                                              primaryYAxis: NumericAxis(
                                                majorGridLines:
                                                    const MajorGridLines(
                                                        width: 0),
                                              ),
                                              series: <
                                                  ColumnSeries<Week, String>>[
                                                ColumnSeries<Week, String>(
                                                  // Binding the chartData to the dataSource of the column series.
                                                  dataSource: prevWeek,
                                                  xValueMapper:
                                                      (Week data, _) =>
                                                          data.label,
                                                  yValueMapper:
                                                      (Week data, _) =>
                                                          data.value,
                                                ),
                                              ],
                                            ),
                                            showHistory == false
                                                ?

                                                /// Unlock historic data button:
                                                SizedBox(
                                                    height: 40,
                                                    child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7),
                                                        ),
                                                        side: BorderSide(
                                                          color: CommonColor
                                                              .greyBorderColor,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _navigationService
                                                            .navigateTo(
                                                                AppRoutes
                                                                    .subscriptionScreen,
                                                                arguments: {
                                                              'isFromDrawer':
                                                                  false
                                                            });
                                                      },
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CachedNetworkImage(
                                                            fadeInDuration:
                                                                Duration.zero,
                                                            imageUrl: AppImages
                                                                .unlockIcon,
                                                            width: 26.sp,
                                                            height: 26.sp,
                                                            alignment:
                                                                const Alignment(
                                                                    0, 0),
                                                          ),
                                                          SizedBox(
                                                            width: 15.sp,
                                                          ),
                                                          CommonText
                                                              .textBoldWeight400(
                                                            color: const Color(
                                                                0xff868686),
                                                            text:
                                                                "Unlock historic data",
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox()
                                          ],
                                        )
                                      : const Text(
                                          "No Data Found for previous week"),
                                ],
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      )
                    : NoInternetWidget(
                        onPressed: () {
                          connectivityChecker.checkInterNet();
                          getBannerViewModel.getBannerInfo(
                              screenId: 'weekly_stats');
                          getStatisticsViewModel.getStatisticsData();
                        },
                      );
              },
            )),
      );
    }));
  }
}

class ChartSampleData {
  final String x;
  final double y;
  ChartSampleData({required this.x, required this.y});
}
