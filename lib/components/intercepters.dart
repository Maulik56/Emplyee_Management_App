import 'package:get/get.dart';

import '../viewModel/get_header_data_view_model.dart';
import '../viewModel/get_status_data_view_model.dart';
import 'connectivity_checker.dart';

class Interceptors {
  static ConnectivityChecker connectivityChecker =
      Get.put(ConnectivityChecker());
  static GetStatusDataViewModel getStatusDataViewModel =
      Get.put(GetStatusDataViewModel());

  static GetHeaderDataViewModel getHeaderDataViewModel =
      Get.put(GetHeaderDataViewModel());

  static mainScreenInterceptor() {
    connectivityChecker.checkInterNet().then((value) {
      if (connectivityChecker.isConnected) {
        getHeaderDataViewModel.getHeaderData(isLoading: false);
        getStatusDataViewModel.getStatusData(isLoading: false);
      }
    });
  }
}
