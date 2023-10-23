import 'package:flutter/material.dart';
import 'package:news_app/view/contact_us_screen.dart';
import 'package:news_app/view/follwing_crew_screen.dart';
import 'package:news_app/view/geofencing_screen.dart';
import 'package:news_app/view/log_screen.dart';
import 'package:news_app/view/low_crew_notifications_screen.dart';
import 'package:news_app/view/no_internet_screen.dart';
import 'package:news_app/view/resource_finder_screen.dart';
import 'package:news_app/view/weekly_statistics.dart';

import '../view/all_set_screen.dart';
import '../view/auto_book_on_screen.dart';
import '../view/create_team_screen.dart';
import '../view/delete_account_screen.dart';
import '../view/enable_notification_screen.dart';
import '../view/event_detail_screen.dart';
import '../view/invite_team_screen.dart';
import '../view/join_team_screen.dart';
import '../view/leave_team_screen.dart';
import '../view/main_screen.dart';
import '../view/my_profile_screen.dart';
import '../view/photo_view_screen.dart';
import '../view/profile_edit_screen.dart';
import '../view/select_qualification_screen.dart';
import '../view/select_role_screen.dart';
import '../view/select_user_image_screen.dart';
import '../view/settings_screen.dart';
import '../view/show_privacy_terms_screen.dart';
import '../view/sign_in_screen.dart';
import '../view/station_detail_screen.dart';
import '../view/station_location_screen.dart';
import '../view/subscription_screen.dart';
import '../view/team_options_screen.dart';
import '../view/user_profile_screen.dart';
import '../view/verification_screen.dart';

class AppRoutes {
  static String mainScreen = "/";
  static String registerScreen = "/registerScreen";
  static String verificationScreen = "/verificationScreen";
  static String settingsScreen = "/settingsScreen";
  static String leaveTeamScreen = "/leaveTeamScreen";
  static String deleteAccountScreen = "/deleteAccountScreen";
  static String profileEditScreen = "/profileEditScreen";
  static String subscriptionScreen = "/subscriptionScreen";
  static String inviteTeamScreen = "/inviteTeamScreen";
  static String teamOptionsScreen = "/teamOptionsScreen";
  static String createTeamScreen = "/createTeamScreen";
  static String joinTeamScreen = "/joinTeamScreen";
  static String followingCrewScreen = "/followingCrewScreen";
  static String lowCrewNotificationScreen = "/lowCrewNotificationScreen";
  static String weeklyStatisticsScreen = "/weeklyStatisticsScreen";
  static String resourceFinderScreen = "/resourceFinderScreen";
  static String noIntentScreen = "/noIntentScreen";
  static String logScreen = "/logScreen";
  static String demoScreen = "/demoScreen";
  static String myProfileScreen = "/myProfileScreen";
  static String autoBookOnScreen = "/autoBookOnScreen";
  static String geoFencingScreen = "/geoFencingScreen";
  static String userProfileScreen = "/userProfileScreen";
  static String selectUserImageScreen = "/selectUserImageScreen";
  static String selectRoleScreen = "/selectRoleScreen";
  static String selectQualificationScreen = "/selectQualificationScreen";
  static String eventDetailScreen = "/eventDetailScreen";
  static String allSetScreen = "/allSetScreen";
  static String photoViewScreen = "/photoViewScreen";
  static String stationLocationScreen = "/stationLocationScreen";
  static String enableNotificationScreen = "/enableNotificationScreen";
  static String showPrivacyTermsScreen = "/showPrivacyTermsScreen";
  static String contactUsScreen = "/contactUsScreen";
  static String stationDetailScreen = "/stationDetailScreen";
}

class OnGenerateRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (_) => const BottomNavigationScreen(), settings: settings);
      case "/registerScreen":
        return MaterialPageRoute(
            builder: (_) => const LoginScreen(), settings: settings);

      case "/verificationScreen":
        return MaterialPageRoute(
            builder: (_) => const VerificationScreen(), settings: settings);
      case "/settingsScreen":
        return MaterialPageRoute(
            builder: (_) => const SettingsScreen(), settings: settings);
      case "/leaveTeamScreen":
        return MaterialPageRoute(
            builder: (_) => const LeaveTeamScreen(), settings: settings);
      case "/deleteAccountScreen":
        return MaterialPageRoute(
            builder: (_) => const DeleteAccountScreen(), settings: settings);
      case "/profileEditScreen":
        return MaterialPageRoute(
            builder: (_) => const ProfileEditScreen(), settings: settings);
      case "/subscriptionScreen":
        return MaterialPageRoute(
            builder: (_) => const SubscriptionScreen(), settings: settings);
      case "/inviteTeamScreen":
        return MaterialPageRoute(
            builder: (_) => const InviteTeamScreen(), settings: settings);
      case "/teamOptionsScreen":
        return MaterialPageRoute(
            builder: (_) => const TeamOptionsScreen(), settings: settings);
      case "/createTeamScreen":
        return MaterialPageRoute(
            builder: (_) => const CreateTeamScreen(), settings: settings);
      case "/joinTeamScreen":
        return MaterialPageRoute(
            builder: (_) => const JoinTeamScreen(), settings: settings);
      case "/followingCrewScreen":
        return MaterialPageRoute(
            builder: (_) => const FollowingCrewScreen(), settings: settings);
      case "/lowCrewNotificationScreen":
        return MaterialPageRoute(
            builder: (_) => const LowCrewNotificationScreen(),
            settings: settings);
      case "/weeklyStatisticsScreen":
        return MaterialPageRoute(
            builder: (_) => const WeeklyStatisticsScreen(), settings: settings);
      case "/resourceFinderScreen":
        return MaterialPageRoute(
            builder: (_) => const ResourceFinderScreen(), settings: settings);
      case "/noIntentScreen":
        return MaterialPageRoute(
            builder: (_) => NoInternetScreen(), settings: settings);
      case "/logScreen":
        return MaterialPageRoute(
            builder: (_) => LogScreen(), settings: settings);
      case "/myProfileScreen":
        return MaterialPageRoute(
            builder: (_) => MyProfileScreen(), settings: settings);
      case "/autoBookOnScreen":
        return MaterialPageRoute(
            builder: (_) => AutoBookOnScreen(), settings: settings);
      case "/geoFencingScreen":
        return MaterialPageRoute(
            builder: (_) => GeoFencingScreen(), settings: settings);
      case "/userProfileScreen":
        return MaterialPageRoute(
            builder: (_) => UserProfileScreen(), settings: settings);
      case "/selectUserImageScreen":
        return MaterialPageRoute(
            builder: (_) => SelectUserImageScreen(), settings: settings);
      case "/selectRoleScreen":
        return MaterialPageRoute(
            builder: (_) => SelectRoleScreen(), settings: settings);
      case "/selectQualificationScreen":
        return MaterialPageRoute(
            builder: (_) => SelectQualificationScreen(), settings: settings);
      case "/eventDetailScreen":
        return MaterialPageRoute(
            builder: (_) => EventDetailScreen(), settings: settings);
      case "/allSetScreen":
        return MaterialPageRoute(
            builder: (_) => AllSetScreen(), settings: settings);
      case "/photoViewScreen":
        return MaterialPageRoute(
            builder: (_) => PhotoViewScreen(), settings: settings);
      case "/stationLocationScreen":
        return MaterialPageRoute(
            builder: (_) => StationLocationScreen(), settings: settings);
      case "/enableNotificationScreen":
        return MaterialPageRoute(
            builder: (_) => EnableNotificationScreen(), settings: settings);
      case "/showPrivacyTermsScreen":
        return MaterialPageRoute(
            builder: (_) => ShowPrivacyTermsScreen(), settings: settings);
      case "/contactUsScreen":
        return MaterialPageRoute(
            builder: (_) => ContactUsScreen(), settings: settings);
      case "/stationDetailScreen":
        return MaterialPageRoute(
            builder: (_) => StationDetailScreen(), settings: settings);
    }
    return null;
  }
}
