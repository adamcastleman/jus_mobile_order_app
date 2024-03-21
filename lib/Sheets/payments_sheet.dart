import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/payment_methods.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Sheets/create_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/transfer_gift_card_to_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/saved_payments_list_view.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/constants.dart';

class PaymentSettingsSheet extends ConsumerWidget {
  final VoidCallback? onCardSelectTap;
  final VoidCallback? onCardEditTap;

  const PaymentSettingsSheet(
      {this.onCardEditTap, this.onCardSelectTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final backgroundColor = ref.watch(backgroundColorProvider);
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    final isDrawerOpen = AppConstants.scaffoldKey.currentState?.isEndDrawerOpen;
    final transferTileKey = UniqueKey();
    final walletTileKey = UniqueKey();
    final creditCardTileKey = UniqueKey();
    return CreditCardProviderWidget(
      builder: (creditCards) => WalletProviderWidget(
        builder: (wallets) => Container(
          padding: EdgeInsets.only(
            top: PlatformUtils.isIOS() || PlatformUtils.isAndroid()
                ? 50.0
                : 10.0,
            left: 12.0,
            right: 12.0,
            bottom: 30.0,
          ),
          color: backgroundColor,
          child: ListView(
            primary: false,
            children: [
              SheetHeader(
                title: 'Payment Methods',
                showCloseButton: isDrawerOpen == null || !isDrawerOpen,
                onClose: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              ),
              Spacing.vertical(30),
              const CategoryWidget(text: 'Gift cards - Transfer balance'),
              AddPaymentMethodTile(
                tileKey: transferTileKey,
                isWallet: false,
                isTransfer: true,
                title: 'Transfer balance to Wallet',
                onTap: () {
                  _handleTransferGiftCardToWalletOnTap(
                      context, ref, wallets, transferTileKey);
                },
              ),
              Spacing.vertical(20),
              CategoryWidget(
                  text:
                      'Wallets - Earn ${PointsHelper().pointsDisplayText(ref: ref, isWallet: true)}/\$1'),
              SavedPaymentsListView(
                cards: wallets,
              ),
              wallets.isEmpty ? const SizedBox() : JusDivider.thin(),
              AddPaymentMethodTile(
                tileKey: walletTileKey,
                isWallet: true,
                isTransfer: false,
                title: 'Create Wallet',
                onTap: () {
                  _handleCreateWalletOnTap(context, ref, selectedPayment,
                      creditCards, walletTileKey);
                },
              ),
              Spacing.vertical(20),
              CategoryWidget(
                  text:
                      'Payment method - Earn ${PointsHelper().pointsDisplayText(ref: ref, isWallet: false)}/\$1'),
              SavedPaymentsListView(
                cards: creditCards,
              ),
              creditCards.isEmpty ? const SizedBox() : JusDivider.thin(),
              AddPaymentMethodTile(
                tileKey: creditCardTileKey,
                isWallet: false,
                isTransfer: false,
                title: 'Add payment method',
                onTap: () {
                  _handleAddPaymentMethodOnTap(
                      context, ref, user, creditCardTileKey);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTransferGiftCardToWalletOnTap(BuildContext context, WidgetRef ref,
      List<PaymentsModel> wallets, UniqueKey transferTileKey) {
    HapticFeedback.lightImpact();
    if (PlatformUtils.isWeb()) {
      ref.read(tileKeyProvider.notifier).state = transferTileKey;
    }
    if (wallets.isEmpty) {
      ErrorHelpers.showSinglePopError(context,
          error: 'Create a Wallet to transfer a gift card balance.');
    } else {
      NavigationHelpers.navigateToPartScreenSheetOrDialog(
        context,
        const TransferGiftCardToWalletSheet(),
      );
    }
  }

  _handleAddPaymentMethodOnTap(BuildContext context, WidgetRef ref,
      UserModel user, UniqueKey creditCardTileKey) {
    HapticFeedback.lightImpact();
    if (PlatformUtils.isWeb()) {
      ref.read(tileKeyProvider.notifier).state = creditCardTileKey;
    }

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
  }

  _handleCreateWalletOnTap(
      BuildContext context,
      WidgetRef ref,
      PaymentsModel selectedPayment,
      List<PaymentsModel> creditCards,
      UniqueKey walletTileKey) {
    HapticFeedback.lightImpact();
    if (creditCards.isEmpty) {
      ErrorHelpers.showSinglePopError(context,
          error: 'Before creating a Wallet, please upload a payment method.');
    } else {
      ref.read(walletTypeProvider.notifier).state = WalletType.createWallet;
      ref.read(tileKeyProvider.notifier).state = walletTileKey;
      if (selectedPayment.isWallet) {
        PaymentMethodHelpers()
            .setCreditCardProviderToValidPaymentMethod(ref, creditCards.first);
      } else {
        PaymentMethodHelpers()
            .setCreditCardProviderToValidPaymentMethod(ref, selectedPayment);
      }

      NavigationHelpers.navigateToPartScreenSheetOrDialog(
        context,
        const CreateWalletSheet(),
      );
    }
  }
}
