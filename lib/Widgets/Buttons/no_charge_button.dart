import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Services/payment_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

class NoChargePaymentButton extends ConsumerWidget {
  final UserModel user;
  const NoChargePaymentButton({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LargeElevatedButton(
      buttonText: 'No Charge - Finish Checkout',
      onPressed: () {
        HapticFeedback.lightImpact();
        var message = OrderHelpers.validateOrder(context, ref);
        if (message != null) {
          OrderHelpers.showInvalidOrderModal(context, message);
        } else {
          ref.read(loadingProvider.notifier).state = true;
          final totals = PaymentsHelpers.generateOrderPricingDetails(ref, user);
          final orderDetails =
              PaymentsHelpers().generateOrderDetails(ref, user, totals);
          PaymentServices.createOrderCloudFunction(
            orderDetails: orderDetails,
            onPaymentSuccess: () {
              HapticFeedback.lightImpact();
              invalidateLoadingProviders(ref);
              PaymentsHelpers.showPaymentSuccessModal(context);
            },
            onError: (error) {
              invalidateLoadingProviders(ref);
              PaymentsHelpers.showPaymentErrorModal(context, ref, error);
            },
          );
        }
      },
    );
  }
}
