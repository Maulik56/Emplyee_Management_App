import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news_app/components/banner_widget.dart';
import 'package:news_app/constant/api_const.dart';
import 'package:news_app/constant/app_info.dart';
import 'package:news_app/constant/image_const.dart';
import 'package:news_app/constant/routes_const.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/view/alert_team_screen.dart';
import 'package:news_app/view/my_profile_screen.dart';
import 'package:news_app/view/status_screen.dart';
import 'package:news_app/view/summary_screen.dart';
import 'package:news_app/viewModel/get_status_data_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../components/common_text.dart';
import '../components/common_widget.dart';
import '../components/connectivity_checker.dart';
import '../constant/color_const.dart';
import '../get_storage_services/get_storage_service.dart';
import '../models/response_model/main_screen_header_model.dart';
import '../repo/change_action_repo.dart';
import '../repo/push_token_repo.dart';
import '../repo/update_status_repo.dart';
import '../services/api_service/api_response.dart';
import '../services/google_ads_service/google_ads_service.dart';
import '../services/navigation_service/navigation_service.dart';
import '../services/notification_service/awesome_notification_service.dart';
import '../viewModel/event_detail_view_model.dart';
import '../viewModel/get_banner_view_model.dart';
import '../viewModel/get_header_data_view_model.dart';
import '../viewModel/get_user_detail_view_model.dart';
import 'auto_book_on_screen.dart';
import 'calender_screen.dart';
import 'event_detail_screen.dart';
import 'messages_screen.dart';

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with WidgetsBindingObserver {
  final NavigationService _navigationService = NavigationService();

  void _sendSMS(String message, List<String> recipients) async {
    String result = await sendSMS(message: message, recipients: recipients)
        .catchError((onError) {
      debugPrint(onError);
    });

    debugPrint(result);
  }

  int selectedIndex = 0;

  List screens = [
    StatusScreen(),
    SummaryScreen(),
    SizedBox(),
    MessagesScreen(),
    CalenderScreen(),
  ];

  GetStatusDataViewModel getStatusDataViewModel =
      Get.put(GetStatusDataViewModel());

  GetHeaderDataViewModel getHeaderDataViewModel =
      Get.put(GetHeaderDataViewModel());

  GetUserDetailViewModel getUserDetailViewModel =
      Get.put(GetUserDetailViewModel());

  GetBannerViewModel getBannerViewModel = Get.put(GetBannerViewModel());

  EventDetailViewModel eventDetailViewModel = Get.put(EventDetailViewModel());

  List bottomItems = [
    {'icon': Icons.home, 'label': AppStrings.status},
    {'icon': AppImages.summary, 'label': AppStrings.summary},
    {'icon': '', 'label': ''},
    {'icon': Icons.chat, 'label': AppStrings.messages},
    {'icon': Icons.calendar_month, 'label': AppStrings.calender},
  ];

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  void saveUserId() async {
    await getUserDetailViewModel.getUserDetailDataWithoutModel();
    final userDetails =
        getUserDetailViewModel.getUserDetailResponseWithoutModel.data;
    try {
      GetStorageServices.setUserId(userDetails['data']['id']);
    } catch (e) {
      // TODO
    }
  }

  void initSetup() async {
    try {
      if (Platform.isAndroid) {
        await Permission.notification.isDenied.then((value) {
          if (value) {
            Permission.notification.request();
          }
        });
      }

      /// Save FCM Token:
      await NotificationController.getFirebaseMessagingToken();

      /// Push token each time the app is opened:
      PushTokenRepo.pushToken(token: GetStorageServices.getFCMToken());

      await NotificationController.initializeLocalNotifications();

      NotificationController.startListeningNotificationEvents();
    } catch (e) {
      // TODO
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    AppInfo.getPackageInfo();
    connectivityChecker.checkInterNet();
    getBannerViewModel.getBannerInfo(screenId: Banners.mainScreen);
    if (getStatusDataViewModel.isRefreshed) {
      getHeaderDataViewModel.getHeaderData();

      try {
        saveUserId();

        /// FCM, Notification, Push token:
        initSetup();
      } catch (e) {
        // TODO
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        refreshTeamList();

        if (kDebugMode) {
          print("app is resumed");
        }
        break;
      case AppLifecycleState.inactive:
        if (kDebugMode) {
          print("app is inactive");
        }
        break;
      case AppLifecycleState.paused:
        if (kDebugMode) {
          print("app is paused");
        }
        break;
      case AppLifecycleState.detached:
        if (kDebugMode) {
          print("app is detached");
        }
        break;
    }
  }

  void refreshTeamList() {
    print("refreshTeamList(); " +
        getStatusDataViewModel.selectedSegment.toString());
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
  Widget build(BuildContext context) {
    return GetBuilder<GetHeaderDataViewModel>(
      builder: (controller) {
        if (controller.getHeaderDataResponse.status == Status.LOADING) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (controller.getHeaderDataResponse.status == Status.COMPLETE) {
          MainScreenHeaderModel mainScreenHeaderModel =
              controller.getHeaderDataResponse.data;

          bool? adShowStatus = mainScreenHeaderModel.data!.showAds;

          return ProgressHUD(
            child: Builder(
              builder: (context) {
                final progress = ProgressHUD.of(context);
                return GetBuilder<GetBannerViewModel>(
                  builder: (bannerController) => Scaffold(
                    appBar: CommonWidget.commonAppBar(
                      title: mainScreenHeaderModel.data!.teamName!,
                      bottomWidget: PreferredSize(
                        preferredSize: Size.fromHeight(
                          bannerController.isVisible ? 100.sp : 50.sp,
                        ),
                        child: Column(
                          children: [
                            BannerWidget(),
                            Container(
                              height: 50.sp,
                              width: double.infinity,
                              color: mainScreenHeaderModel
                                          .data!.header!.bgColor !=
                                      null
                                  ? Color(int.parse(
                                      "0xff${mainScreenHeaderModel.data!.header!.bgColor!.replaceAll("#", "").removeAllWhitespace}"))
                                  : Colors.grey,
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10.sp),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonText.textBoldWeight400(
                                        text: mainScreenHeaderModel
                                                .data!.header!.text ??
                                            "No Status Found",
                                        color: mainScreenHeaderModel
                                                    .data!.header!.textColor !=
                                                null
                                            ? Color(int.parse(
                                                "0xff${mainScreenHeaderModel.data!.header!.textColor!.replaceAll("#", "").removeAllWhitespace}f"))
                                            : Colors.black,
                                        fontSize: 17.sp),

                                    /// Change Status Button:
                                    SizedBox(
                                      height: 35,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          side: BorderSide(
                                            color: mainScreenHeaderModel.data!
                                                        .header!.textColor !=
                                                    null
                                                ? Color(int.parse(
                                                    "0xff${mainScreenHeaderModel.data!.header!.textColor!.replaceAll("#", "").removeAllWhitespace}f"))
                                                : Colors.black,
                                          ),
                                        ),
                                        onPressed: () {
                                          connectivityChecker
                                              .checkInterNet()
                                              .then((value) {
                                            if (connectivityChecker
                                                .isConnected) {
                                              buildShowAdaptiveActionSheet(
                                                  context,
                                                  actionsValueList:
                                                      mainScreenHeaderModel
                                                          .data!
                                                          .header!
                                                          .button!
                                                          .dropDown,
                                                  progress: progress);
                                              setState(() {});
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(
                                                    noConnectionSnackBar);
                                            }
                                          });
                                        },
                                        child: Center(
                                          child: CommonText.textBoldWeight400(
                                            color: mainScreenHeaderModel.data!
                                                        .header!.textColor !=
                                                    null
                                                ? Color(
                                                    int.parse(
                                                        "0xff${mainScreenHeaderModel.data!.header!.textColor!.replaceAll("#", "").removeAllWhitespace}f"),
                                                  )
                                                : Colors.black,
                                            text: AppStrings.change,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        selectedIndex == 0
                            ? IconButton(
                                onPressed: () {
                                  connectivityChecker
                                      .checkInterNet()
                                      .then((value) => {
                                            if (connectivityChecker.isConnected)
                                              {
                                                eventDetailViewModel
                                                    .updateStartTime(
                                                        DateTime.tryParse(
                                                            DateTime.now()
                                                                .toString())!),
                                                eventDetailViewModel
                                                    .updateFinishTime(
                                                        DateTime.parse(
                                                            DateTime.now()
                                                                .toString())),
                                                eventDetailViewModel
                                                    .updateFirstDateSelectedStatus(
                                                        false),
                                                eventDetailViewModel
                                                    .updateSecondDateSelectedStatus(
                                                        false),
                                                eventDetailViewModel
                                                    .updateEditStatus(false),
                                                _navigationService.navigateTo(
                                                  AppRoutes.inviteTeamScreen,
                                                )
                                              }
                                            else
                                              {
                                                ScaffoldMessenger.of(context)
                                                  ..removeCurrentSnackBar()
                                                  ..showSnackBar(
                                                      noConnectionSnackBar)
                                              }
                                          });
                                },
                                icon: const Icon(Icons.person_add),
                              )
                            : const SizedBox(),
                        selectedIndex == 0
                            ? IconButton(
                                onPressed: () {
                                  connectivityChecker
                                      .checkInterNet()
                                      .then((value) => {
                                            if (connectivityChecker.isConnected)
                                              {
                                                _navigationService.navigateTo(
                                                  AppRoutes
                                                      .weeklyStatisticsScreen,
                                                )
                                              }
                                            else
                                              {
                                                ScaffoldMessenger.of(context)
                                                  ..removeCurrentSnackBar()
                                                  ..showSnackBar(
                                                      noConnectionSnackBar)
                                              }
                                          });
                                },
                                icon: Image.asset(AppImages.monitoring,
                                    height: 22.sp),
                              )
                            : const SizedBox(),
                        selectedIndex == 4
                            ? IconButton(
                                onPressed: () {
                                  eventDetailViewModel
                                      .updateStartTime(DateTime.now());
                                  eventDetailViewModel
                                      .updateFinishTime(DateTime.now());

                                  eventDetailViewModel.updateEditStatus(false);

                                  eventDetailViewModel
                                      .updateFirstDateSelectedStatus(false);
                                  eventDetailViewModel
                                      .updateSecondDateSelectedStatus(false);
                                  eventDetailViewModel
                                      .updateSelectedDateTimeFirstTime(true);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetailScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    drawer: DrawerWidget(isMain: true),
                    body: Center(
                      child: screens[selectedIndex],
                    ),
                    bottomNavigationBar: buildBottomNavigationBar(
                        controller: controller,
                        adShowStatus: adShowStatus!,
                        mainScreenHeaderModel: mainScreenHeaderModel),
                  ),
                );
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  /// Bottom Navigation Bar:
  Widget buildBottomNavigationBar(
      {required GetHeaderDataViewModel controller,
      bool adShowStatus = false,
      required MainScreenHeaderModel mainScreenHeaderModel}) {
    return Container(
      color: CommonColor.bottomBarBackgroundColor,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                const Divider(
                  height: 0,
                  color: Color(0xffc8c8c8),
                ),
                SizedBox(
                  height: Platform.isAndroid
                      ? controller.bannerAd != null && adShowStatus == true
                          ? 60
                          : 62.sp
                      : controller.bannerAd != null && adShowStatus == true
                          ? 70.sp
                          : 75.sp,
                  child: BottomAppBar(
                    color: CommonColor.bottomBarBackgroundColor,
                    elevation: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                          bottomItems.length,
                          (index) => InkResponse(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: SizedBox(
                                  width: 60.sp,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Platform.isAndroid
                                          ? const SizedBox()
                                          : SizedBox(
                                              height: 5.sp,
                                            ),
                                      index == 1
                                          ? Image.asset(
                                              AppImages.summary,
                                              height: 23.sp,
                                              width: 23.sp,
                                              color: selectedIndex == 1
                                                  ? CommonColor.tabSelectedColor
                                                  : CommonColor
                                                      .unSelectedTabColor,
                                            )
                                          : index == 2
                                              ? FloatingActionButton(
                                                  onPressed: () {
                                                    connectivityChecker
                                                        .checkInterNet()
                                                        .then(
                                                          (value) => {
                                                            if (connectivityChecker
                                                                .isConnected)
                                                              {
                                                                buildChangeActionSheet(
                                                                    context,
                                                                    actionsValueList: mainScreenHeaderModel
                                                                        .data!
                                                                        .header!
                                                                        .actions)
                                                              }
                                                            else
                                                              {
                                                                ScaffoldMessenger
                                                                    .of(context)
                                                                  ..removeCurrentSnackBar()
                                                                  ..showSnackBar(
                                                                      noConnectionSnackBar)
                                                              }
                                                          },
                                                        );
                                                  },
                                                  child: const Icon(
                                                      Icons.directions_run),
                                                )
                                              : Icon(
                                                  bottomItems[index]['icon'],
                                                  color: selectedIndex == index
                                                      ? CommonColor
                                                          .tabSelectedColor
                                                      : CommonColor
                                                          .unSelectedTabColor,
                                                  size: 23.sp,
                                                ),
                                      SizedBox(
                                        height: 2.sp,
                                      ),
                                      CommonText.textBoldWeight400(
                                          text: bottomItems[index]['label'],
                                          color: selectedIndex == index
                                              ? CommonColor.tabSelectedColor
                                              : CommonColor.unSelectedTabColor,
                                          fontSize: index == 2 ? 0 : 11.sp),
                                    ],
                                  ),
                                ),
                              )),
                    ),
                  ),
                ),
              ],
            ),
            BannerAdmob(adShowStatus: adShowStatus),
          ],
        ),
      ),
    );
  }

  /// Change Status Action Sheet:
  Future<dynamic> buildShowAdaptiveActionSheet(
    BuildContext bottomSheetContext, {
    List<DropDowns>? actionsValueList,
    final progress,
  }) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: List.generate(
        actionsValueList!.length,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: utf8convert(actionsValueList[index].text.toString()),
              color: CommonColor.blue),
          onPressed: (context) async {
            await connectivityChecker.checkInterNet();
            Navigator.pop(context);

            if (connectivityChecker.isConnected) {
              progress!.show();
              var response;

              try {
                response = await UpdateStatusRepo.updateStatus(
                    context: context,
                    id: actionsValueList[index].id!,
                    contId: GetStorageServices.getUserId());
              } catch (e) {}

              /// Open Auto Book Screen:
              try {
                if (response['data']['select_auto_book'] == true) {
                  showModalBottomSheet(
                      enableDrag: false,
                      isDismissible: false,
                      context: bottomSheetContext,
                      useSafeArea: true,
                      builder: (context) => AutoBookOnScreen(),
                      isScrollControlled: true);
                }
              } catch (e) {
                // TODO
              }

              /// Action(Call/SMS):
              try {
                if (response['data']['action'] != null) {
                  if (response['data']['action']['type'] == 'call') {
                    await FlutterPhoneDirectCaller.callNumber(
                        response['data']['action']['num'].toString());
                  } else if (response['data']['action']['type'] == 'sms') {
                    _sendSMS(response['data']['action']['message'],
                        [response['data']['action']['num']]);
                  }
                }
              } catch (e) {
                // TODO
              }

              refreshTeamList();

              await getUserDetailViewModel.getUserDetailDataWithoutModel(
                  isLoading: false);

              progress.dismiss();
            } else {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(noConnectionSnackBar);
            }
          },
        ),
      ),
      cancelAction: CancelAction(
        title: CommonText.textBoldWeight700(text: AppStrings.cancel),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  /// Change Action Sheet:
  Future<dynamic> buildChangeActionSheet(
    BuildContext bottomSheetContext, {
    List<UserActions>? actionsValueList,
  }) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: List.generate(
        actionsValueList!.length,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: utf8convert(actionsValueList[index].text1.toString()),
              color: CommonColor.blue),
          onPressed: (context) async {
            await connectivityChecker.checkInterNet();
            Navigator.pop(context);
            if (connectivityChecker.isConnected) {
              try {
                var response = await ChangeActionRepo.changeAction(
                    id: actionsValueList[index].id1!);

                /// Action(Call/SMS):
                try {
                  if (response['data']['action'] != null) {
                    if (response['data']['action']['type'] == 'call') {
                      await FlutterPhoneDirectCaller.callNumber(
                              response['data']['action']['num'].toString())
                          .then((value) => refreshTeamList());
                    } else if (response['data']['action']['type'] == 'sms') {
                      _sendSMS(response['data']['action']['message'],
                          [response['data']['action']['num']]);
                    }
                  }
                } catch (e) {
                  // TODO
                }

                /// Show Alert Team Screen:
                try {
                  if (actionsValueList[index].id1 == 'ALERT') {
                    showModalBottomSheet(
                        enableDrag: false,
                        isDismissible: false,
                        context: bottomSheetContext,
                        useSafeArea: true,
                        builder: (context) => AlertTeamScreen(),
                        isScrollControlled: true);
                  }
                } catch (e) {
                  // TODO
                }

                refreshTeamList();
              } catch (e) {
                // TODO
              }
            } else {
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(noConnectionSnackBar);
            }
          },
        ),
      ),
      cancelAction: CancelAction(
        title: CommonText.textBoldWeight700(text: AppStrings.cancel),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }
}

/// Banner Ad:
class BannerAdmob extends StatefulWidget {
  final bool adShowStatus;

  const BannerAdmob({super.key, this.adShowStatus = false});
  @override
  State<StatefulWidget> createState() {
    return _BannerAdmobState();
  }
}

class _BannerAdmobState extends State<BannerAdmob> {
  BannerAd? _bannerAd;
  bool _bannerReady = false;

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _bannerReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          setState(() {
            _bannerReady = false;
          });
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerReady && widget.adShowStatus == true
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.sp,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: _bannerAd?.size.width.toDouble(),
                  height: _bannerAd?.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            ],
          )
        : SizedBox();
  }
}

/// Drawer:
class DrawerWidget extends StatefulWidget {
  final bool isSettings;
  final bool isMain;
  final bool isSubscription;
  final bool isFollowingCrew;
  final bool isLowCrewNotification;
  final bool isResourceFinder;
  final bool isGeoFencingScreen;
  final bool isLogScreen;
  final bool isMyProfileScreen;

  DrawerWidget({
    super.key,
    this.isSettings = false,
    this.isMain = false,
    this.isSubscription = false,
    this.isFollowingCrew = false,
    this.isLowCrewNotification = false,
    this.isResourceFinder = false,
    this.isLogScreen = false,
    this.isMyProfileScreen = false,
    this.isGeoFencingScreen = false,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final NavigationService _navigationService = NavigationService();

  GetUserDetailViewModel getUserDetailViewModel =
      Get.put(GetUserDetailViewModel());

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  CustomerInfo? customerInfo;

  void checkConnection() async {
    connectivityChecker.checkInterNet().then((value) async {
      if (Platform.isIOS) {
        customerInfo = await Purchases.getCustomerInfo();
      }
      setState(() {});
      if (connectivityChecker.isConnected) {
        if (getUserDetailViewModel.isRefreshed) {
          getUserDetailViewModel.getUserDetailDataWithoutModel();
          getUserDetailViewModel.updateRefreshValue(false);
        } else {
          getUserDetailViewModel.getUserDetailDataWithoutModel(
              isLoading: false);
        }
      }
    });
  }

  @override
  void initState() {
    checkConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: GetBuilder<GetUserDetailViewModel>(
              builder: (controller) {
                if (controller.getUserDetailResponseWithoutModel.status ==
                    Status.LOADING) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                }
                if (controller.getUserDetailResponseWithoutModel.status ==
                    Status.COMPLETE) {
                  final userDetails = getUserDetailViewModel
                      .getUserDetailResponseWithoutModel.data;

                  final userInfo = userDetails['data'];

                  return userInfo != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              height: 80.sp,
                              imageUrl: AppImages.appImagePrefix +
                                  userInfo['image_id']!,
                              errorWidget: (context, url, error) =>
                                  const SizedBox(),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CommonText.textBoldWeight500(
                                text: userInfo['display_name'] != null
                                    ? userInfo['display_name'].toString()
                                    : "No name found",
                                color: Colors.white),
                            const SizedBox(
                              height: 5,
                            ),
                            CommonText.textBoldWeight500(
                                text: userInfo['role'] ?? "No role found",
                                color: Colors.white),
                          ],
                        )
                      : const SizedBox();
                }
                return const SizedBox();
              },
            ),
          ),
          ListTile(
            onTap: () {
              if (widget.isMain) {
                _navigationService.pop();
              } else {
                _navigationService.navigateTo(AppRoutes.mainScreen,
                    clearStack: true);
              }
            },
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              if (widget.isMyProfileScreen) {
                _navigationService.pop();
              } else {
                Get.offAll(
                  () => MyProfileScreen(
                    needDrawer: true,
                  ),
                );
              }
            },
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              if (widget.isFollowingCrew) {
                _navigationService.pop();
              } else {
                _navigationService.navigateTo(AppRoutes.followingCrewScreen,
                    clearStack: true);
              }
            },
            leading: const Icon(Icons.follow_the_signs),
            title: const Text('Following Crew'),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              if (widget.isLowCrewNotification) {
                _navigationService.pop();
              } else {
                _navigationService.navigateTo(
                    AppRoutes.lowCrewNotificationScreen,
                    clearStack: true);
              }
            },
            leading: const Icon(Icons.notification_add),
            title: const Text('Low Crew Notifications'),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              if (widget.isResourceFinder) {
                _navigationService.pop();
              } else {
                _navigationService.navigateTo(AppRoutes.resourceFinderScreen,
                    clearStack: true);
              }
            },
            leading: const Icon(Icons.map),
            title: const Text(AppStrings.resourceFinder),
            trailing: const Icon(Icons.chevron_right),
          ),
          Platform.isIOS && customerInfo!.entitlements.active.isNotEmpty
              ? const SizedBox()
              : ListTile(
                  onTap: () {
                    if (widget.isSubscription) {
                      _navigationService.pop();
                    } else {
                      _navigationService.navigateTo(
                          AppRoutes.subscriptionScreen,
                          arguments: {'isFromDrawer': true},
                          clearStack: true);
                    }
                  },
                  leading: const Icon(Icons.subscriptions_rounded),
                  title: const Text(AppStrings.subscription),
                  trailing: const Icon(Icons.chevron_right),
                ),
          ListTile(
            onTap: () {
              if (widget.isGeoFencingScreen) {
                _navigationService.pop();
              } else {
                _navigationService.navigateTo(AppRoutes.geoFencingScreen,
                    clearStack: true, arguments: {'isNeedToRecreate': false});
              }
            },
            leading: const Icon(Icons.graphic_eq_outlined),
            title: const Text('Geofencing'),
            trailing: const Icon(Icons.chevron_right),
          ),
          /*ListTile(
            onTap: () {
              if (widget.isLogScreen) {
                _navigationService.pop();
              } else {
                _navigationService.navigateTo(AppRoutes.logScreen,
                    clearStack: true);
              }
            },
            leading: const Icon(Icons.notifications_none),
            title: const Text('Logs'),
            trailing: const Icon(Icons.chevron_right),
          ),*/
          ListTile(
            onTap: () {
              if (widget.isSettings) {
                _navigationService.pop();
              } else {
                _navigationService.navigateTo(AppRoutes.settingsScreen,
                    clearStack: true);
              }
            },
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
