import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Sheets/add_funds_to_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outlined_button_medium.dart';

import '../../Helpers/payment_methods.dart';

class AddFundsButton extends ConsumerWidget {
  final PaymentsModel wallet;
  const AddFundsButton({required this.wallet, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    return CreditCardProviderWidget(
      builder: (creditCards) => MediumOutlineButton(
        buttonText: 'Add Funds',
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
          ref.read(walletTypeProvider.notifier).state = WalletType.addFunds;
          PaymentMethodHelpers()
              .setSelectedPaymentToValidPaymentMethod(ref, user, creditCards);
          NavigationHelpers.navigateToPartScreenSheetOrDialog(
            context,
            AddFundsToWalletSheet(
              user: user,
              wallet: wallet,
            ),
          );
        },
      ),
    );
  }
}
