import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';

class ScanTextButton extends StatelessWidget {
  final WidgetRef ref;
  final double? fontSize;
  const ScanTextButton({required this.ref, this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle =
        ref.watch(webNavigationButtonTextStyleProvider(fontSize ?? 18));
    return TextButton(
      child: Text('scan', style: buttonStyle),
      onPressed: () {
        NavigationHelpers.navigateToScanPage(context, ref);
      },
    );
  }
}
