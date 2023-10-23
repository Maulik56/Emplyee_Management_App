import 'dart:async';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:get/get.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/components/description_widget.dart';
import 'package:news_app/constant/api_const.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/repo/get_geofence_repo.dart';
import 'package:news_app/services/navigation_service/navigation_service.dart';
import 'package:news_app/view/main_screen.dart';
import 'package:news_app/view/station_location_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/banner_widget.dart';
import '../components/common_text.dart';
import '../constant/color_const.dart';
import '../models/response_model/geofence_response_model.dart';
import '../repo/update_geofence_event.dart';
import '../services/api_service/api_response.dart';
import '../viewModel/get_banner_view_model.dart';
import '../viewModel/get_geofence_view_model.dart';
import '../viewModel/notification_log_view_model.dart';

class GeoFencingScreen extends StatefulWidget {
  const GeoFencingScreen({Key? key}) : super(key: key);

  @override
  State<GeoFencingScreen> createState() => _GeoFencingScreenState();
}

class _GeoFencingScreenState extends State<GeoFencingScreen>
    with WidgetsBindingObserver {
  final NavigationService _navigationService = NavigationService();

  GetGeoFenceViewModel geoFenceViewModel = Get.put(GetGeoFenceViewModel());

  GetBannerViewModel getBannerViewModel = Get.put(GetBannerViewModel());

  NotificationLogViewModel notificationLogViewModel =
      Get.put(NotificationLogViewModel());

  final _activityStreamController = StreamController<Activity>();
  final _geofenceStreamController = StreamController<Geofence>();

  Future requestLocationPermission() async {
    try {
      await Permission.location.request();
      var status = await Permission.locationWhenInUse.status;
      if (!status.isGranted) {
        await Permission.locationAlways.request();
      }
    } catch (e) {
      // TODO
    }
    checkPermission();
  }

  // Create a [GeofenceService] instance and set options.
  final _geofenceService2 = GeofenceService.instance.setup(
      interval: 5000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 10000,
      useActivityRecognition: false,
      allowMockLocations: false,
      printDevLog: false,
      geofenceRadiusSortType: GeofenceRadiusSortType.DESC);

  // This function is to be called when the geofence status is changed.
  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {
    try {
      debugPrint('geofence: ${geofence.toJson()}');
      debugPrint('geofenceRadius: ${geofenceRadius.toJson()}');
      debugPrint('geofenceStatus: ${geofenceStatus.toString()}');
    } catch (e) {
      // TODO
    }

    _geofenceStreamController.sink.add(geofence);
    UpdateGeoFenceEventRepo.updateGeoFenceEvent(
        geofenceID: geofence.id, eventType: geofence.status.name);

    try {
      notificationLogViewModel.updateLogs2(
          'geofence: ${geofence.id.toString()} ${geofence.status.name.toString()}');
    } catch (e) {
      // TODO
    }
  }

  // This function is to be called when the activity has changed.
  void _onActivityChanged(Activity prevActivity, Activity currActivity) {
    debugPrint('prevActivity: ${prevActivity.toJson()}');
    debugPrint('currActivity: ${currActivity.toJson()}');
    _activityStreamController.sink.add(currActivity);
  }

  // This function is to be called when the location has changed.
  void _onLocationChanged(Location location) {
    debugPrint('location: ${location.toJson()}');
  }

  // This function is to be called when a location services status change occurs
  // since the service was started.
  void _onLocationServicesStatusChanged(bool status) {
    debugPrint('isLocationServicesEnabled: $status');
  }

  void checkPermission() async {
    bool status = await Permission.locationAlways.isGranted;
    isAlwaysLocationPermissionGranted = status;
    debugPrint(
        "ALWAYS LOCATION PERMISSION==>$isAlwaysLocationPermissionGranted");
    setState(() {});
  }

  // This function is used to handle errors that occur in the service.
  void _onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      debugPrint('Undefined error: $error');
      return;
    }

    debugPrint('ErrorCode: $errorCode');
  }

  bool isAlwaysLocationPermissionGranted = false;

  recreateGeofence(bool restart) async {
    try {
      notificationLogViewModel.updateLogs2('Stopping geofence service...');
      await _geofenceService2.stop();
      notificationLogViewModel.updateLogs2('Stopped.');
      notificationLogViewModel.updateLogs2('Clearing geofence listeners...');
      _geofenceService2.clearAllListeners();
      notificationLogViewModel.updateLogs2('Cleared.');
      notificationLogViewModel.updateLogs2('Deleting geofences...');
      _geofenceService2.clearGeofenceList();
      notificationLogViewModel.updateLogs2('Deleted.');
    } catch (e) {
      // TODO
    }

    if (restart) {
      await geoFenceViewModel.getGeoFenceData();
      GeofenceResponseModel geofenceResponseModel =
          await geoFenceViewModel.getGeoFenceResponse.data;

      final geofenceList = <Geofence>[];
      for (var element in geofenceResponseModel.data!.geofences!) {
        notificationLogViewModel.updateLogs2(
            'Adding geofence: ${element.id.toString()} ${element.radius.toString()}');
        geofenceList.add(Geofence(
          id: element.id!,
          latitude: double.parse(geofenceResponseModel.data!.lat.toString()),
          longitude: double.parse(geofenceResponseModel.data!.lon.toString()),
          radius: [
            GeofenceRadius(
                id: 'radius_${element.radius.toString()}',
                length: double.parse(element.radius.toString())),
          ],
        ));
        notificationLogViewModel.updateLogs2('Added.');
      }

      try {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notificationLogViewModel.updateLogs2('Starting geofence service...');
          _geofenceService2.start(geofenceList).catchError(_onError);
          notificationLogViewModel.updateLogs2('Started.');
        });

        var response = await GetGeoFenceDataRepo.postGeoFence(
            justEnabled: true, enabled: true);

        if (response['success'] == true) {
        } else {
          CommonWidget.getSnackBar(context,
              color: CommonColor.red, duration: 2, message: response['error']);
        }
        geoFenceViewModel.getGeoFenceData(isLoading: false);
      } catch (e) {
        if (kDebugMode) {
          print("GEOFENCE ENABLE ERROR=>>$e");
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkPermission();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _geofenceService2
          .addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
      _geofenceService2.addLocationChangeListener(_onLocationChanged);
      _geofenceService2.addLocationServicesStatusChangeListener(
          _onLocationServicesStatusChanged);
      _geofenceService2.addActivityChangeListener(_onActivityChanged);
      _geofenceService2.addStreamErrorListener(_onError);
    });
    getBannerViewModel.getBannerInfo(screenId: Banners.geofence);
    geoFenceViewModel.getGeoFenceData();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        checkPermission();

        break;

      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    if (args['isNeedToCreate'] == true) {
      recreateGeofence(_geofenceService2.isRunningService);
    }
    return ProgressHUD(child: Builder(
      builder: (context) {
        final progress = ProgressHUD.of(context);
        return Scaffold(
          backgroundColor: const Color(0xfff2f2f4),
          appBar: CommonWidget.commonAppBar(
              title: GeoFenceStrings.geoFenceMonitoring),
          drawer: DrawerWidget(isGeoFencingScreen: true),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Banner:
              BannerWidget(),

              /// Description:
              const DescriptionWidget(
                  description: GeoFenceStrings.enableGeoFences),

              /// Geofence enable/disable option:
              GetBuilder<GetGeoFenceViewModel>(
                builder: (controller) {
                  if (controller.getGeoFenceResponse.status == Status.LOADING) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.getGeoFenceResponse.status ==
                      Status.COMPLETE) {
                    GeofenceResponseModel geofenceResponseModel =
                        controller.getGeoFenceResponse.data;
                    return Expanded(
                      child: Container(
                        color: Colors.white,
                        child: ListView(
                          children: [
                            ListTile(
                              minVerticalPadding: 0,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 13.sp),
                              title: const Text(
                                "Active",
                                style: TextStyle(fontSize: 15),
                              ),
                              trailing: Switch.adaptive(
                                value:
                                    geofenceResponseModel.data!.enabled != null
                                        ? geofenceResponseModel.data!.enabled!
                                        : false,
                                onChanged: (value) async {
                                  progress!.show();
                                  if (!isAlwaysLocationPermissionGranted) {
                                    await requestLocationPermission();
                                  }
                                  await GetGeoFenceDataRepo.postGeoFence(
                                      justEnabled: true, enabled: value);
                                  geoFenceViewModel.getGeoFenceData(
                                      isLoading: false);

                                  recreateGeofence(value);

                                  progress.dismiss();
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 13.sp),
                              child: const Divider(
                                height: 0,
                                thickness: 1,
                              ),
                            ),
                            !isAlwaysLocationPermissionGranted
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        minVerticalPadding: 0,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 13.sp),
                                        title: const Text(
                                          """Location needs to be set to "Always" """,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                    color: CommonColor
                                                        .greyBorderColor,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  try {
                                                    await openAppSettings();
                                                  } catch (e) {
                                                    // TODO
                                                  }
                                                  checkPermission();
                                                },
                                                child: Center(
                                                  child: CommonText
                                                      .textBoldWeight400(
                                                    color: CommonColor.blue,
                                                    fontSize: 12,
                                                    text: "Change",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13.sp),
                                        child: const Divider(
                                          height: 0,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StationLocationScreen(
                                      lat: geofenceResponseModel.data!.lat !=
                                              null
                                          ? double.parse(geofenceResponseModel
                                              .data!.lat
                                              .toString())
                                          : 0.0,
                                      long: geofenceResponseModel.data!.lon !=
                                              null
                                          ? double.parse(geofenceResponseModel
                                              .data!.lon
                                              .toString())
                                          : 0.0,
                                    ),
                                  ),
                                );
                              },
                              minVerticalPadding: 0,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 13.sp),
                              title: const Text(
                                "Team Station Location",
                                style: TextStyle(fontSize: 15),
                              ),
                              subtitle: const Text(
                                "The point from which the geofences are measured",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.orange),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                            Container(
                              color: const Color(0xfff2f2f4),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 15.sp,
                                    bottom: 15.sp,
                                    left: 10.sp,
                                    right: 10.sp),
                                child: CommonText.textBoldWeight400(
                                    text:
                                        "You will be automatically set to Delayed if you exit the inner fence",
                                    color: CommonColor.greyColor838589,
                                    fontSize: 13.sp),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                buildChangeFenceSheet(context,
                                    onlyPostInner: true,
                                    onlyPostOuter: false,
                                    progress: progress);
                              },
                              minVerticalPadding: 0,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 13.sp),
                              title: const Text(
                                "Inner Fence",
                                style: TextStyle(fontSize: 15),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  innerFence(geofenceResponseModel),
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                            Container(
                              color: const Color(0xfff2f2f4),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 15.sp,
                                    bottom: 15.sp,
                                    left: 10.sp,
                                    right: 10.sp),
                                child: CommonText.textBoldWeight400(
                                    text:
                                        "You will be automatically set to Delayed if you exit the inner fence",
                                    color: CommonColor.greyColor838589,
                                    fontSize: 13.sp),
                              ),
                            ),
                            ListTile(
                              onTap: () {
                                buildChangeFenceSheet(context,
                                    onlyPostOuter: true,
                                    onlyPostInner: false,
                                    progress: progress);
                              },
                              minVerticalPadding: 0,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 13.sp),
                              title: const Text(
                                "Outer Fence",
                                style: TextStyle(fontSize: 15),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  outerFence(geofenceResponseModel),
                                  SizedBox(
                                    width: 10.sp,
                                  ),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Text outerFence(GeofenceResponseModel geofenceResponseModel) {
    try {
      return Text(
        geofenceResponseModel.data!.geofences!.last.radiusText!,
        style: const TextStyle(color: Colors.blue),
      );
    } catch (e) {
      return const Text(
        "0",
        style: TextStyle(color: Colors.blue),
      );
    }
  }

  Widget innerFence(GeofenceResponseModel geofenceResponseModel) {
    try {
      return Text(
        geofenceResponseModel.data!.geofences!.first.radiusText!,
        style: const TextStyle(color: Colors.blue),
      );
    } catch (e) {
      return const Text(
        "0",
        style: TextStyle(color: Colors.blue),
      );
    }
  }

  /// Change fence action sheet:
  Future<dynamic> buildChangeFenceSheet(BuildContext context,
      {bool onlyPostInner = false, bool onlyPostOuter = false, var progress}) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      actions: List.generate(
        30,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: "${index + 1} km", color: CommonColor.blue),
          onPressed: (context) async {
            Navigator.pop(context);

            progress!.show();

            var response = await GetGeoFenceDataRepo.postGeoFence(
              onlyPostInner: onlyPostInner,
              onlyPostOuter: onlyPostOuter,
              innerFence: "${index + 1} km",
              outerFence: "${index + 1} km",
            );

            recreateGeofence(_geofenceService2.isRunningService);

            if (response['success'] == true) {
              await geoFenceViewModel.getGeoFenceData();
              progress.dismiss();
            } else {
              progress.dismiss();
              CommonWidget.getSnackBar(context,
                  color: CommonColor.red,
                  duration: 1,
                  message: "Something went wrong");
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
