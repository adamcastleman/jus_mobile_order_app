import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/wallet.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/load_wallet_header.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/wallet_category_header.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/wallet_load_balance_tile.dart';

import '../Widgets/Tiles/default_payment_tile.dart';
import '../Widgets/Tiles/select_wallet_tile.dart';

class CreateWalletSheet extends ConsumerWidget {
  const CreateWalletSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final walletType = ref.watch(walletTypeProvider)!;
    return CreditCardProviderWidget(
      builder: (creditCards) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: SheetNotch(),
            ),
            WalletSheetHeader(
              walletType: walletType,
            ),
            const WalletCategoryHeader(),
            walletType == WalletType.createWallet
                ? const SizedBox()
                : const Padding(
                    padding: EdgeInsets.only(bottom: 18.0),
                    child: SelectWalletTile(),
                  ),
            const WalletCategoryHeader(),
            WalletBalanceLoadTile(user: user),
            const Padding(
              padding: EdgeInsets.only(top: 18.0),
              child: CategoryWidget(text: 'Payment Source'),
            ),
            DefaultPaymentTile(creditCards: creditCards),
            selectedPayment.isNotEmpty
                ? const SizedBox()
                : AddPaymentMethodTile(
                    isWallet: false,
                    isTransfer: false,
                    title: 'Add Payment Method',
                    onTap: () {
                      SquarePaymentServices().inputSquareCreditCard(ref, user);
                    },
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: _paymentButton(context, ref, user),
            ),
          ],
        ),
      ),
    );
  }

  _paymentButton(BuildContext context, WidgetRef ref, UserModel user) {
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    final loadAmounts = ref.watch(walletLoadAmountsProvider);
    final formattedAmount = (selectedLoadAmount == null
            ? (loadAmounts[3] / 100)
            : selectedLoadAmount / 100)
        .toStringAsFixed(2);
    final buttonText = 'Add \$$formattedAmount to new Wallet';
    final applePayLoading = ref.watch(applePayLoadingProvider);
    final loading = ref.watch(loadingProvider);
    if (applePayLoading || applePayLoading || loading) {
      return const LargeElevatedLoadingButton();
    } else {
      return LargeElevatedButton(
        buttonText: buttonText,
        onPressed: () => _handlePayment(context: context, ref: ref, user: user),
      );
    }
  }

  void _handlePayment({
    required BuildContext context,
    required WidgetRef ref,
    required UserModel user,
  }) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final applePaySelected = ref.watch(applePaySelectedProvider);

    if (selectedPayment.isEmpty) {
      WalletHelpers(ref: ref).displayInvalidPaymentError(context);
      return;
    }

    if (applePaySelected) {
      ref.read(applePayLoadingProvider.notifier).state = true;
      SquarePaymentServices()
          .initApplePayWalletLoad(context: context, ref: ref, user: user);
    } else {
      ref.read(loadingProvider.notifier).state = true;
      SquarePaymentServices().createWallet(context, ref, user);
    }
  }
}
