import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/payment_methods.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/create_wallet_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/load_wallet_header.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/wallet_category_header.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/default_payment_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/wallet_load_amount_selector_tile.dart';
import 'package:jus_mobile_order_app/constants.dart';

import '../Widgets/Tiles/select_wallet_tile.dart';

class CreateWalletSheet extends ConsumerWidget {
  const CreateWalletSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final walletType = ref.watch(walletTypeProvider)!;
    final tileKey = UniqueKey();

    final selectedCreditCard = ref.watch(selectedCreditCardProvider);
    final loadAmounts = ref.watch(walletLoadAmountsProvider);
    final loadAmountIndex = ref.watch(selectedLoadAmountIndexProvider);
    final formattedLoadAmount = (loadAmounts[
                loadAmountIndex ?? AppConstants.defaultWalletLoadAmountIndex] /
            100)
        .round();

    return CreditCardProviderWidget(
      builder: (creditCards) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Wrap(
          children: [
            PlatformUtils.isWeb()
                ? const SizedBox()
                : const Padding(
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
            const Padding(
              padding: EdgeInsets.only(top: 18.0),
              child: CategoryWidget(text: 'Initial Balance'),
            ),
            WalletLoadAmountSelectorTile(
              user: user,
              walletType: walletType,
              loadAmount: formattedLoadAmount,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 18.0),
              child: CategoryWidget(text: 'Payment Source'),
            ),
            creditCards.isEmpty
                ? AddPaymentMethodTile(
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
                          ref
                              .read(squarePaymentSkdLoadingProvider.notifier)
                              .state = false;
                          if (PlatformUtils.isWeb()) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                  )
                : DefaultPaymentTile(creditCards: creditCards),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: CreateWalletButton(
                user: user,
                loadAmount: formattedLoadAmount,
                creditCard: selectedCreditCard,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
