import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Sheets/select_credit_card_for_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';

class WalletHelpers {
  final WidgetRef ref;

  WalletHelpers({required this.ref});

  displayOrderTotal(UserModel user) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          const TotalPrice().buildSubtotalWithDiscountRow(ref, user),
          const TotalPrice().buildTaxesRow(ref, user),
          const TotalPrice().buildTipRow(ref, user),
          const TotalPrice().buildOrderTotalRow(ref, user),
        ],
      ),
    );
  }

  void selectCreditCard(BuildContext context) {
    ModalBottomSheet().partScreen(
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (context) => const SelectCreditCardForWalletSheet(),
    );
  }

  walletAmount(PaymentsModel wallet) {
    final selectedWallet = ref.watch(currentlySelectedWalletProvider);
    if (selectedWallet.isEmpty) {
      return wallet.balance;
    } else {
      return selectedWallet['balance'];
    }
  }

  void updateSelectedLoadAmount(List<int> loadAmounts, int selectedLoadAmount) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedLoadAmountProvider.notifier).state = selectedLoadAmount;
      ref.read(selectedLoadAmountIndexProvider.notifier).state =
          loadAmounts.indexOf(selectedLoadAmount);
    });
  }

  int loadWalletAmount() {
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    return selectedLoadAmount ?? ref.watch(walletLoadAmountsProvider)[3];
  }

  void displayInvalidPaymentError(BuildContext context) {
    ModalBottomSheet().partScreen(
      context: context,
      builder: (context) => const InvalidSheetSinglePop(
        error: 'Please choose a payment method.',
      ),
    );
  }

  bool isWalletBalanceSufficientToCoverTransaction(
      WidgetRef ref, int walletAmount, UserModel user) {
    final totalOrderPrice = Pricing(ref: ref).orderTotalFromUserType(user);
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);

    num balance = walletAmount;
    if (selectedLoadAmount == null) {
      // If there is no selected load amount, add the load and pay amount to the wallet balance
      balance += loadAndPayWalletAmount(ref, user, walletAmount);
    } else {
      // If there is a selected load amount, add it to the wallet balance
      balance += selectedLoadAmount;
    }

    // If the balance is equal to or greater than the total order price, return true
    return balance >= totalOrderPrice;
  }

  int loadAndPayWalletAmount(WidgetRef ref, UserModel user, int walletAmount) {
    final difference =
        _differenceBetweenOrderAmountAndWalletBalance(ref, user, walletAmount);
    final loadAmounts = ref.watch(walletLoadAmountsProvider);
    // Find the appropriate load amount
    int selectedLoadAmount = _findMatchingLoadAmount(loadAmounts, difference);
    WalletHelpers(ref: ref)
        .updateSelectedLoadAmount(loadAmounts, selectedLoadAmount);
    return selectedLoadAmount;
  }

  double _differenceBetweenOrderAmountAndWalletBalance(
      WidgetRef ref, UserModel user, int walletAmount) {
    final totalOrderPrice = Pricing(ref: ref).orderTotalFromUserType(user);
    return totalOrderPrice - walletAmount;
  }

  int _findMatchingLoadAmount(List<int> loadAmounts, double difference) {
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
}
