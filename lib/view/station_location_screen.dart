import 'dart:async';
import 'dart:math';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:news_app/components/description_widget.dart';
import 'package:news_app/repo/get_geofence_repo.dart';
import 'package:news_app/viewModel/get_geofence_view_model.dart';
import 'package:news_app/viewModel/get_resource_category_view_model.dart';
import '../components/common_text.dart';
import '../components/common_widget.dart';
import '../components/connectivity_checker.dart';
import '../constant/color_const.dart';
import '../constant/routes_const.dart';
import '../constant/strings_const.dart';
import '../services/navigation_service/navigation_service.dart';
import 'main_screen.dart';

enum MapStyle { normal, satellite }

class StationLocationScreen extends StatefulWidget {
  final double? lat;
  final double? long;
  const StationLocationScreen({Key? key, this.lat, this.long})
      : super(key: key);

  @override
  State<StationLocationScreen> createState() => _StationLocationScreenState();
}

class _StationLocationScreenState extends State<StationLocationScreen> {
  bool isLoading = true;
  late GoogleMapController _mapController;

  final Completer<GoogleMapController> _controller = Completer();

  GetGeoFenceViewModel geoFenceViewModel = Get.put(GetGeoFenceViewModel());

  final NavigationService _navigationService = NavigationService();

  LatLng? _center;

  List<Marker> _marker = [];

  CameraPosition? cameraPosition;

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getCurrentLocation() async {
    if (widget.lat != 0.0 && widget.long != 0.0) {
      _center = LatLng(widget.lat!, widget.long!);

      _marker.add(
        Marker(
          markerId: MarkerId("station${Random().nextInt(10000)}"),
          position: LatLng(widget.lat!, widget.long!),
          infoWindow: InfoWindow(
            title: "station${Random().nextInt(10000)}",
          ),
        ),
      );
    } else {
      Position position = await _getGeoLocationPosition();
      _center = LatLng(position.latitude, position.longitude);
    }

    isLoading = false;
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _controller.complete(controller);
  }

  GetResourceCategoryViewModel resourceCategoryViewModel =
      Get.put(GetResourceCategoryViewModel());

  List<String>? categoryList;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  MapType mapType = MapType.normal;

  MapStyle selectedMapStyle = MapStyle.normal;

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: Builder(
      builder: (context) {
        final progress = ProgressHUD.of(context);
        return Scaffold(
          backgroundColor: const Color(0xfff2f2f4),
          appBar: CommonWidget.commonAppBar(
            title: StationLocationStrings.stationLocation,
            leading: InkResponse(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
              ),
            ),
          ),
          body: GetBuilder<ConnectivityChecker>(
            builder: (controller) {
              return controller.isConnected
                  ? isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            const DescriptionWidget(
                                description:
                                    StationLocationStrings.tapOnTheMap),
                            Expanded(
                              child: GoogleMap(
                                rotateGesturesEnabled: false,
                                onTap: (argument) {
                                  _marker.clear();

                                  _marker.add(
                                    Marker(
                                      onTap: () {},
                                      markerId: MarkerId(
                                          "station${Random().nextInt(10000)}"),
                                      position: LatLng(argument.latitude,
                                          argument.longitude),
                                      infoWindow: InfoWindow(
                                        title:
                                            "station${Random().nextInt(10000)}",
                                      ),
                                    ),
                                  );

                                  cameraPosition = CameraPosition(
                                    target: LatLng(
                                        argument.latitude, argument.longitude),
                                  );
                                  setState(() {});

                                  buildUpdateStationLocationActionSheet(
                                      context, progress);
                                },
                                onMapCreated: _onMapCreated,
                                markers: _marker.toSet(),
                                myLocationEnabled: true,
                                onCameraMoveStarted: () {
                                  if (kDebugMode) {
                                    print("Camera Started");
                                  }
                                },
                                onCameraIdle: () async {},
                                onCameraMove: (position) {
                                  cameraPosition = position;
                                },
                                mapType: mapType,
                                initialCameraPosition: CameraPosition(
                                  target: _center!,
                                  zoom: 11.0,
                                ),
                              ),
                            ),

                            /// Cupertino Sliding Segmented Control:
                            SafeArea(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.sp, vertical: 10.sp),
                                  color: Colors.white,
                                  child: CupertinoSlidingSegmentedControl<
                                      MapStyle>(
                                    backgroundColor:
                                        CupertinoColors.systemGrey5,
                                    thumbColor: Colors.white,
                                    // This represents the currently selected segmented control.
                                    groupValue: selectedMapStyle,
                                    // Callback that sets the selected segmented control.
                                    onValueChanged: (MapStyle? value) {
                                      if (value != null) {
                                        selectedMapStyle = value;
                                        switch (value) {
                                          case MapStyle.normal:
                                            mapType = MapType.normal;
                                            break;
                                          case MapStyle.satellite:
                                            mapType = MapType.hybrid;
                                            break;
                                        }
                                      }
                                      setState(() {});
                                    },
                                    children: <MapStyle, Widget>{
                                      MapStyle.normal: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 60.sp),
                                        child: Text(
                                          "Normal",
                                          style: TextStyle(
                                              color: CupertinoColors.black,
                                              fontSize: 10.sp),
                                        ),
                                      ),
                                      MapStyle.satellite: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 60.sp),
                                        child: Text(
                                          "Satellite",
                                          style: TextStyle(
                                              color: CupertinoColors.black,
                                              fontSize: 10.sp),
                                        ),
                                      ),
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                  : NoInternetWidget(
                      onPressed: () {
                        connectivityChecker
                            .checkInterNet()
                            .then((value) => getCurrentLocation());
                      },
                    );
            },
          ),
          drawer: DrawerWidget(isResourceFinder: true),
        );
      },
    ));
  }

  /// Update station location action sheet:
  Future<dynamic> buildUpdateStationLocationActionSheet(
      BuildContext bottomSheetContext, final progress) {
    return showAdaptiveActionSheet(
      context: context,
      androidBorderRadius: 30,
      bottomSheetColor: Colors.white,

      actions: List.generate(
        1,
        (index) => BottomSheetAction(
          title: CommonText.textBoldWeight400(
              text: "Update Station Location", color: Colors.blue),
          onPressed: (context) async {
            Navigator.of(bottomSheetContext).pop();

            progress!.show();

            var response = await GetGeoFenceDataRepo.postGeoFence(
                lat: cameraPosition!.target.latitude,
                lon: cameraPosition!.target.longitude,
                postLatLong: true);

            if (response['success'] == true) {
              _navigationService.navigateTo(AppRoutes.geoFencingScreen,
                  clearStack: true, arguments: {'isNeedToRecreate': true});
              progress.dismiss();
            } else {
              progress.dismiss();
              CommonWidget.getSnackBar(context,
                  color: CommonColor.red,
                  duration: 2,
                  message: "Something went wrong!");
            }
          },
        ),
      ),
      cancelAction: CancelAction(
        onPressed: (context) {
          Navigator.of(bottomSheetContext).pop();
          try {
            cameraPosition = CameraPosition(target: _center!);
            _marker.clear();

            _marker.add(
              Marker(
                onTap: () {},
                markerId: MarkerId("station${Random().nextInt(10000)}"),
                position: _center!,
                infoWindow: InfoWindow(
                  title: "station${Random().nextInt(10000)}",
                ),
              ),
            );
          } catch (e) {
            // TODO
          }
          setState(() {});
        },
        title: CommonText.textBoldWeight700(text: AppStrings.cancel),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }
}
