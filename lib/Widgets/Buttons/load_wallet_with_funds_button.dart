import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/wallet.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';

class LoadWalletWithFundsButton extends ConsumerWidget {
  final UserModel user;
  const LoadWalletWithFundsButton({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    final selectedWallet = ref.watch(currentlySelectedWalletProvider);
    final loadAmounts = ref.watch(walletLoadAmountsProvider);
    final formattedAmount = (selectedLoadAmount == null
            ? (loadAmounts[3] / 100)
            : selectedLoadAmount / 100)
        .toStringAsFixed(2);
    final applePayLoading = ref.watch(applePayLoadingProvider);
    final loading = ref.watch(loadingProvider);
    if (applePayLoading || applePayLoading || loading) {
      return const LargeElevatedLoadingButton();
    } else {
      return WalletProviderWidget(builder: (wallets) {
        return LargeElevatedButton(
          buttonText:
              'Add \$$formattedAmount to Wallet x${selectedWallet.isEmpty ? wallets.first.gan.toString().substring(wallets.first.gan.toString().length - 4) : ''}',
          onPressed: () => _handlePayment(
              context: context, ref: ref, user: user, wallet: wallets.first),
        );
      });
    }
  }

  void _handlePayment({
    required BuildContext context,
    required WidgetRef ref,
    required UserModel user,
    required PaymentsModel wallet,
  }) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final applePaySelected = ref.watch(applePaySelectedProvider);

    if (selectedPayment.isEmpty) {
      WalletHelpers(ref: ref).displayInvalidPaymentError(context);
      return;
    }

    if (applePaySelected) {
      ref.read(applePayLoadingProvider.notifier).state = true;
      SquarePaymentServices().initApplePayWalletLoad(
          context: context, ref: ref, user: user, wallet: wallet);
    } else {
      ref.read(loadingProvider.notifier).state = true;
      SquarePaymentServices().addFundsToWallet(context, ref, user, wallet,
          onError: (error) {
        ModalBottomSheet().partScreen(
          context: context,
          builder: (context) => const InvalidSheetSinglePop(
              error: 'Something went wrong. Please try again later'),
        );
      });
    }
  }
}
