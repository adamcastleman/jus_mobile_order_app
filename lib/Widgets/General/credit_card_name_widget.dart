import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

import '../../Providers/payments_providers.dart';

class CreditCardName extends ConsumerWidget {
  final bool isPayButton;
  final bool isScanPage;

  const CreditCardName(
      {required this.isScanPage, required this.isPayButton, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextStyle tileStyle = const TextStyle(fontWeight: FontWeight.bold);

    String cardNickname;
    String brand;
    String lastFourDigits;

    final selectedCard = ref.watch(selectedCreditCardProvider);
    final currentUser = ref.watch(currentUserProvider);
    final defaultCards = ref.watch(defaultPaymentCardProvider);
    final guestCard = ref.watch(guestCreditCardNonceProvider);

    return currentUser.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (user) => defaultCards.when(
        error: (e, _) => ShowError(error: e.toString()),
        loading: () => const Loading(),
        data: (defaultCard) {
          if (!isScanPage &&
              (user.uid == null ||
                  (!user.isActiveMember! &&
                      Pricing(ref: ref).orderTotalForNonMembers() <= 0.00) ||
                  (user.isActiveMember! &&
                      Pricing(ref: ref).orderTotalForMembers() <= 0.00))) {
            return AutoSizeText(
              'No Charge - Finish Checkout',
              style: isPayButton ? null : tileStyle,
              maxLines: isPayButton ? 1 : 2,
            );
          }
          if (selectedCard.isEmpty &&
              defaultCard.isEmpty &&
              guestCard.isEmpty) {
            return AutoSizeText(
              'Add Card',
              style: isPayButton ? null : tileStyle,
              maxLines: isPayButton ? 1 : 2,
            );
          }
          if (user.uid == null && guestCard.isNotEmpty) {
            brand = guestCard['brand'];
            lastFourDigits = guestCard['lastFourDigits'];
            return AutoSizeText(
              'Pay using ${determineBrand(brand)} ending in $lastFourDigits',
              style: tileStyle,
              maxLines: isPayButton ? 1 : 2,
            );
          }

          if (selectedCard.isEmpty) {
            cardNickname =
                defaultCard.isEmpty ? '' : defaultCard[0].cardNickname;
            brand = defaultCard.isEmpty ? '' : defaultCard[0].brand;
            lastFourDigits =
                defaultCard.isEmpty ? '' : defaultCard[0].lastFourDigits;
          } else {
            cardNickname = selectedCard['cardNickname'];
            brand = selectedCard['brand'];
            lastFourDigits = selectedCard['lastFourDigits'];
          }
          if (isPayButton) {
            return AutoSizeText(
              'Pay using ${determineBrand(brand)} ending in $lastFourDigits',
              maxLines: isPayButton ? 1 : 2,
            );
          } else {
            return AutoSizeText(
              '${determineCardNickname(cardNickname)}${determineBrand(brand)} ending in $lastFourDigits',
              style: tileStyle,
              maxLines: isPayButton ? 1 : 2,
            );
          }
        },
      ),
    );
  }

  determineBrand(String brand) {
    if (brand.isEmpty) {
      return '';
    }
    if (brand.contains('GiftCard')) {
      return 'jüs card';
    } else {
      return '${brand[0].toUpperCase()}${brand.substring(1)}';
    }
  }

  determineCardNickname(String cardNickname) {
    if (cardNickname.isEmpty || cardNickname.contains('jüs card')) {
      return '';
    } else {
      return '$cardNickname - ';
    }
  }
}
