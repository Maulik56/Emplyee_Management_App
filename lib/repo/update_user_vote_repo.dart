import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constant/api_const.dart';

class UpdateUserVoteRepo {
  static Future updateUserVote(
      {required String targetUserId, required bool isVoted}) async {
    http.Response response = await http.put(
        Uri.parse(
          !isVoted
              ? '${BaseUrl.baseUrl}${EndPoints.user}$targetUserId/vote/add'
              : '${BaseUrl.baseUrl}${EndPoints.user}$targetUserId/vote/remove',
        ),
        headers: CommonHeader.header);
    var result = jsonDecode(response.body);
    if (kDebugMode) {
      print("Update User Vote Response=>$result");
    }
    return result;
  }
}
