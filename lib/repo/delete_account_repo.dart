import 'dart:convert';
import 'package:news_app/constant/api_const.dart';
import 'package:http/http.dart' as http;

class DeleteAccountRepo {
  static Future deleteAccount() async {
    http.Response response = await http.delete(
        Uri.parse(BaseUrl.baseUrl + EndPoints.user),
        headers: CommonHeader.header);
    var result = jsonDecode(response.body);
    print("DELETE==>$result");
    return result['success'];
  }
}
