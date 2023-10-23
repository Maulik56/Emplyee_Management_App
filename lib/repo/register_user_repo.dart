import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/api_const.dart';
import 'package:news_app/get_storage_services/get_storage_service.dart';

class RegisterUserRepo {
  static Future registerUser(
    BuildContext context, {
    required String email,
    required String uuid,
    dynamic progress,
  }) async {
    var reqBody = json.encode({"email": email, "uuid": uuid});
    var header = {"uuid": uuid};

    try {
      http.Response response = await http
          .post(Uri.parse(BaseUrl.baseUrl + EndPoints.register),
              body: reqBody, headers: header)
          .timeout(
            const Duration(seconds: 5),
          );
      var result = jsonDecode(response.body);
      try {
        GetStorageServices.setCode(result['data']['code']);
      } catch (e) {
        // TODO
      }
      return result;
    } on Exception catch (e) {
      progress!.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(noConnectionSnackBar);
    }
  }
}
