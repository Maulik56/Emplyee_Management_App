import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:news_app/models/response_model/markers_response_model.dart';
import 'package:news_app/view/photo_view_screen.dart';
import 'package:news_app/viewModel/get_resource_category_view_model.dart';
import '../components/common_text.dart';
import '../components/common_widget.dart';
import '../components/connectivity_checker.dart';
import '../constant/color_const.dart';
import '../constant/strings_const.dart';
import '../models/response_model/resource_category_response_model.dart';
import '../repo/add_new_resource_repo.dart';
import '../viewModel/get_markers_view_model.dart';
import 'main_screen.dart';
import 'dart:ui' as ui;

enum MapStyle { normal, satellite }

BitmapDescriptor? hydrantMarker;
BitmapDescriptor? defibMarker;
BitmapDescriptor? pinMarker;

BitmapDescriptor? getMarker(id) {
  print(id);
  if (id == "de8e08") return hydrantMarker;
  if (id == "09f0cb") return defibMarker;
  return pinMarker;
}

void showSnackBar(context, aText) {
  CommonWidget.getSnackBar(
    context,
    color: CommonColor.red,
    duration: 2,
    message: aText,
  );
}

class ResourceFinderScreen extends StatefulWidget {
  const ResourceFinderScreen({Key? key}) : super(key: key);

  @override
  State<ResourceFinderScreen> createState() => _ResourceFinderScreenState();
}

class _ResourceFinderScreenState extends State<ResourceFinderScreen> {
  GetMarkersViewModel getMarkersViewModel = Get.put(GetMarkersViewModel());

  bool isLoading = true;
  late GoogleMapController _mapController;

  final Completer<GoogleMapController> _controller = Completer();

  LatLng? _center;

  List<Marker> _marker = [];

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

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

  bool isRefreshed = false;

  getCurrentLocation() async {
    Position position = await _getGeoLocationPosition();
    _center = LatLng(position.latitude, position.longitude);
    refreshMarkers();
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

  getResourceCategories() async {
    await resourceCategoryViewModel.getResourceCategory();

    ResourceCategoryResponseModel resourceCategoryResponseModel =
        resourceCategoryViewModel.getResourceCategoryResponse.data;

    categoryList = resourceCategoryResponseModel.data!.category;
    setState(() {});
  }

  @override
  void initState() {
    getBytesFromAsset("assets/images/de8e08.png", 75).then((onValue) {
      hydrantMarker = BitmapDescriptor.fromBytes(onValue);
    });
    getBytesFromAsset("assets/images/09f0cb.png", 75).then((onValue) {
      defibMarker = BitmapDescriptor.fromBytes(onValue);
    });
    getBytesFromAsset("assets/images/pin.png", 75).then((onValue) {
      pinMarker = BitmapDescriptor.fromBytes(onValue);
    });

    getCurrentLocation();

    getResourceCategories();

    super.initState();
  }

  MapType mapType = MapType.normal;

  MapStyle selectedMapStyle = MapStyle.normal;

  ConnectivityChecker connectivityChecker = Get.put(ConnectivityChecker());

  refreshMarkers() async {
    try {
      final LatLngBounds bounds = await _mapController.getVisibleRegion();

      await getMarkersViewModel.getMarkersList(
          lat: cameraPosition!.target.latitude,
          long: cameraPosition!.target.longitude,
          zoom: cameraPosition!.zoom,
          region: bounds.toJson(), // "someRegion2",
          isLoading: false);

      MarkersResponseModel listOfMarkers =
          await getMarkersViewModel.getStatisticsResponse.data;

      /// Clear Markers each time when map is zoom or scrolled:
      _marker.clear();

      for (var element in listOfMarkers.data!.markers!) {
        _marker.add(
          Marker(
            onTap: () {
              showPhotoViewActionSheet(markerId: element.id!);
            },
            markerId: MarkerId(element.id!),
            position: LatLng(element.lat!, element.lon!),
            icon: getMarker(element.imgId)!,
            infoWindow: InfoWindow(
              title: element.title,
            ),
          ),
        );
      }
    } catch (e) {
      // TODO
    }
    //}

    /// Add new markers:

    setState(() {});
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
              title: "Resource Finder",
              actions: [
                IconButton(
                  onPressed: () {
                    connectivityChecker.checkInterNet().then((value) => {
                          if (connectivityChecker.isConnected)
                            {showAddResourceActionSheet(categoryList, progress)}
                          else
                            {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(noConnectionSnackBar)
                            }
                        });
                  },
                  icon: const Icon(Icons.add),
                )
              ],
            ),
            body: GetBuilder<ConnectivityChecker>(
              builder: (controller) {
                return controller.isConnected
                    ? isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              Expanded(
                                child: GoogleMap(
                                  rotateGesturesEnabled: false,
                                  onMapCreated: _onMapCreated,
                                  markers: _marker.toSet(),
                                  myLocationEnabled: true,
                                  onCameraMoveStarted: () {
                                    if (kDebugMode) {
                                      print("Camera Started");
                                    }
                                  },
                                  onCameraIdle: refreshMarkers,
                                  onCameraMove: (position) {
                                    cameraPosition = position;
                                    setState(() {});
                                  },
                                  mapType: mapType,
                                  initialCameraPosition: CameraPosition(
                                    zoom: 15.0,
                                    target: _center!,
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
                              .then((value) => refreshMarkers());
                        },
                      );
              },
            ),
            drawer: DrawerWidget(isResourceFinder: true),
          );
        },
      ),
    );
  }

  void showAddResourceActionSheet(
      List<String>? actionsValueList, var progress) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: List.generate(
          actionsValueList!.length,
          (index) => Material(
            color: Colors.white,
            child: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);

                resourceCategoryViewModel
                    .pickImageFromCamera()
                    .then((value) async {
                  if (resourceCategoryViewModel.image != null) {
                    progress!.show();
                    Position position = await _getGeoLocationPosition();

                    bool status = await AddNewResourceRepo.addNewResourceRepo(
                        category: actionsValueList[index].toString(),
                        lat: position.latitude,
                        long: position.longitude,
                        image: resourceCategoryViewModel.image!);

                    if (status) {
                      resourceCategoryViewModel.image = null;
                      refreshMarkers();
                      progress.dismiss();
                      setState(() {});
                    } else {
                      progress.dismiss();
                      showSnackBar(context, 'Failed, please try again');
                      resourceCategoryViewModel.image = null;
                      Navigator.pop(context);
                    }
                  } else {
                    progress.dismiss();
                    showSnackBar(context, 'Please take a picture!');
                  }
                });
              },
              child: Text(
                utf8convert(actionsValueList[index].toString()),
              ),
            ),
          ),
        ),
        cancelButton: CupertinoActionSheetAction(
          child: CommonText.textBoldWeight700(text: AppStrings.cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  /// See photo view action sheet:
  void showPhotoViewActionSheet({required String markerId}) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: <Widget>[
          Material(
            color: Colors.white,
            child: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoViewScreen(markerId: markerId),
                    )).then((_) => refreshMarkers());
              },
              child: const Text("View photo"),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: CommonText.textBoldWeight700(text: AppStrings.cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
