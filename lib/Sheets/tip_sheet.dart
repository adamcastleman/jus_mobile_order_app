import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/General/credit_card_name_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';

import '../Providers/payments_providers.dart';

class TipSheet extends ConsumerWidget {
  const TipSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final backgroundColor = ref.watch(backgroundColorProvider);
    List<int> percentAmounts = [0, 10, 15, 20];
    return currentUser.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (user) => Wrap(
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
                LargeElevatedButton(
                  textWidget: const CreditCardName(
                    isPayButton: true,
                    isScanPage: false,
                  ),
                  onPressed: () => addPaymentOrValidate(context, ref, user),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  tipContainer(WidgetRef ref, List percentAmounts, int index) {
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
                color: selectedTip == index
                    ? selectedCardBorderColor
                    : Colors.white,
                width: 0.5),
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

  void addPaymentOrValidate(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) {
    final selectedCreditCard = ref.watch(selectedCreditCardProvider);
    if (selectedCreditCard.isEmpty) {
      PaymentsHelpers(ref: ref)
          .determinePaymentSheet(context: context, isCheckoutButton: true);
    } else {
      OrderHelpers(ref: ref).validateOrder(context, user);
    }
  }
}
