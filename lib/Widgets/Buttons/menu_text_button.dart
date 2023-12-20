import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
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
        ref.read(webNavigationProvider.notifier).state = 1;
        ref.read(webNavigationPageControllerProvider).jumpToPage(1);
        ResponsiveLayout.isMobile(context) ? Navigator.pop(context) : null;
      },
    );
  }
}
