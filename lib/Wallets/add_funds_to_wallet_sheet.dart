import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/wallet.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Wallets/select_wallet_load_amount_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

class AddFundsToWalletSheet extends ConsumerWidget {
  const AddFundsToWalletSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    return WalletProviderWidget(
      builder: (wallets) => CreditCardProviderWidget(
        builder: (creditCards) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Wrap(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: SheetNotch(),
                ),
                WalletHelpers(ref: ref).buildHeader(context),
                WalletHelpers(ref: ref).buildWalletCategory(),
                WalletHelpers(ref: ref).buildSelectWalletTile(),
                WalletHelpers(ref: ref).buildAmountCategory(),
                _buildInitialBalance(context, ref),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 12.0,
                  ),
                  child: CategoryWidget(text: 'Payment Source'),
                ),
                WalletHelpers(ref: ref)
                    .determineDefaultPayment(context, creditCards),
                WalletHelpers(ref: ref).determineAddPaymentTile(context, user),
                JusDivider().thin(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: _paymentButton(context, ref, user),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildInitialBalance(BuildContext context, WidgetRef ref) {
    final loadAmounts = ref.watch(loadAmountsProvider);
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    return ListTile(
      dense: true,
      title: const Text('Amount'),
      subtitle: Text(
        '\$${selectedLoadAmount == null ? loadAmounts[3] ~/ 100 : selectedLoadAmount ~/ 100}.00',
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: const ChevronRightIcon(),
      onTap: () {
        ref.read(selectedLoadAmountIndexProvider.notifier).state =
            selectedLoadAmount == null
                ? 3
                : loadAmounts
                    .indexWhere((element) => element == selectedLoadAmount);
        ModalBottomSheet().partScreen(
          enableDrag: true,
          isScrollControlled: true,
          isDismissible: true,
          context: context,
          builder: (context) => const SelectWalletLoadAmountSheet(),
        );
      },
    );
  }

  _paymentButton(BuildContext context, WidgetRef ref, UserModel user) {
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    final selectedWallet = ref.watch(currentlySelectedWalletProvider);
    final loadAmounts = ref.watch(loadAmountsProvider);
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
      PaymentsServices(ref: ref)
          .initApplePayWalletLoad(context: context, user: user, wallet: wallet);
    } else {
      ref.read(loadingProvider.notifier).state = true;
      PaymentsServices(ref: ref).addFundsToWallet(context, user, wallet);
    }
  }
}
