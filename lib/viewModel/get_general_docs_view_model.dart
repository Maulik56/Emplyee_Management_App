import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:news_app/repo/get_general_doc_repo.dart';
import '../services/api_service/api_response.dart';

class GetGeneralDocsViewModel extends GetxController {
  ApiResponse _getGeneralDocs = ApiResponse.initial(message: 'Initialization');

  ApiResponse get getGeneralDocs => _getGeneralDocs;

  Future<void> getGeneralDocsInfo(
      {bool isLoading = true, String? docType}) async {
    if (isLoading) {
      _getGeneralDocs = ApiResponse.loading(message: 'Loading');
    }

    try {
      var data =
          await GetGeneralDocumentRepo.getGeneralDocument(docType: docType);
      if (kDebugMode) {
        print("Get General Docs API Response==>$data");
      }
      _getGeneralDocs = ApiResponse.complete(data);
    } catch (e) {
      if (kDebugMode) {
        print("Get General Docs API Error==>$e==");
      }
      _getGeneralDocs = ApiResponse.error(message: 'error');
    }
    update();
  }
}
