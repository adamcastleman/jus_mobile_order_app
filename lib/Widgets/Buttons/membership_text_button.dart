import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/controller_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';

class MembershipTextButton extends ConsumerWidget {
  final double? fontSize;
  const MembershipTextButton({this.fontSize, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonStyle =
        ref.watch(webNavigationButtonTextStyleProvider(fontSize ?? 18));
    return TextButton(
      child: Text('membership', style: buttonStyle),
      onPressed: () {
        ref.read(webNavigationProvider.notifier).state = 3;
        ref.read(webNavigationPageControllerProvider).jumpToPage(3);
        ResponsiveLayout.isMobile(context) ? Navigator.pop(context) : null;
      },
    );
  }
}
