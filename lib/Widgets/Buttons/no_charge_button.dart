import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

class NoChargePaymentButton extends ConsumerWidget {
  final Map<String, dynamic> orderMap;
  const NoChargePaymentButton({required this.orderMap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LargeElevatedButton(
      buttonText: 'No Charge - Finish Checkout',
      onPressed: () {
        HapticFeedback.lightImpact();
        var message = OrderHelpers(ref: ref).validateOrder(context);
        if (message != null) {
          OrderHelpers(ref: ref).showInvalidOrderModal(context, message);
        } else {
          ref.read(loadingProvider.notifier).state = true;
          SquarePaymentServices().processPayment(
            orderMap: orderMap,
            onPaymentSuccess: () {
              ref.invalidate(loadingProvider);
              ref.invalidate(applePayLoadingProvider);
              HapticFeedback.lightImpact();
              PaymentsHelper().showPaymentSuccessModal(context);
            },
            onError: (error) {
              ref.invalidate(loadingProvider);
              ref.invalidate(applePayLoadingProvider);
              PaymentsHelper().showPaymentErrorModal(context, error);
            },
          );
        }
      },
    );
  }
}
