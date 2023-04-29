import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Payments/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/Payments/apple_pay_wallet_tile.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Views/points_detail_page.dart';
import 'package:jus_mobile_order_app/Wallets/select_credit_card_for_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Wallets/select_wallet_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/info_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/total_price.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

class WalletHelpers {
  final WidgetRef ref;

  WalletHelpers({required this.ref});

  Widget buildHeader(
    BuildContext context,
  ) {
    final walletType = ref.watch(walletTypeProvider);
    String headerText;

    if (walletType == WalletType.createWallet) {
      headerText = 'Create new Wallet';
    } else if (walletType == WalletType.addFunds) {
      headerText = 'Add Funds to Wallet';
    } else {
      headerText = 'Load Wallet and Pay';
    }
    return PointsDetailsProviderWidget(
      builder: (points) => Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 12.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  headerText,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Earn up to ${points.walletPointsPerDollarMember}x points per \$1',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Spacing().horizontal(5),
                    InfoButton(
                      size: 16,
                      onTap: () {
                        ModalBottomSheet().fullScreen(
                          context: context,
                          builder: (context) => const PointsDetailPage(
                            closeButton: true,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              JusDivider().thin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWalletCategory() {
    final walletType = ref.watch(walletTypeProvider);
    if (walletType == WalletType.createWallet) {
      return const SizedBox();
    } else {
      return const Padding(
        padding: EdgeInsets.only(top: 12.0),
        child: CategoryWidget(text: 'Wallet'),
      );
    }
  }

  Widget buildSelectWalletTile() {
    final walletType = ref.watch(walletTypeProvider);
    return walletType == WalletType.createWallet
        ? const SizedBox()
        : const Padding(
            padding: EdgeInsets.only(bottom: 18.0),
            child: SelectWalletTile(),
          );
  }

  Widget buildAmountCategory() {
    final walletType = ref.watch(walletTypeProvider);
    String walletText;
    if (walletType == WalletType.createWallet) {
      walletText = 'Initial Balance';
    } else {
      walletText = 'Add to Wallet';
    }
    return CategoryWidget(
      text: walletText,
    );
  }

  Widget determineDefaultPayment(
      BuildContext context, List<PaymentsModel> creditCards) {
    if (ref.watch(applePaySelectedProvider)) {
      return ApplePayWalletTile(onTap: () => selectCreditCard(context));
    }

    if (creditCards.isNotEmpty) {
      return buildPaymentTile(
          _getPaymentMethodText(creditCards), () => selectCreditCard(context));
    } else {
      return const SizedBox();
    }
  }

  String _getPaymentMethodText(List<PaymentsModel> creditCards) {
    final selectedCreditCard = ref.watch(selectedCreditCardProvider);
    return selectedCreditCard.isEmpty
        ? PaymentsHelper().displaySelectedCardTextFromPaymentModel(
            creditCards.firstWhere((element) => !element.isWallet))
        : PaymentsHelper().displaySelectedCardTextFromMap(selectedCreditCard);
  }

  Widget buildPaymentTile(String paymentText, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          title: Text(
            paymentText,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const ChevronRightIcon(),
          onTap: onTap,
        ),
      ],
    );
  }

  determineAddPaymentTile(BuildContext context, UserModel user) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    if (selectedPayment.isNotEmpty) {
      return const SizedBox();
    } else {
      return AddPaymentMethodTile(
        isWallet: false,
        isTransfer: false,
        title: 'Add Payment Method',
        onTap: () {
          PaymentsServices(
                  ref: ref,
                  userID: user.uid,
                  firstName: user.firstName,
                  context: context)
              .initSquarePayment();
        },
      );
    }
  }

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
    return selectedLoadAmount ?? ref.watch(loadAmountsProvider)[3];
  }

  void displayInvalidPaymentError(BuildContext context) {
    ModalBottomSheet().partScreen(
      context: context,
      builder: (context) => const InvalidSheetSinglePop(
        error: 'Please choose a payment method.',
      ),
    );
  }
}
