import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/payment_methods.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payment_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

class ProcessCreditCardPaymentButton extends ConsumerWidget {
  final UserModel user;

  const ProcessCreditCardPaymentButton({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final validationMessage = OrderHelpers.validateOrder(context, ref);
    final selectedPaymentText =
        'Pay with ${PaymentMethodHelpers().displaySelectedCardText(selectedPayment)}';

    return LargeElevatedButton(
      buttonText: selectedPaymentText,
      onPressed: () {
        HapticFeedback.lightImpact();
        if (validationMessage != null) {
          OrderHelpers.showInvalidOrderModal(context, validationMessage);
          return;
        }
        final totals = PaymentsHelpers.generateOrderPricingDetails(ref, user);
        final orderDetails =
            PaymentsHelpers().generateOrderDetails(ref, user, totals);
        ref.read(loadingProvider.notifier).state = true;
        PaymentServices.createOrderCloudFunction(
          orderDetails: orderDetails,
          onPaymentSuccess: () {
            PaymentsHelpers.onOrderSuccess(
              context,
              ref,
            );
          },
          onError: (error) {
            PaymentsHelpers.showPaymentErrorModal(context, ref, error);
          },
        );
      },
    );
  }
}
