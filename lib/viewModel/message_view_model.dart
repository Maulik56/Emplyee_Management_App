import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../get_storage_services/get_storage_service.dart';
import '../repo/get_chat_list_repo.dart';
import '../repo/send_message_repo.dart';
import 'package:uuid/uuid.dart';

import '../view/main_screen.dart';

class MessageViewModel extends GetxController {
  List<types.Message> messagesList = [];

  final user = types.User(
    id: GetStorageServices.getUserId(),
  );

  void loadMessages() async {
    final response = await GetChatListRepo.getChatList();
    List responseMsgList = [];
    response['data']['messages'].forEach((element) {
      final date = DateTime.parse(element['created']);

      final id = date.millisecondsSinceEpoch;

      responseMsgList.add({
        "author": {
          "firstName": element['name'],
          "id": element['user_id'],
          "lastName": ""
        },
        "createdAt": id,
        "id": element['id'],
        "status": "seen",
        "text": utf8convert(element['data']),
        "type": element['type'],
      });
    });

    var messages = (responseMsgList)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList()
        .reversed
        .toList();

    messagesList = messages;

    update();
  }

  void addMessage(types.Message message) {
    messagesList.insert(0, message);
    update();
  }

  void handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index =
        messagesList.indexWhere((element) => element.id == message.id);
    final updatedMessage = (messagesList[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );
    messagesList[index] = updatedMessage;
    update();
  }

  void handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    addMessage(textMessage);
    await SendMessageRepo.sendMessage(message: message.text);
    loadMessages();
    update();
  }
}
