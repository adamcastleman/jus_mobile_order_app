import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConstants {
  static double tileWidth = WidgetsBinding
          .instance.platformDispatcher.views.first.physicalSize.width *
      0.3;

  static String comingSoon = 'Coming Soon';

  static String nonMemberType = 'CUSTOMER';

  static String memberType = 'MEMBER';

  static double mobileWidth = 900;

  static double screenHeight = WidgetsBinding
      .instance.platformDispatcher.views.first.physicalSize.height;

  static double screenWidth =
      WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width;

  static double aspectRatioMobile = 9 / 16;
  static double aspectRatioWeb = 16 / 9;

  static LatLng centerOfUS = const LatLng(39.833333, -98.585522);

  static double oneHundredMilesInMeters = 160934;

  static int homePageWeb = 0;

  static int menuPageWeb = 1;

  static int cleansePageWeb = 2;

  static int membershipPageWeb = 3;

  static int locationPageWeb = 4;

  static int basketPage = 5;
}
