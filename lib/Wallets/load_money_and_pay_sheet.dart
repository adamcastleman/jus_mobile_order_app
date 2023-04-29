import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/wallet.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Wallets/select_wallet_load_amount_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

class LoadWalletAndPaySheet extends ConsumerWidget {
  const LoadWalletAndPaySheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserProviderWidget(
      builder: (user) => WalletProviderWidget(
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
                  _buildInitialBalance(context, ref, user),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 12.0,
                    ),
                    child: CategoryWidget(text: 'Payment Source'),
                  ),
                  WalletHelpers(ref: ref)
                      .determineDefaultPayment(context, creditCards),
                  WalletHelpers(ref: ref)
                      .determineAddPaymentTile(context, user),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 22.0,
                    ),
                    child: CategoryWidget(text: 'Order Total'),
                  ),
                  WalletHelpers(ref: ref).displayOrderTotal(user),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: _determinePaymentButton(context, ref, user),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInitialBalance(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) {
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
        if (_isBalanceInsufficient(ref, walletAmount, user))
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

  int loadAndPayWalletAmount(WidgetRef ref, UserModel user, int walletAmount) {
    final difference = _orderAmountDifference(ref, user, walletAmount);
    final loadAmounts = ref.watch(loadAmountsProvider);
    // Find the appropriate load amount
    int selectedLoadAmount = findMatchingLoadAmount(loadAmounts, difference);
    WalletHelpers(ref: ref)
        .updateSelectedLoadAmount(loadAmounts, selectedLoadAmount);
    return selectedLoadAmount;
  }

  int findMatchingLoadAmount(List<int> loadAmounts, double difference) {
    if (difference <= loadAmounts.first) {
      return loadAmounts.first;
    }

    final matchingLoadAmounts =
        loadAmounts.where((element) => element >= difference);
    if (matchingLoadAmounts.isNotEmpty) {
      return matchingLoadAmounts.first;
    }

    return loadAmounts.last;
  }

  double _orderAmountDifference(
      WidgetRef ref, UserModel user, int walletAmount) {
    final totalOrderPrice = Pricing(ref: ref).orderTotalFromUserType(user);
    return totalOrderPrice - walletAmount;
  }

  void _updateSelectedLoadAmountIndex(
      WidgetRef ref, UserModel user, int walletAmount) {
    final loadAmounts = ref.watch(loadAmountsProvider);
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    final loadAndPayAmount = loadAndPayWalletAmount(ref, user, walletAmount);

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

  bool _isBalanceInsufficient(WidgetRef ref, int walletAmount, UserModel user) {
    final totalOrderPrice = Pricing(ref: ref).orderTotalFromUserType(user);
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);

    num balance = walletAmount;
    if (selectedLoadAmount == null) {
      // If there is no selected load amount, add the calculated load and pay amount
      balance += loadAndPayWalletAmount(ref, user, walletAmount);
    } else {
      // If there is a selected load amount, add it to the wallet balance
      balance += selectedLoadAmount;
    }

    // If the balance is less than the total order price, return true to indicate insufficient balance
    return balance < totalOrderPrice;
  }

  Widget _determinePaymentButton(
      BuildContext context, WidgetRef ref, UserModel user) {
    final applePayLoading = ref.watch(applePayLoadingProvider);
    final loading = ref.watch(loadingProvider);
    if (applePayLoading || loading) {
      return const LargeElevatedLoadingButton();
    } else {
      return WalletProviderWidget(
        builder: (wallets) => LargeElevatedButton(
          buttonText: getPaymentButtonText(ref, user, wallets.first),
          onPressed: () => _handlePayment(
              context: context, ref: ref, user: user, wallet: wallets.first),
        ),
      );
    }
  }

  String getPaymentButtonText(
      WidgetRef ref, UserModel user, PaymentsModel wallet) {
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    final walletAmount = WalletHelpers(ref: ref).walletAmount(wallet);
    final amount =
        selectedLoadAmount ?? loadAndPayWalletAmount(ref, user, walletAmount);
    final formattedAmount = (amount / 100).toStringAsFixed(2);

    return 'Add \$$formattedAmount to Wallet and pay';
  }

  void _handlePayment({
    required BuildContext context,
    required WidgetRef ref,
    required UserModel user,
    required PaymentsModel wallet,
  }) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final applePaySelected = ref.watch(applePaySelectedProvider);
    final paymentsServices = PaymentsServices(ref: ref);
    final message = OrderHelpers(ref: ref).validateOrder(context);
    final walletAmount = WalletHelpers(ref: ref).walletAmount(wallet);

    HapticFeedback.lightImpact();

    if (_isBalanceInsufficient(ref, walletAmount, user)) {
      ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => const InvalidSheetSinglePop(
          error: 'You cannot cover the order total with this amount.',
        ),
      );
      return;
    }

    if (message != null) {
      Navigator.pop(context);
      OrderHelpers(ref: ref).showInvalidOrderModal(context, message);
      ref.read(loadingProvider.notifier).state = false;
      return;
    }

    if (selectedPayment.isEmpty) {
      WalletHelpers(ref: ref).displayInvalidPaymentError(context);
      return;
    }
    if (applePaySelected) {
      ref.read(applePayLoadingProvider.notifier).state = true;
      paymentsServices.initApplePayWalletLoad(context: context, user: user);
    } else {
      ref.read(loadingProvider.notifier).state = true;
      paymentsServices.addFundsToWalletAndPay(
        context,
        user,
        wallet,
      );
    }
  }
}
