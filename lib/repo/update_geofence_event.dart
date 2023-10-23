import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/get_storage_services/get_storage_service.dart';
import '../constant/api_const.dart';

class UpdateGeoFenceEventRepo {
  static Future<bool> updateGeoFenceEvent(
      {required String geofenceID, required String eventType}) async {
    var reqBody = json.encode({
      "uuid": "${GetStorageServices.getUuid()}",
      "fence_id": geofenceID,
      "action": eventType
    });

    http.Response response = await http.put(
        Uri.parse(
          '${BaseUrl.baseUrl}${EndPoints.updateGeofenceEvent}',
        ),
        headers: CommonHeader.header,
        body: reqBody);
    var result = jsonDecode(response.body);
    if (kDebugMode) {
      print("Update GeoFence Event Response===>$result");
    }
    return result['success'];
  }
}
