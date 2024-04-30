import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/wallet.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Sheets/select_wallet_load_amount_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

class WalletLoadAmountSelectorTile extends ConsumerWidget {
  final UserModel user;
  final WalletType walletType;
  final int loadAmount;
  const WalletLoadAmountSelectorTile(
      {required this.user,
      required this.walletType,
      required this.loadAmount,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: ListTile(
        dense: true,
        title: const Text('Amount'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _displayLoadAmount(),
            _displayInsufficientFundsWarning(ref),
          ],
        ),
        trailing: const ChevronRightIcon(),
        onTap: () => NavigationHelpers.navigateToPartScreenSheetOrDialog(
          context,
          const SelectWalletLoadAmountSheet(),
        ),
      ),
    );
  }

  Widget _displayLoadAmount() {
    return Text(
      '\$$loadAmount.00',
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _displayInsufficientFundsWarning(WidgetRef ref) {
    final selectedPaymentMethod = ref.watch(selectedPaymentMethodProvider);
    if (walletType != WalletType.loadAndPay) {
      return const SizedBox();
    }

    if (walletType == WalletType.loadAndPay &&
        WalletHelpers.isWalletBalanceSufficientToCoverTransaction(
            ref,
            selectedPaymentMethod.isWallet == true
                ? selectedPaymentMethod.balance!
                : 0,
            user)) {
      return const SizedBox();
    }
    return const Text(
      'Does not cover order total',
      style: TextStyle(
        color: Colors.red,
      ),
    );
  }
}
