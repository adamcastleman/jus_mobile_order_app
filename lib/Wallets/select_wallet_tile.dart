import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Wallets/list_of_wallets_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

class SelectWalletTile extends ConsumerWidget {
  const SelectWalletTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWallet = ref.watch(currentlySelectedWalletProvider);
    final walletType = ref.watch(walletTypeProvider);
    return WalletProviderWidget(
      builder: (wallets) => ListTile(
        title: Text(
          _buildTitleText(selectedWallet, wallets.first),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _buildSubtitleText(selectedWallet, wallets.first),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: walletType == WalletType.loadAndPay
            ? const SizedBox()
            : const ChevronRightIcon(),
        onTap: () {
          walletType == WalletType.loadAndPay
              ? null
              : ModalBottomSheet().partScreen(
                  enableDrag: true,
                  isScrollControlled: true,
                  isDismissible: true,
                  context: context,
                  builder: (context) => const ListOfWalletsSheet(),
                );
        },
      ),
    );
  }

  String _buildTitleText(Map selectedWallet, PaymentsModel wallet) {
    return '${selectedWallet.isEmpty ? wallet.cardNickname : selectedWallet['cardNickname']} - x${selectedWallet.isEmpty ? wallet.gan!.substring(wallet.gan!.length - 4) : selectedWallet['gan'].substring(wallet.gan!.length - 4)}';
  }

  String _buildSubtitleText(Map selectedWallet, PaymentsModel wallet) {
    return 'Balance: \$${(selectedWallet.isEmpty ? (wallet.balance! / 100) : (selectedWallet['balance'] / 100)).toStringAsFixed(2)}';
  }
}
