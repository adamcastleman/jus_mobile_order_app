import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConstants {
  static double tileWidth = WidgetsBinding
          .instance.platformDispatcher.views.first.physicalSize.width *
      0.3;

  static String comingSoon = 'Coming Soon';

  static String nonMemberType = 'CUSTOMER';

  static String memberType = 'MEMBER';

  static double mobilePhoneWidth = 400;

  static double mobileBrowserWidth = 600;

  static double tabletWidth = 1050;

  static double formWidthWeb = 400;

  static double screenHeight = WidgetsBinding
      .instance.platformDispatcher.views.first.physicalSize.height;

  static double screenWidth =
      WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width;

  static double aspectRatioMobilePhone = 1;

  static double aspectRatioMobileBrowser = 9 / 16;

  static double aspectRatioWeb = 22 / 9;

  static double aspectRatioRewardsWeb = 9 / 10;

  static LatLng centerOfUS = const LatLng(39.833333, -98.585522);

  static LatLng renoNV = const LatLng(39.5299, -119.814972);

  static double oneHundredMilesInMeters = 160934;

  static int homePage = 0;

  static int menuPageWeb = 1;

  static int cleansePageWeb = 2;

  static int membershipPageWeb = 3;

  static int locationPageWeb = 4;

  static int scanPageWeb = 5;

  static int pointsInformationPageWeb = 6;

  static int scanPageMobile = 1;

  static int menuPageMobile = 2;

  static int bagPageMobile = 3;

  static int profilePageMobile = 4;

  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static double paymentsSdkHeight = 250;

  static double migrationDialogHeight = 425;

  static double paymentsSdkWidth = 330;

  static double dialogHeight = 350;

  static double loginDialogHeight = 475;

  static double loginDialogHeightMobileBrowser = 600;

  static double dialogWidth = 400;

  static double buttonWidthWeb = 150;

  static double buttonHeightWeb = 50;

  static double buttonWidthPhone = 130;

  static double buttonHeightPhone = 40;

  static int defaultWalletLoadAmount = 1500;

  static int defaultWalletLoadAmountIndex = 3;

  static String membershipDisclaimerText =
      'By checking this box, you authorize jüs to automatically charge your '
      'designated payment method in the amount selected, and acknowledge that you have read and agreed the ';
  //Attach a TextButton linking users to the terms and service of membership
}
