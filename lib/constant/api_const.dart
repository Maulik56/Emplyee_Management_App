import 'package:news_app/get_storage_services/get_storage_service.dart';

import '../services/in_app_purchase_service/singletons_data.dart';

class BaseUrl {
  static String baseUrl = "https://oncall.kernow-software.com/rest/oncall/";
}

class EndPoints {
  static String register = "email/register";
  static String verify = "email/verify";
  static String resendCode = "email/resend";
  static String startup = "device/startup";
  static String status = "team/status";
  static String user = "user/";
  static String leaveTeam = "user/leave";
  static String pushToken = "device/pushToken/";
  static String getInviteCode = "team/inviteCode";
  static String joinTeam = "team/join/";
  static String createTeam = "team";
  static String teamFollowing = "team/following";
  static String teamLevels = "team/minimumLevels";
  static String googleAuth = "user/auth/google";
  static String appleAuth = "user/auth/apple";
  static String followCrew = "team/follow/";
  static String unfollowCrew = "team/unfollow/";
  static String timZoneList = "country/";
  static String statistics = "statistics";
  static String markers = "map/markers/";
  static String event = "event/";
  static String countryFilter = "country/filter";
  static String subscription = "subscription";
  static String responding = "team/responding/";
  static String autoBook = "autobook";
  static String banner = "banner/";
  static String messages = "messages";
  static String geofence = "geofence";
  static String changeGeofenceStatus = "geofence/active/";
  static String updateGeofenceEvent = "geofence/event/";
  static String resourceCategory = "map/resource/category";
  static String addResource = "map/resource";
  static String alertList = "alert/list";
  static String sendAlert = "alert/send/";
  static String sectorList = "team/sector";
  static String sendMessage = "messages/new";
  static String avatarList = "image/avatar/list";
  static String roleList = "role/list";
  static String qualificationList = "qualification/list";
  static String login = "device/login";
  static String mapPhoto = "map/resource/photo/";
  static String geoFenceCentre = "geofence/centre";
  static String subscriptionEvent = "subscription/event";
  static String privacy = "general/document/privacy";
  static String terms = "general/document/terms";
  static String signOut = "user/signout";
  static String generalEmail = "general/email";
  static String team = "team";
  static String teamSummary = "team/summary";
  static String teamPrevSummary = "team/summary/date/prev";
  static String teamNextSummary = "team/summary/date/next";
  static const String teamCurrentDateSummary = "team/summary/date/";
}

class CommonHeader {
  static var header = {"uuid": "${GetStorageServices.getUuid()}"};
}

class Banners {
  static String followingCrew = "following_crew";
  static String lowCrewNotifications = "low_crew_notifications";
  static String weeklyStats = "weekly_stats";
  static String mainScreen = "main_screen";
  static String teamAlerts = "team_alerts";
  static String autoBook = "auto_book";
  static String geofence = "geofence";
}
