import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

class AddPaymentMethodButton extends ConsumerWidget {
  final UserModel user;
  const AddPaymentMethodButton({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LargeElevatedButton(
        buttonText: 'Add Payment Method',
        onPressed: () {
          HapticFeedback.lightImpact();
          SquarePaymentServices().inputSquareCreditCard(ref, user);
        });
  }
}
