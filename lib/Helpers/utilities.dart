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

  // Checks if the current platform is iOS
  static bool isMacOS() {
    return Platform.isMacOS;
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget web;
  const ResponsiveLayout({required this.mobile, required this.web, super.key});

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.mobileWidth;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < AppConstants.mobileWidth) {
        return mobile;
      } else {
        return web;
      }
    });
  }
}
