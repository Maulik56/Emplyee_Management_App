import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/common_widget.dart';
import 'package:news_app/constant/strings_const.dart';
import 'package:news_app/services/in_app_purchase_service/revenue_cat_service.dart';
import 'package:news_app/services/navigation_service/navigation_service.dart';
import 'package:news_app/view/main_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constant/color_const.dart';
import '../constant/api_const.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final NavigationService _navigationService = NavigationService();

  String webUrl = "${BaseUrl.baseUrl}subscription/html";

  CustomerInfo? customerInfo;

  getCustomerInfo() async {
    customerInfo = await Purchases.getCustomerInfo();
  }

  @override
  void initState() {
    try {
      //if (Platform.isIOS) {
      getCustomerInfo();
      //}
    } catch (e) {
      // TODO
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: args['isFromDrawer']
          ? CommonWidget.commonAppBar(title: AppStrings.subscription, actions: [
              TextButton(
                onPressed: () async {
                  RevenueCatServices.manageUser(
                      'restore', '', context, customerInfo!);
                },
                child: Text(
                  "Restore",
                  style: TextStyle(
                      fontSize: 15.sp, color: CommonColor.appBarButtonColor),
                ),
              ),
            ])
          : CommonWidget.commonAppBar(
              title: AppStrings.subscription,
              leading: InkResponse(
                onTap: () {
                  _navigationService.pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    RevenueCatServices.manageUser(
                        'restore', '', context, customerInfo!);
                  },
                  child: Text(
                    "Restore",
                    style: TextStyle(
                        fontSize: 14.sp, color: CommonColor.appBarButtonColor),
                  ),
                ),
              ],
            ),
      drawer: DrawerWidget(isSubscription: true),
      body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: Uri.encodeFull(webUrl)),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.sp),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonWidget.commonButton(
                onTap: () {
                  RevenueCatServices.showPurchaseSheet(context);
                },
                text: AppStrings.subScribe,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
