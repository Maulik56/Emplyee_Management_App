import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:news_app/constant/routes_const.dart';

import 'package:news_app/repo/get_startup_data_repo.dart';
import 'package:news_app/repo/login_repo.dart';
import 'package:news_app/services/in_app_purchase_service/constant.dart';
import 'package:news_app/services/in_app_purchase_service/store_config.dart';
import 'package:news_app/services/navigation_service/navigation_service.dart';
import 'constant/color_const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// To avoid landscape:
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appleStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    StoreConfig(
      store: Store.googlePlay,
      apiKey: googleApiKey,
    );

    // Run the app passing --dart-define=AMAZON=true
    // const useAmazon = bool.fromEnvironment("amazon");
    // StoreConfig(
    //   store: useAmazon ? Store.amazonAppstore : Store.googlePlay,
    //   apiKey: useAmazon ? amazonApiKey : googleApiKey,
    // );
  }

  try {
    /// To initialize local storage:
    await GetStorage.init();

    /// To initialize Google Ads:
    MobileAds.instance.initialize();
  } catch (e) {}

  bool? status;
  bool? isError;

  /// To initialize Firebase:
  try {
    await Firebase.initializeApp();

    /// Startup API will call when app is opened every time:
    await GetStartupDataRepo.getStartupData();

    status = await LoginRepo.login();

    isError = false;
  } catch (e) {
    isError = true;
  }

  runApp(MyApp(
    status: status ?? false,
    isError: isError,
  ));
}

class MyApp extends StatelessWidget {
  final bool status;
  final bool isError;

  const MyApp({super.key, this.status = false, required this.isError});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) => GestureDetector(
        onTap: () {
          /// To hide keyboard for welcome screen:
          var currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: GetMaterialApp(
          title: 'OnCall',
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSwatch().copyWith(primary: CommonColor.blue),
          ),
          navigatorKey: NavigationService.navigatorKey,
          initialRoute: isError == true
              ? AppRoutes.noIntentScreen
              : status == true
                  ? AppRoutes.mainScreen
                  : AppRoutes.registerScreen,
          onGenerateRoute: (settings) =>
              OnGenerateRoutes.generateRoute(settings),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
