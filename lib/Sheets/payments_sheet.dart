import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Sheets/create_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Sheets/transfer_gift_card_to_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/saved_payments_list_view.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/add_payment_method_tile.dart';

class PaymentSettingsSheet extends ConsumerWidget {
  final VoidCallback? onCardSelectTap;
  final VoidCallback? onCardEditTap;
  const PaymentSettingsSheet(
      {this.onCardEditTap, this.onCardSelectTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final backgroundColor = ref.watch(backgroundColorProvider);
    return CreditCardProviderWidget(
      builder: (creditCards) => WalletProviderWidget(
        builder: (wallets) => Container(
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 12.0, right: 12.0),
            child: ListView(
              primary: false,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: JusCloseButton(
                    removePadding: true,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Text(
                  'Payment Methods',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Spacing.vertical(30),
                const CategoryWidget(text: 'Gift cards - Transfer balance'),
                AddPaymentMethodTile(
                  isWallet: false,
                  isTransfer: true,
                  title: 'Transfer balance to Wallet',
                  onTap: () {
                    ModalBottomSheet().partScreen(
                      enableDrag: true,
                      isScrollControlled: true,
                      isDismissible: true,
                      context: context,
                      builder: (context) => wallets.isEmpty
                          ? const InvalidSheetSinglePop(
                              error:
                                  'Create a Wallet to transfer a gift card balance.')
                          : const TransferGiftCardToWalletSheet(),
                    );
                  },
                ),
                Spacing.vertical(20),
                CategoryWidget(
                    text:
                        'Wallets - Earn ${PointsHelper(ref: ref).pointsDisplayText(isWallet: true)}/\$1'),
                SavedPaymentsListView(
                  cards: wallets,
                ),
                wallets.isEmpty ? const SizedBox() : JusDivider().thin(),
                AddPaymentMethodTile(
                  isWallet: true,
                  isTransfer: false,
                  title: 'Create Wallet',
                  onTap: () {
                    if (creditCards.isEmpty) {
                      ModalBottomSheet().partScreen(
                        context: context,
                        builder: (context) => const InvalidSheetSinglePop(
                            error:
                                'Before creating a Wallet, please upload a payment method.'),
                      );
                    } else {
                      ref.read(walletTypeProvider.notifier).state =
                          WalletType.createWallet;
                      PaymentsHelper(ref: ref)
                          .setSelectedPaymentToValidPaymentMethod(creditCards);
                      ModalBottomSheet().partScreen(
                        enableDrag: true,
                        isDismissible: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => const CreateWalletSheet(),
                      );
                    }
                  },
                ),
                Spacing.vertical(20),
                CategoryWidget(
                    text:
                        'Payment method - Earn ${PointsHelper(ref: ref).pointsDisplayText(isWallet: false)}/\$1'),
                SavedPaymentsListView(
                  cards: creditCards,
                ),
                creditCards.isEmpty ? const SizedBox() : JusDivider().thin(),
                AddPaymentMethodTile(
                  isWallet: false,
                  isTransfer: false,
                  title: 'Add payment method',
                  onTap: () {
                    SquarePaymentServices().inputSquareCreditCard(ref, user);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
