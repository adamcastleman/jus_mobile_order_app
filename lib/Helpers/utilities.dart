import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/constants.dart';

class PlatformUtils {
  // Checks if the current platform is web
  static bool isWeb() {
    return kIsWeb;
  }

  // Checks if the current platform is Android
  static bool isAndroid() {
    return !isWeb() && Platform.isAndroid;
  }

  // Checks if the current platform is iOS
  static bool isIOS() {
    return !isWeb() && Platform.isIOS;
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget? mobilePhone;
  final Widget mobileBrowser;
  final Widget? tablet;
  final Widget web;
  const ResponsiveLayout(
      {required this.mobileBrowser,
      required this.web,
      this.tablet,
      this.mobilePhone,
      super.key});

  static bool isMobilePhone(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.mobilePhoneWidth;
  }

  static bool isMobileBrowser(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.mobileBrowserWidth;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.tabletWidth &&
        MediaQuery.of(context).size.width >= AppConstants.mobileBrowserWidth;
  }

  static bool isWeb(BuildContext context) {
    return MediaQuery.of(context).size.width > AppConstants.tabletWidth;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (mobilePhone != null &&
          (constraints.maxWidth < AppConstants.mobilePhoneWidth)) {
        return mobilePhone!;
      } else if (constraints.maxWidth < AppConstants.mobileBrowserWidth) {
        return mobileBrowser;
      } else if (tablet != null &&
          (constraints.maxWidth >= AppConstants.mobileBrowserWidth &&
              constraints.maxWidth < AppConstants.tabletWidth)) {
        return tablet!;
      } else {
        return web;
      }
    });
  }
}
