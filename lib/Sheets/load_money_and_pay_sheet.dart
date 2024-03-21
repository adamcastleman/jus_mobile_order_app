import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/payment_methods.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Helpers/wallet.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/load_wallet_and_pay_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/load_wallet_header.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/wallet_category_header.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/current_wallet_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/default_payment_tile.dart';
import 'package:jus_mobile_order_app/constants.dart';

import '../Widgets/Tiles/wallet_load_amount_selector_tile.dart';

class LoadWalletAndPaySheet extends ConsumerWidget {
  const LoadWalletAndPaySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final wallet = ref.watch(selectedPaymentMethodProvider);
    final walletType = ref.watch(walletTypeProvider)!;
    final tileKey = UniqueKey();
    final selectedCreditCard = ref.watch(selectedCreditCardProvider);
    final loadAmounts = ref.watch(walletLoadAmountsProvider);
    final selectedLoadAmountIndex = ref.watch(selectedLoadAmountIndexProvider);

    // Determine the load amount to format based on the user's selection or the minimum load amount.
    final formattedLoadAmount = (selectedLoadAmountIndex == null
        ? (loadAmounts[AppConstants.defaultWalletLoadAmountIndex] / 100).round()
        : (loadAmounts[selectedLoadAmountIndex] / 100).round());

    return CreditCardProviderWidget(
      builder: (creditCards) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (selectedCreditCard.cardId == null ||
              selectedCreditCard.cardId!.isEmpty) {
            ref.read(selectedCreditCardProvider.notifier).state = PaymentsModel(
              userId: creditCards.first.userId,
              brand: creditCards.first.brand,
              last4: creditCards.first.last4,
              defaultPayment: creditCards.first.defaultPayment,
              cardNickname: creditCards.first.cardNickname,
              isWallet: creditCards.first.isWallet,
              cardId: creditCards.first.cardId,
            );
          }
        });
        return Padding(
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
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: CurrentWalletTile(wallet: wallet),
                    ),
              const CategoryWidget(text: 'Payment Amount'),
              WalletLoadAmountSelectorTile(
                user: user,
                walletType: walletType,
                loadAmount: formattedLoadAmount,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 12.0,
                ),
                child: CategoryWidget(text: 'Payment Source'),
              ),
              DefaultPaymentTile(creditCards: creditCards),
              determineAddPaymentTile(context, ref, user, tileKey),
              const Padding(
                padding: EdgeInsets.only(
                  top: 22.0,
                ),
                child: CategoryWidget(text: 'Order Total'),
              ),
              WalletHelpers.displayOrderTotal(ref, user),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: _determinePaymentButton(context, ref, user),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget determineAddPaymentTile(
      BuildContext context, WidgetRef ref, UserModel user, UniqueKey tileKey) {
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    if (selectedPayment.uid != null || selectedPayment.uid!.isNotEmpty) {
      return const SizedBox();
    } else {
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
              if (PlatformUtils.isWeb()) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
          );
        },
      );
    }
  }

  Widget _determinePaymentButton(
      BuildContext context, WidgetRef ref, UserModel user) {
    final selectedWallet = ref.watch(selectedPaymentMethodProvider);
    final selectedCreditCard = ref.watch(selectedCreditCardProvider);

    return LoadWalletAndPayButton(
      wallet: selectedWallet,
      creditCard: selectedCreditCard,
      user: user,
    );
  }
}
