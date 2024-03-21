import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';

class ScanFloatingActionButton extends ConsumerWidget {
  final double? fontSize;
  final VoidCallback onPressed;
  const ScanFloatingActionButton(
      {this.fontSize, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkGreen = ref.watch(darkGreenProvider);
    return FloatingActionButton.extended(
      backgroundColor: darkGreen,
      foregroundColor: Colors.black,
      hoverColor: Colors.transparent,
      onPressed: onPressed,
      label: const Text(
        'Scan in store',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
