import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_provider_widget.dart';
import 'package:jus_mobile_order_app/Sheets/delete_payment_method_confirmation_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_double_pop.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outlined_button_medium.dart';

class DeletePaymentMethodButton extends ConsumerWidget {
  final String cardID;
  final bool defaultPayment;
  const DeletePaymentMethodButton(
      {required this.cardID, required this.defaultPayment, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WalletProviderWidget(
      builder: (wallets) => CreditCardProviderWidget(
        builder: (creditCards) => MediumOutlineButton(
          buttonText: 'Delete Card',
          onPressed: () {
            _determineDeletePayment(context, wallets, creditCards);
          },
        ),
      ),
    );
  }

  _determineDeletePayment(BuildContext context, List<PaymentsModel> wallets,
      List<PaymentsModel> creditCards) {
    if (defaultPayment) {
      ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => const InvalidSheetDoublePop(
            error:
                'Before deleting, please choose a new default payment method.'),
      );
    } else if (wallets.isNotEmpty && creditCards.length == 1) {
      ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => const InvalidSheetDoublePop(
            error:
                'Since you have an active Wallet, you must have at least one payment method on file.'),
      );
    } else {
      ModalBottomSheet().partScreen(
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        context: context,
        builder: (context) =>
            DeletePaymentMethodConfirmationSheet(cardID: cardID),
      );
    }
  }
}
