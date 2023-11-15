import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Payments/total_price.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';

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
              Spacing().vertical(40),
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
    if (Pricing(ref: ref).isZeroCharge()) {
      return PaymentsHelper().noChargeButton(context, ref, user);
    } else {
      return Column(
        children: [
          _creditCardButton(context, ref, user),
          Spacing().vertical(10),
          PaymentsHelper().payWithApplePayButton(context, ref, user),
          Spacing().vertical(10),
        ],
      );
    }
  }

  _creditCardButton(BuildContext context, WidgetRef ref, UserModel user) {
    final applePaySelected = ref.watch(applePaySelectedProvider);
    final selectedPaymentMethod = ref.watch(selectedPaymentMethodProvider);
    if (applePaySelected && (Platform.isIOS || Platform.isMacOS)) {
      return const SizedBox();
    }
    if (selectedPaymentMethod.isEmpty) {
      return PaymentsHelper().addPaymentMethodButton(context, ref, user);
    } else {
      return PaymentsHelper().payWithPaymentMethodButton(context, ref, user);
    }
  }
}
