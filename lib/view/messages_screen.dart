import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import '../viewModel/message_view_model.dart';

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  MessageViewModel messageViewModel = Get.put(MessageViewModel());

  final DefaultChatTheme _defaultChatTheme = DefaultChatTheme(
    messageInsetsHorizontal: 10,
    messageInsetsVertical: 10,
    receivedMessageBodyBoldTextStyle: const TextStyle(),
    sentMessageBodyBoldTextStyle: const TextStyle(),
    sendButtonIcon: const Icon(
      Icons.send,
      color: Colors.black,
    ),
    inputTextColor: Colors.black,
    sendingIcon: const Icon(
      Icons.send,
      color: Colors.black,
    ),
    inputContainerDecoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 3, spreadRadius: 1)
        ]),
  );

  @override
  void initState() {
    super.initState();
    messageViewModel.loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageViewModel>(
      builder: (controller) => Chat(
        messages: controller.messagesList,
        onPreviewDataFetched: controller.handlePreviewDataFetched,
        onSendPressed: controller.handleSendPressed,
        showUserAvatars: true,
        showUserNames: true,
        user: controller.user,
        theme: _defaultChatTheme,
      ),
    );
  }
}
