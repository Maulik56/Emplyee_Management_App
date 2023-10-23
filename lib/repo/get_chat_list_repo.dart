import 'package:news_app/constant/api_const.dart';
import '../models/response_model/get_chat_list_response_model.dart';
import '../services/api_service/base_services.dart';

class GetChatListRepo {
  static Future getChatList() async {
    var response = await APIService().getResponse(
        url: EndPoints.messages,
        apitype: APIType.aGet,
        header: CommonHeader.header);
    return response;
  }
}
