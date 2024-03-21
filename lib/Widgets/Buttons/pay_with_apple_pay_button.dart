import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payment_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/large_apple_pay_button.dart';

class PayWithApplePayButton extends ConsumerWidget {
  final UserModel user;
  const PayWithApplePayButton({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isApplePayCompleted = ref.watch(isApplePayCompletedProvider);
    if (isApplePayCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PaymentsHelpers.showPaymentSuccessModal(context);
        ref.read(isApplePayCompletedProvider.notifier).state = false;
      });
      // Reset the state
    }
    return LargeApplePayButton(
      onPressed: () async {
        HapticFeedback.lightImpact();
        ref.read(applePaySelectedProvider.notifier).state = true;
        ref.read(applePayLoadingProvider.notifier).state = true;
        final errorMessage = OrderHelpers.validateOrder(context, ref);
        if (errorMessage != null) {
          OrderHelpers.showInvalidOrderModal(context, errorMessage);
        } else {
          final totals = PaymentsHelpers.generateOrderPricingDetails(ref, user);
          PaymentServices().generateSecureCardDetailsFromApplePay(
            ref: ref,
            amount: '${totals['totalInCents']}',
            onSuccess: (cardDetails) {
              PaymentsHelpers
                  .setCreditCardAsSelectedPaymentMethodWithSquareCardDetails(
                      ref, user, cardDetails);
              final orderDetails =
                  PaymentsHelpers().generateOrderDetails(ref, user, totals);
              PaymentServices.createOrderCloudFunction(
                  orderDetails: orderDetails,
                  onPaymentSuccess: () {
                    PaymentsHelpers.showPaymentSuccessModal(context);
                  },
                  onError: (error) {
                    PaymentsHelpers.showPaymentErrorModal(context, ref, error);
                  });
            },
            onError: (error) {
              PaymentsHelpers.showPaymentErrorModal(context, ref, error);
            },
          );
        }
      },
    );
  }
}
