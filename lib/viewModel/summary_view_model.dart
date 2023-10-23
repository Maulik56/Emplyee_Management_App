import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SummaryViewModel extends GetxController {
  DateTime date = DateTime.now();

  Future weekRange(
      {required DateTime currentDate, bool isIncrement = false}) async {
    if (isIncrement) {
      date = currentDate.add(Duration(days: 1));
    } else {
      date = currentDate.add(Duration(days: -1));
    }
    update();
  }
}
