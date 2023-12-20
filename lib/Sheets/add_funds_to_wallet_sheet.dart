import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/load_wallet_with_funds_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/load_wallet_header.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/wallet_add_balance_header.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/default_payment_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/select_wallet_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/wallet_load_balance_tile.dart';

import '../Widgets/Headers/wallet_category_header.dart';

class AddFundsToWalletSheet extends ConsumerWidget {
  const AddFundsToWalletSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final walletType = ref.watch(walletTypeProvider)!;
    return WalletProviderWidget(
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
                WalletAddBalanceHeader(walletType: walletType),
                WalletBalanceLoadTile(user: user),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 12.0,
                  ),
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
                          SquarePaymentServices()
                              .inputSquareCreditCard(ref, user);
                        },
                      ),
                JusDivider().thin(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: LoadWalletWithFundsButton(user: user),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
