import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/wallet.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Wallets/select_wallet_load_amount_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

class CreateWalletSheet extends ConsumerWidget {
  const CreateWalletSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserProviderWidget(
      builder: (user) => CreditCardProviderWidget(
        builder: (creditCards) => Padding(
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
                padding: EdgeInsets.only(top: 18.0),
                child: CategoryWidget(text: 'Payment Source'),
              ),
              WalletHelpers(ref: ref)
                  .determineDefaultPayment(context, creditCards),
              WalletHelpers(ref: ref).determineAddPaymentTile(context, user),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: _paymentButton(context, ref, user),
              ),
            ],
          ),
        ),
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
    final loadAmounts = ref.watch(loadAmountsProvider);
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

    HapticFeedback.lightImpact();

    if (selectedPayment.isEmpty) {
      WalletHelpers(ref: ref).displayInvalidPaymentError(context);
      return;
    }

    if (applePaySelected) {
      ref.read(applePayLoadingProvider.notifier).state = true;
      PaymentsServices(ref: ref)
          .initApplePayWalletLoad(context: context, user: user);
    } else {
      ref.read(loadingProvider.notifier).state = true;
      PaymentsServices(ref: ref).createWallet(context, user);
    }
  }
}
