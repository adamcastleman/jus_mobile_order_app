import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Sheets/select_credit_card_for_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/apple_pay_wallet_tile.dart';

class DefaultPaymentTile extends ConsumerWidget {
  final List<PaymentsModel> creditCards;
  const DefaultPaymentTile({required this.creditCards, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCreditCard = ref.watch(selectedCreditCardProvider);
    if (ref.watch(applePaySelectedProvider)) {
      return ApplePayWalletTile(
        onTap: () => selectCreditCardSheet(context),
      );
    }

    if (creditCards.isNotEmpty) {
      return Column(
        children: [
          ListTile(
            title: Text(
              _getPaymentMethodText(selectedCreditCard),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const ChevronRightIcon(),
            onTap: () => selectCreditCardSheet(context),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  String _getPaymentMethodText(Map selectedCreditCard) {
    return selectedCreditCard.isEmpty
        ? PaymentsHelper().displaySelectedCardTextFromPaymentModel(
            creditCards.firstWhere((element) => !element.isWallet))
        : PaymentsHelper().displaySelectedCardTextFromMap(selectedCreditCard);
  }

  void selectCreditCardSheet(BuildContext context) {
    ModalBottomSheet().partScreen(
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (context) => const SelectCreditCardForWalletSheet(),
    );
  }
}
