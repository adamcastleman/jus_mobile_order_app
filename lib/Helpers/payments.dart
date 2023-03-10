import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Sheets/choose_saved_card_sheet.dart';

import '../Sheets/choose_payment_type_sheet.dart';

class PaymentsHelpers {
  final WidgetRef ref;

  PaymentsHelpers({required this.ref});

  void determinePaymentSheet(
      {required BuildContext context, required bool isCheckoutButton}) {
    final currentUser = ref.watch(currentUserProvider);
    final paymentMethod = ref.watch(savedCreditCardsProvider);
    final guestPayment = ref.watch(guestCreditCardNonceProvider);

    currentUser.when(
      loading: () => {},
      error: (e, _) => ShowError(error: e.toString()),
      data: (user) {
        paymentMethod.when(
          loading: () => {},
          error: (e, _) => ShowError(error: e.toString()),
          data: (card) {
            final shouldOpenChoosePaymentSheet =
                user.uid == null && guestPayment.isEmpty ||
                    (user.uid != null && card.isEmpty);
            final shouldOpenChooseSavedCardSheet = user.uid == null &&
                guestPayment.isNotEmpty &&
                !isCheckoutButton;

            if (shouldOpenChoosePaymentSheet ||
                shouldOpenChooseSavedCardSheet) {
              ModalBottomSheet().partScreen(
                context: context,
                enableDrag: true,
                isDismissible: true,
                isScrollControlled: true,
                builder: (context) => const ChoosePaymentTypeSheet(),
              );
            } else if (!isCheckoutButton) {
              ModalBottomSheet().partScreen(
                  context: context,
                  enableDrag: true,
                  isDismissible: true,
                  isScrollControlled: true,
                  builder: (context) {
                    return const ChooseSavedCardSheet();
                  });
            } else {
              handlePayment(context, user);
            }
          },
        );
      },
    );
  }

  handlePayment(BuildContext context, UserModel user) {
    OrderHelpers(ref: ref).validateOrder(context, user);
    ref.invalidate(savedCreditCardsProvider);
    ref.invalidate(guestCreditCardNonceProvider);
  }

  setDefaultPaymentMethodAsSelectedCard(UserModel user) {
    final defaultCard = ref.watch(defaultPaymentCardProvider);
    if (user.uid == null) {
      return;
    } else {
      defaultCard.when(
          error: (e, _) => ShowError(error: e.toString()),
          loading: () => const Loading(),
          data: (card) {
            int index =
                card.indexWhere((element) => element.defaultPayment == true);
            ref.read(selectedCreditCardProvider.notifier).state =
                PaymentsServices().mapPaymentItems(card, index);
          });
    }
  }

  constructDefaultPayment() {
    final paymentMethod = ref.watch(savedCreditCardsProvider);
    return paymentMethod.when(
      loading: () => {},
      error: (e, _) => ShowError(error: e.toString()),
      data: (card) {
        var defaultPayment =
            card.firstWhere((element) => element.defaultPayment == true);
        var paymentMap = {
          'nonce': defaultPayment.nonce,
          'lastFourDigits': defaultPayment.lastFourDigits,
          'brand': defaultPayment.brand,
          'cardNickname': defaultPayment.cardNickname
        };
        return paymentMap;
      },
    );
  }
}
