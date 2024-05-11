import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/constants.dart';

class ProfileTextButton extends ConsumerWidget {
  final double? fontSize;
  const ProfileTextButton({this.fontSize, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = AppConstants.scaffoldKey;
    final buttonStyle =
        ref.watch(webNavigationButtonTextStyleProvider(fontSize ?? 18));
    return TextButton(
      child: Text('profile', style: buttonStyle),
      onPressed: () {
        ScanHelpers.cancelQrTimer(ref);
        NavigationHelpers.navigateToProfilePage(ref, scaffoldKey);
        ref.invalidate(isInHamburgerMenuProvider);
      },
    );
  }
}
