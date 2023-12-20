import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/add_payment_method_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/no_charge_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/open_load_money_and_pay_sheet_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/pay_with_apple_pay_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/process_payment_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';

class TipSheet extends ConsumerWidget {
  const TipSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final backgroundColor = ref.watch(backgroundColorProvider);
    List<int> percentAmounts = [0, 10, 15, 20];

    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: backgroundColor,
          ),
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 40.0, left: 12.0, right: 12.0),
          child: Column(
            children: [
              Text(
                'Would you like to leave a tip?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      4, (index) => tipContainer(ref, percentAmounts, index)),
                ),
              ),
              const TotalPrice(),
              Spacing.vertical(40),
              _paymentButtons(context, ref, user),
            ],
          ),
        ),
      ],
    );
  }

  Widget tipContainer(WidgetRef ref, List<int> percentAmounts, int index) {
    final selectedTip = ref.watch(selectedTipIndexProvider);
    final backgroundColor = ref.watch(backgroundColorProvider);
    final selectedCardColor = ref.watch(selectedCardColorProvider);
    final selectedCardBorderColor = ref.watch(selectedCardBorderColorProvider);

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(selectedTipIndexProvider.notifier).state = index;
        ref.read(selectedTipPercentageProvider.notifier).state =
            percentAmounts[index];
      },
      child: Container(
        height: 85,
        width: 85,
        color: backgroundColor,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color:
                  selectedTip == index ? selectedCardBorderColor : Colors.white,
              width: 0.5,
            ),
          ),
          color: selectedTip == index ? selectedCardColor : Colors.white,
          elevation: 2,
          child: Center(
            child: Text(
              percentAmounts[index] == 0 ? 'None' : '${percentAmounts[index]}%',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _paymentButtons(BuildContext context, WidgetRef ref, UserModel user) {
    final totals = PaymentsHelper(ref: ref).calculatePricingAndTotals(user);
    final orderMap = PaymentsHelper(ref: ref).generateOrderMap(user, totals);
    if (Pricing(ref: ref).isZeroCharge()) {
      return NoChargePaymentButton(orderMap: orderMap);
    } else {
      return Column(
        children: [
          _determineCreditCardButton(context, ref, user, orderMap),
          Spacing.vertical(10),
          if (Platform.isIOS) ...[
            PayWithApplePayButton(
              user: user,
              orderMap: orderMap,
            ),
            Spacing.vertical(10),
          ],
        ],
      );
    }
  }

  _determineCreditCardButton(BuildContext context, WidgetRef ref,
      UserModel user, Map<String, dynamic> orderMap) {
    final applePaySelected = ref.watch(applePaySelectedProvider);
    final selectedPaymentMethod = ref.watch(selectedPaymentMethodProvider);
    if (applePaySelected && (Platform.isIOS || Platform.isMacOS)) {
      return const SizedBox();
    }
    if (selectedPaymentMethod.isEmpty) {
      return AddPaymentMethodButton(user: user);
    } else {
      final selectedPayment = ref.watch(selectedPaymentMethodProvider);
      final totalPrice = user.uid == null || !user.isActiveMember!
          ? Pricing(ref: ref).orderTotalForNonMembers() * 100
          : Pricing(ref: ref).orderTotalForMembers() * 100;

      return selectedPayment['balance'] != null &&
              totalPrice > selectedPayment['balance']
          ? const OpenLoadMoneyAndPaySheetButton()
          : ProcessCreditCardPaymentButton(
              orderMap: orderMap,
              onSuccess: () {
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
  }
}
