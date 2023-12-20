import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';

class CleanseTextButton extends ConsumerWidget {
  final double? fontSize;
  const CleanseTextButton({this.fontSize, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle =
        ref.watch(webNavigationButtonTextStyleProvider(fontSize ?? 18));
    return TextButton(
      child: Text('cleanse', style: buttonStyle),
      onPressed: () {
        ref.read(webNavigationProvider.notifier).state = 2;
        ref.read(webNavigationPageControllerProvider).jumpToPage(2);
        ResponsiveLayout.isMobile(context) ? Navigator.pop(context) : null;
      },
    );
  }
}
