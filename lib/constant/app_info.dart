import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static PackageInfo? packageInfo;
  static Future getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  static String appName = packageInfo!.appName;
  static String packageName = packageInfo!.packageName;
  static String version = packageInfo!.version;
  static String buildNumber = packageInfo!.buildNumber;
}
