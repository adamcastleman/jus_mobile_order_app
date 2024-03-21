import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

class AddPaymentMethodButton extends ConsumerWidget {
  final VoidCallback onPressed;
  const AddPaymentMethodButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LargeElevatedButton(
      buttonText: 'Add Payment Method',
      onPressed: onPressed,
    );
  }
}
