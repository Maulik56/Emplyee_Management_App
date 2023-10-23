import 'package:get/get.dart';

class LoaderViewModel extends GetxController {
  bool isLoading = false;

  void changeLoadingStatus(bool value) {
    isLoading = value;
    update();
  }
}
