import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payment_method_database_services.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/large_apple_pay_button.dart';

class PayWithApplePayButton extends ConsumerWidget {
  final UserModel user;
  final Map<String, dynamic> orderMap;
  const PayWithApplePayButton(
      {required this.user, required this.orderMap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPaymentReference =
        ref.watch(selectedPaymentMethodProvider.notifier);
    final isApplePayCompleted = ref.watch(isApplePayCompletedProvider);
    if (isApplePayCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PaymentsHelper().showPaymentSuccessModal(context);
        ref.read(isApplePayCompletedProvider.notifier).state = false;
      });
      // Reset the state
    }
    return LargeApplePayButton(
      onPressed: () async {
        HapticFeedback.lightImpact();
        ref.read(applePaySelectedProvider.notifier).state = true;
        ref.read(applePayLoadingProvider.notifier).state = true;
        final errorMessage = OrderHelpers(ref: ref).validateOrder(context);
        if (errorMessage != null) {
          OrderHelpers(ref: ref).showInvalidOrderModal(context, errorMessage);
        } else {
          await SquarePaymentServices().initApplePayPayment(
              priceInDollars:
                  (orderMap['totals']['totalAmount'] / 100).toString(),
              onSuccess: (cardDetails) async {
                PaymentMethodDatabaseServices().updatePaymentMethod(
                  reference: selectedPaymentReference,
                  cardNickname: user.firstName ?? '',
                  cardId: cardDetails.nonce,
                  brand: cardDetails.card.brand.name,
                  isWallet: false,
                  last4: cardDetails.card.lastFourDigits,
                );
                //We call these again, to make sure that our orderMap is updated
                //with the correct cardId that was just generated from the nonce.
                final totals =
                    PaymentsHelper(ref: ref).calculatePricingAndTotals(user);
                final orderMap =
                    PaymentsHelper(ref: ref).generateOrderMap(user, totals);
                SquarePaymentServices().processPayment(
                  orderMap: orderMap,
                  onPaymentSuccess: () async {
                    ref.invalidate(loadingProvider);
                    ref.invalidate(applePayLoadingProvider);
                    HapticFeedback.lightImpact();
                    await SquarePaymentServices()
                        .completeApplePayAuthorization(isSuccess: true);
                    ref.read(isApplePayCompletedProvider.notifier).state = true;
                  },
                  onError: (error) {
                    ref.invalidate(loadingProvider);
                    ref.invalidate(applePayLoadingProvider);
                    PaymentsHelper().showPaymentErrorModal(context, error);
                    SquarePaymentServices()
                        .completeApplePayAuthorization(isSuccess: false);
                  },
                );
              },
              onFailure: () {
                ref.invalidate(loadingProvider);
                ref.invalidate(applePayLoadingProvider);
                SquarePaymentServices()
                    .completeApplePayAuthorization(isSuccess: false);
              },
              onComplete: () {
                ref.invalidate(loadingProvider);
                ref.invalidate(applePayLoadingProvider);
              });
        }
      },
    );
  }
}
