import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/constant/api_const.dart';

class SendUserDetailRepo {
  static Future sendUserDetail(
      {required String firstName,
      required String lastName,
      required String mobile,
      required String avatar,
      required String position,
      required String crewNumber,
      required String displayName,
      required String qualification,
      String? userId,
      bool isContainsExtraField = false,
      bool isFromOnBoarding = false,
      Map<String, dynamic>? reqBodyWithExtraField}) async {
    var reqBody = json.encode({
      "id": userId,
      "first_name": firstName,
      "last_name": lastName,
      "mobile": mobile,
      "avatar": avatar,
      "position": position,
      "crew_number": crewNumber,
      "display_name": displayName,
      "qualification": qualification,
    });

    var reqBodyWithoutId = json.encode({
      "first_name": firstName,
      "last_name": lastName,
      "mobile": mobile,
      "avatar": avatar,
      "position": position,
      "crew_number": crewNumber,
      "display_name": displayName,
      "qualification": qualification,
    });

    log("BODY==>${reqBody.toString()}");
    log("EXTRA FIELD BODY==>${reqBodyWithExtraField.toString()}");

    http.Response response =
        await http.post(Uri.parse(BaseUrl.baseUrl + EndPoints.user),
            body: isContainsExtraField
                ? json.encode(reqBodyWithExtraField)
                : isFromOnBoarding
                    ? reqBodyWithoutId
                    : reqBody,
            headers: CommonHeader.header);
    var result = jsonDecode(response.body);

    if (kDebugMode) {
      print("Send User Detail API Response==>$result");
    }

    return result;
  }
}
