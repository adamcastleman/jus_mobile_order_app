import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Payments/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/Payments/invalid_payment_sheet.dart';
import 'package:jus_mobile_order_app/Payments/select_credit_card_for_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Payments/select_wallet_load_amount_sheet.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Views/points_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/info_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/payment_method_icons.dart';

class CreateWalletSheet extends ConsumerWidget {
  const CreateWalletSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);

    return UserProviderWidget(
      builder: (user) => CreditCardProviderWidget(
        builder: (creditCards) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Wrap(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: SheetNotch(),
                ),
                _buildHeader(context),
                const CategoryWidget(text: 'Initial Balance'),
                _buildInitialBalance(context, ref),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: CategoryWidget(text: 'Payment'),
                ),
                _determineDefaultPayment(context, ref, creditCards),
                selectedPayment.isNotEmpty
                    ? const SizedBox()
                    : AddPaymentMethodTile(
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
                      ),
                JusDivider().thin(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: _determinePaymentButton(context, ref, user),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 12.0,
        ),
        child: Column(
          children: [
            const Text(
              'Create new Wallet',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Earn up to 2.5x points per \$1',
                    style: TextStyle(
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
    );
  }

  Widget _buildInitialBalance(
    BuildContext context,
    WidgetRef ref,
  ) {
    final loadAmounts = ref.watch(loadAmountsProvider);
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    return ListTile(
      dense: true,
      title: const Text('Amount'),
      subtitle: Text(
        '\$${selectedLoadAmount == null ? (loadAmounts[3] / 100).toStringAsFixed(2) : (selectedLoadAmount / 100).toStringAsFixed(2)}',
        style: const TextStyle(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      trailing: const ChevronRightIcon(),
      onTap: () {
        ModalBottomSheet().partScreen(
          enableDrag: true,
          isScrollControlled: true,
          isDismissible: true,
          context: context,
          builder: (context) => const SelectJusCardLoadAmountSheet(),
        );
      },
    );
  }

  _applePayTile({required VoidCallback onTap}) {
    return ListTile(
        leading: const Icon(FontAwesomeIcons.apple),
        title: Row(
          children: [
            const Text('Pay with'),
            Spacing().horizontal(7),
            const Icon(
              FontAwesomeIcons.applePay,
              size: 35,
            ),
          ],
        ),
        trailing: const ChevronRightIcon(),
        onTap: onTap);
  }

  _determineDefaultPayment(
      BuildContext context, WidgetRef ref, List<PaymentsModel> creditCards) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);

    bool hasValidCreditCards() {
      return creditCards.isNotEmpty &&
          creditCards.any((element) => !element.isWallet);
    }

    String getPaymentMethodText() {
      return selectedPayment.isEmpty
          ? PaymentsHelper().displaySelectedCardTextFromPaymentModel(
              creditCards.firstWhere((element) => !element.isWallet))
          : PaymentsHelper().displaySelectedCardTextFromMap(selectedPayment);
    }

    void handleTap() {
      ModalBottomSheet().partScreen(
        enableDrag: true,
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (context) => const SelectCreditCardForWalletSheet(),
      );
    }

    if (ref.watch(applePaySelectedProvider)) {
      return _applePayTile(
        onTap: handleTap,
      );
    }

    if (!hasValidCreditCards()) {
      return const SizedBox();
    } else {
      return Column(
        children: [
          ListTile(
            leading: const PaymentMethodIcon(),
            title: Text(
              getPaymentMethodText(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const ChevronRightIcon(),
            onTap: handleTap,
          ),
        ],
      );
    }
  }

  _determinePaymentButton(BuildContext context, WidgetRef ref, UserModel user) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final loadAmounts = ref.watch(loadAmountsProvider);
    final selectedLoadAmount = ref.watch(selectedLoadAmountProvider);
    final applePaySelected = ref.watch(applePaySelectedProvider);
    final applePayLoading = ref.watch(applePayLoadingProvider);
    final loading = ref.watch(loadingProvider);

    String getButtonText() {
      final amount = selectedLoadAmount ?? loadAmounts[3];
      return 'Add \$${(amount / 100).toStringAsFixed(2)} to new Wallet';
    }

    void handleButtonPress() {
      if (selectedPayment.isEmpty) {
        ModalBottomSheet().partScreen(
          context: context,
          builder: (context) => const InvalidPaymentSheet(
            error: 'Please choose a payment method.',
          ),
        );
      } else {
        if (applePaySelected) {
          ref.read(applePayLoadingProvider.notifier).state = true;
          PaymentsServices(ref: ref).initApplePayWalletLoad(context, user);
        } else {
          ref.read(loadingProvider.notifier).state = true;
          PaymentsServices(ref: ref).createWallet(context, user);
        }
      }
    }

    return applePayLoading || loading
        ? const LargeElevatedLoadingButton()
        : LargeElevatedButton(
            buttonText: getButtonText(),
            onPressed: handleButtonPress,
          );
  }
}
