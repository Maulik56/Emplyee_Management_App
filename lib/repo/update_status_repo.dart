import 'package:flutter/material.dart';
import 'package:news_app/constant/api_const.dart';
import '../components/common_widget.dart';
import '../services/api_service/base_services.dart';

class UpdateStatusRepo {
  static Future updateStatus(
      {required String id,
      required String contId,
      required BuildContext context}) async {
    try {
      var response = await APIService().getResponse(
          url: "${EndPoints.status}/$contId/$id",
          apitype: APIType.aPost,
          header: CommonHeader.header);
      return response;
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(noConnectionSnackBar);
    }
  }
}
