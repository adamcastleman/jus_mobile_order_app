import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';

class WalletHelpers {
  static displayOrderTotal(WidgetRef ref, UserModel user) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          const TotalPrice().buildSubtotalWithDiscountRow(ref, user),
          const TotalPrice().buildTaxesRow(ref, user),
          const TotalPrice().buildTipRow(ref, user),
          Spacing.vertical(10),
          const TotalPrice().buildOrderTotalRow(ref, user),
        ],
      ),
    );
  }

  static void updateSelectedLoadAmount(
      WidgetRef ref, List<int> loadAmounts, int selectedLoadAmount) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedLoadAmountProvider.notifier).state = selectedLoadAmount;
      ref.read(selectedLoadAmountIndexProvider.notifier).state =
          loadAmounts.indexOf(selectedLoadAmount);
    });
  }

  static int loadWalletAmount(WidgetRef ref) {
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    return selectedLoadAmount ?? ref.watch(walletLoadAmountsProvider)[3];
  }

  static bool isWalletBalanceSufficientToCoverTransaction(
      WidgetRef ref, int walletAmount, UserModel user) {
    final totalOrderPrice = PricingHelpers().orderTotalFromUserType(ref, user);
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);

    num balance = walletAmount;
    if (selectedLoadAmount == null) {
      // If there is no selected load amount, add the load and pay amount to the wallet balance
      balance += WalletHelpers().getDefaultLoadAmount(ref, user, walletAmount);
    } else {
      // If there is a selected load amount, add it to the wallet balance
      balance += selectedLoadAmount;
    }

    // If the balance is equal to or greater than the total order price, return true
    return balance >= totalOrderPrice;
  }

  int getDefaultLoadAmount(WidgetRef ref, UserModel user, int walletAmount) {
    final difference =
        _differenceBetweenOrderAmountAndWalletBalance(ref, user, walletAmount);
    final loadAmounts = ref.watch(walletLoadAmountsProvider);
    // Find the appropriate load amount
    int selectedLoadAmount = _findMatchingLoadAmount(loadAmounts, difference);
    updateSelectedLoadAmount(ref, loadAmounts, selectedLoadAmount);
    return selectedLoadAmount;
  }

  static double _differenceBetweenOrderAmountAndWalletBalance(
      WidgetRef ref, UserModel user, int walletAmount) {
    final totalOrderPrice = PricingHelpers().orderTotalFromUserType(ref, user);
    return totalOrderPrice - walletAmount;
  }

  static int _findMatchingLoadAmount(List<int> loadAmounts, double difference) {
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

  static void updateSelectedLoadAmountIndex(
    WidgetRef ref,
    UserModel user,
  ) {
    final loadAmounts = ref.read(walletLoadAmountsProvider);
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    final walletBalance =
        selectedLoadAmount ?? 0; // Assuming `wallet` is accessible from `user`
    final minimumLoadAmount =
        WalletHelpers().getDefaultLoadAmount(ref, user, walletBalance);

    // Find the index of the load amount that matches or exceeds the minimum required load amount
    final loadAmountIndex =
        loadAmounts.indexWhere((amount) => amount >= minimumLoadAmount);

    // Ensure the index is within the list bounds and not already set to the same value
    if (loadAmountIndex != -1 &&
        ref.read(selectedLoadAmountIndexProvider) != loadAmountIndex) {
      ref.read(selectedLoadAmountIndexProvider.notifier).state =
          loadAmountIndex;
    }
  }
}
