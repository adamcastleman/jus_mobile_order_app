import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';

class MenuTextButton extends ConsumerWidget {
  final double? fontSize;
  const MenuTextButton({this.fontSize, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle =
        ref.watch(webNavigationButtonTextStyleProvider(fontSize ?? 18));
    return TextButton(
      child: Text('menu', style: buttonStyle),
      onPressed: () {
        ScanHelpers.cancelQrTimer(ref);
        NavigationHelpers().navigateToMenuPage(context, ref);
        ref.invalidate(isInHamburgerMenuProvider);
      },
    );
  }
}
