import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/payment_methods.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/payment_option_tile.dart';

class SelectCreditCardOnlySheet extends ConsumerWidget {
  final List<PaymentsModel> creditCards;
  final VoidCallback? onCreditCardSelected;
  const SelectCreditCardOnlySheet(
      {required this.creditCards, this.onCreditCardSelected, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final tileKey = UniqueKey();
    final paymentHelpers = PaymentMethodHelpers();

    // Pre-calculate non-wallet credit cards and the offset for indices
    final nonWalletCards =
        creditCards.where((element) => !element.isWallet).toList();
    final int applePayOffset = PlatformUtils.isIOS() ? 2 : 1;

    return SizedBox(
      height: 600,
      child: Column(
        children: [
          PlatformUtils.isWeb() ? const SizedBox() : const SheetNotch(),
          const Padding(
            padding: EdgeInsets.only(top: 22.0, bottom: 12.0),
            child: Text(
              'Choose card',
              style: TextStyle(fontSize: 18),
            ),
          ),
          JusDivider.thick(),
          Expanded(
            child: ListView.separated(
              padding:
                  const EdgeInsets.symmetric(vertical: 22.0, horizontal: 12.0),
              shrinkWrap: true,
              itemCount: nonWalletCards.length + applePayOffset,
              separatorBuilder: (context, index) => JusDivider.thin(),
              itemBuilder: (context, index) {
                if (index == nonWalletCards.length) {
                  // Add Payment Method option
                  return _buildAddPaymentMethodTile(
                      tileKey, context, ref, user);
                } else if (PlatformUtils.isIOS() &&
                    index == nonWalletCards.length + 1) {
                  // Pay with Apple Pay option
                  return _buildApplePayTile(context, ref);
                } else if (index < nonWalletCards.length) {
                  // Credit card options
                  return _buildPaymentOptionTile(nonWalletCards[index], context,
                      ref, user, paymentHelpers);
                } else {
                  // This should never be reached if itemCount is correct
                  assert(false, 'Unhandled index: $index');
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPaymentMethodTile(
      UniqueKey tileKey, BuildContext context, WidgetRef ref, UserModel user) {
    return AddPaymentMethodTile(
      tileKey: tileKey,
      isWallet: false,
      isTransfer: false,
      title: 'Add Payment Method',
      onTap: () {
        ref.read(tileKeyProvider.notifier).state = tileKey;
        PaymentMethodHelpers().addCreditCardAsSelectedPayment(
          context,
          ref,
          user,
          onSuccess: () {
            ref.read(squarePaymentSkdLoadingProvider.notifier).state = false;
            if (onCreditCardSelected != null) {
              onCreditCardSelected!();
            }
            if (PlatformUtils.isWeb()) {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  Widget _buildApplePayTile(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(FontAwesomeIcons.apple),
      title: Row(
        children: [
          const Text('Pay with '),
          Spacing.horizontal(2),
          const Icon(
            FontAwesomeIcons.applePay,
            size: 35,
          )
        ],
      ),
      onTap: () {
        ref.read(applePaySelectedProvider.notifier).state = true;
        Navigator.pop(context);
      },
    );
  }

  Widget _buildPaymentOptionTile(PaymentsModel card, BuildContext context,
      WidgetRef ref, UserModel user, PaymentMethodHelpers paymentHelpers) {
    return PaymentOptionTile(
      icon: CupertinoIcons.creditcard,
      title:
          '${card.cardNickname} - ${paymentHelpers.displayBrandName(card.brand)} ending in ${card.last4}',
      subtitle: const SizedBox(),
      onTap: () {
        ref.read(applePaySelectedProvider.notifier).state = false;
        ref.read(selectedCreditCardProvider.notifier).state = PaymentsModel(
          userId: user.uid ?? '',
          brand: paymentHelpers.displayBrandName(card.brand),
          last4: card.last4,
          defaultPayment: card.defaultPayment,
          cardNickname: card.cardNickname,
          isWallet: card.isWallet,
          cardId: card.cardId,
        );
        if (onCreditCardSelected != null) {
          onCreditCardSelected!();
        }
        Navigator.pop(context);
      },
    );
  }
}
