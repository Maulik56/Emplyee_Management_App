import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationLogViewModel extends GetxController {
  List notificationLogs = [];

  void updateLogs2(String value) {
    final dateTime = DateTime.now();

    String yourDateTime = DateFormat('dd-MM-yyyy hh:mm:ss')
        .format(dateTime)
        .toString()
        .split(" ")[1];

    notificationLogs.add('$yourDateTime $value');
    update();
  }

  void clearLogs() {
    notificationLogs.clear();
    update();
  }
}
