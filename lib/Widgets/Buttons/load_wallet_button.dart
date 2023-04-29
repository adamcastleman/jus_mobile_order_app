import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Wallets/add_funds_to_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outlined_button_medium.dart';

import '../../Helpers/payments.dart';

class LoadWalletButton extends ConsumerWidget {
  const LoadWalletButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CreditCardProviderWidget(
      builder: (creditCards) => MediumOutlineButton(
        buttonText: 'Add Funds',
        onPressed: () {
          ref.read(walletTypeProvider.notifier).state = WalletType.addFunds;
          PaymentsHelper(ref: ref)
              .setSelectedPaymentToValidPaymentMethod(creditCards);
          ModalBottomSheet().partScreen(
            enableDrag: true,
            isDismissible: true,
            isScrollControlled: true,
            context: context,
            builder: (context) => const AddFundsToWalletSheet(),
          );
        },
      ),
    );
  }
}
