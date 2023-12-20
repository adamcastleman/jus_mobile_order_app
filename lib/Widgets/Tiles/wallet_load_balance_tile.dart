import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/wallet.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Sheets/select_wallet_load_amount_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

class WalletBalanceLoadTile extends ConsumerWidget {
  final UserModel user;
  const WalletBalanceLoadTile({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    return WalletProviderWidget(
      builder: (wallets) {
        final walletAmount =
            WalletHelpers(ref: ref).walletAmount(wallets.first);
        return Padding(
          padding: const EdgeInsets.only(bottom: 18.0),
          child: ListTile(
            dense: true,
            title: const Text('Amount'),
            subtitle: _walletAmountSubtitle(
              ref,
              walletAmount,
              user,
            ),
            trailing: const ChevronRightIcon(),
            onTap: () {
              if (selectedLoadAmount == null) {
                _updateSelectedLoadAmountIndex(ref, user, walletAmount);
              }
              ModalBottomSheet().partScreen(
                enableDrag: true,
                isScrollControlled: true,
                isDismissible: true,
                context: context,
                builder: (context) => const SelectWalletLoadAmountSheet(),
              );
            },
          ),
        );
      },
    );
  }

  Widget _walletAmountSubtitle(
    WidgetRef ref,
    int walletAmount,
    UserModel user,
  ) {
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _buildSubtitleText(ref, walletAmount, user, selectedLoadAmount),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (!WalletHelpers(ref: ref)
            .isWalletBalanceSufficientToCoverTransaction(
                ref, walletAmount, user))
          const Text(
            'Does not cover order total',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  String _buildSubtitleText(WidgetRef ref, int walletAmount, UserModel user,
      int? selectedLoadAmount) {
    if (selectedLoadAmount != null) {
      return '\$${selectedLoadAmount ~/ 100}.00';
    } else {
      return '\$${(walletAmount / 100).toStringAsFixed(2)}';
    }
  }

  void _updateSelectedLoadAmountIndex(
      WidgetRef ref, UserModel user, int walletAmount) {
    final loadAmounts = ref.watch(walletLoadAmountsProvider);
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    final loadAndPayAmount =
        WalletHelpers(ref: ref).loadAndPayWalletAmount(ref, user, walletAmount);

    // Find the index of the load amount that matches the calculated load and pay amount
    final loadAmountIndex = loadAmounts.indexOf(loadAndPayAmount);

    // Update the selected load amount index provider value

    if (selectedLoadAmount == null) {
      ref.read(selectedLoadAmountIndexProvider.notifier).state =
          loadAmountIndex;
    } else {
      ref.read(selectedLoadAmountIndexProvider.notifier).state =
          loadAmounts.indexOf(selectedLoadAmount);
    }
  }
}
