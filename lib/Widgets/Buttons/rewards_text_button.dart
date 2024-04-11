import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';

class RewardsTextButton extends ConsumerWidget {
  final double? fontSize;
  const RewardsTextButton({this.fontSize, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle =
        ref.watch(webNavigationButtonTextStyleProvider(fontSize ?? 18));
    return TextButton(
      child: Text('rewards', style: buttonStyle),
      onPressed: () {
        ScanHelpers.cancelQrTimer(ref);
        NavigationHelpers.navigateToPointsInformationPage(context, ref);
        ref.invalidate(isInHamburgerMenuProvider);
      },
    );
  }
}
