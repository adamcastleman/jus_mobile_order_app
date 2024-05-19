import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payment_services.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/large_apple_pay_button.dart';

class PayWithApplePayButton extends StatelessWidget {
  final WidgetRef ref;
  final UserModel user;
  const PayWithApplePayButton(
      {required this.ref, required this.user, super.key});

  @override
  Widget build(BuildContext context) {
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
        BuildContext context = navigatorKey.currentContext!;

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
                    ref.read(applePayLoadingProvider.notifier).state = false;
                    ref.read(loadingProvider.notifier).state = false;
                    PaymentsHelpers.showPaymentSuccessModal(context);
                    SquarePaymentServices.completeApplePayAuthorization(
                      isSuccess: true,
                    );
                  },
                  onError: (error) {
                    ref.read(applePayLoadingProvider.notifier).state = false;
                    ref.read(loadingProvider.notifier).state = false;
                    PaymentsHelpers.showPaymentErrorModal(context, ref, error);
                  });
            },
            onError: (error) {
              ref.read(loadingProvider.notifier).state = false;
              PaymentsHelpers.showPaymentErrorModal(context, ref, error);
            },
          );
        }
      },
    );
  }
}
