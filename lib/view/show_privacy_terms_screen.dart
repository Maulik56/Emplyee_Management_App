import 'package:flutter/material.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/services/navigation_service/navigation_service.dart';
import 'package:news_app/view/main_screen.dart';
import 'package:get/get.dart';
import '../services/api_service/api_response.dart';
import '../viewModel/get_general_docs_view_model.dart';
import 'package:flutter_html/flutter_html.dart';

class ShowPrivacyTermsScreen extends StatefulWidget {
  final String? docType;

  const ShowPrivacyTermsScreen({super.key, this.docType});

  @override
  State<ShowPrivacyTermsScreen> createState() => _ShowPrivacyTermsScreenState();
}

class _ShowPrivacyTermsScreenState extends State<ShowPrivacyTermsScreen> {
  final NavigationService _navigationService = NavigationService();

  GetGeneralDocsViewModel generalDocsViewModel =
      Get.put(GetGeneralDocsViewModel());

  @override
  void initState() {
    generalDocsViewModel.getGeneralDocsInfo(docType: widget.docType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetGeneralDocsViewModel>(
      builder: (controller) {
        if (controller.getGeneralDocs.status == Status.LOADING) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (controller.getGeneralDocs.status == Status.COMPLETE) {
          var response = controller.getGeneralDocs.data;
          final docInfo = response['data'];

          return Scaffold(
            appBar: CommonWidget.commonAppBar(
              title: docInfo['title'],
              leading: InkResponse(
                onTap: () {
                  _navigationService.pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                ),
              ),
            ),
            drawer: DrawerWidget(isSubscription: true),
            body: Html(
              data: docInfo['html'],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
