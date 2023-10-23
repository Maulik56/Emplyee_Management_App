import 'dart:developer';
import 'package:news_app/constant/api_const.dart';
import '../models/response_model/geofence_response_model.dart';
import '../services/api_service/base_services.dart';

class GetGeoFenceDataRepo {
  static Future<GeofenceResponseModel> getGeoFenceData() async {
    var response = await APIService().getResponse(
        url: EndPoints.geofence,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    GeofenceResponseModel geofenceResponseModel =
        GeofenceResponseModel.fromJson(response);
    return geofenceResponseModel;
  }

  static Future postGeoFence(
      {double? lat,
      double? lon,
      String? innerFence,
      String? outerFence,
      bool onlyPostInner = false,
      bool onlyPostOuter = false,
      bool postLatLong = false,
      bool justEnabled = false,
      bool enabled = false}) async {
    var reqBody;

    if (onlyPostInner == true) {
      reqBody = {
        "inner_fence": innerFence,
      };
    }

    if (onlyPostOuter == true) {
      reqBody = {
        "outer_fence": outerFence,
      };
    }

    if (postLatLong == true) {
      reqBody = {
        "lat": lat,
        "lon": lon,
      };
    }
    if (justEnabled == true) {
      reqBody = {
        "enabled": enabled,
      };
    }

    log("GEOFENCE REQ BODY==>$reqBody");

    var response = await APIService().getResponse(
        url: EndPoints.geofence,
        apitype: APIType.aPost,
        body: reqBody,
        header: CommonHeader.header);

    return response;
  }
}
