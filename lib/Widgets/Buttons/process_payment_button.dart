import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

class ProcessCreditCardPaymentButton extends ConsumerWidget {
  final Map<String, dynamic> orderMap;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const ProcessCreditCardPaymentButton(
      {required this.orderMap,
      required this.onSuccess,
      required this.onError,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final message = OrderHelpers(ref: ref).validateOrder(context);
    final selectedPaymentText =
        'Pay with ${PaymentsHelper().displaySelectedCardTextFromMap(selectedPayment)}';

    return LargeElevatedButton(
      buttonText: selectedPaymentText,
      onPressed: () {
        HapticFeedback.lightImpact();
        if (message != null) {
          OrderHelpers(ref: ref).showInvalidOrderModal(context, message);
          return;
        }
        ref.read(loadingProvider.notifier).state = true;
        SquarePaymentServices().processPayment(
          orderMap: orderMap,
          onPaymentSuccess: () {
            onSuccess();
          },
          onError: (error) {
            onError(error);
          },
        );
      },
    );
  }
}
