import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:news_app/constant/api_const.dart';
import 'package:http/http.dart' as http;

class DeleteEventRepo {
  static Future deleteEvent({required String eventId}) async {
    http.Response response = await http.delete(
        Uri.parse('${BaseUrl.baseUrl}${EndPoints.event}$eventId'),
        headers: CommonHeader.header);
    var result = jsonDecode(response.body);
    if (kDebugMode) {
      print("DELETE EVENT==>$result");
    }
    return result;
  }
}
