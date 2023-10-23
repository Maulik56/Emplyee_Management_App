import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import '../services/api_service/base_services.dart';
import 'package:http/http.dart' as http;

class AddNewResourceRepo {
  static Future<bool> addNewResourceRepo(
      {required String category,
      required double lat,
      required double long,
      required File image}) async {
    List<int> imageBytes = image.readAsBytesSync();
    String base64Image = base64.encode(imageBytes);

    var reqBody = {
      "image_data": base64Image,
      "category": category,
      "location": {"lat": lat, "lon": long}
    };

    var response = await APIService().getResponse(
        url: EndPoints.addResource,
        apitype: APIType.aPost,
        header: CommonHeader.header,
        body: reqBody);
    if (kDebugMode) {
      log("Add New Resource$response");
    }
    return response['success'];
  }

  static Future deleteResource(String id) async {
    http.Response response = await http.delete(
        Uri.parse(BaseUrl.baseUrl + EndPoints.addResource + '/' + id),
        headers: CommonHeader.header);
    var result = jsonDecode(response.body);
    print("DELETE==>$result");
    return result['success'];
  }
}
