import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/modal_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/payment_methods.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Sheets/create_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/list_of_wallets_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/constants.dart';

class TransferGiftCardToWalletSheet extends ConsumerWidget {
  const TransferGiftCardToWalletSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final giftCard = ref.watch(physicalGiftCardBalanceProvider);
    final giftCardLoading = ref.watch(giftCardLoadingProvider);
    final user = ref.watch(currentUserProvider).value!;
    final isDrawerOpen = AppConstants.scaffoldKey.currentState?.isEndDrawerOpen;
    return CreditCardProviderWidget(
      builder: (cards) => WalletProviderWidget(
        builder: (wallets) {
          return Container(
            padding: EdgeInsets.only(
                top: isDrawerOpen == null || !isDrawerOpen ? 0.0 : 24.0,
                left: 12.0,
                right: 12.0,
                bottom: 24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: backgroundColor,
            ),
            child: Wrap(
              children: [
                isDrawerOpen == null || !isDrawerOpen
                    ? const SheetNotch()
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12.0),
                  child: _buildHeader(),
                ),
                JusDivider.thin(),
                Spacing.vertical(40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    giftCard.isEmpty
                        ? _addGiftCardWidget(
                            context, ref, user, giftCardLoading)
                        : _currentGiftCardWidget(
                            context, ref, user, giftCard, giftCardLoading),
                    const Icon(CupertinoIcons.arrow_right),
                    wallets.isEmpty
                        ? _createNewWallet(context, ref, user, cards)
                        : _currentWalletSelectedButton(context, ref, wallets),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 30.0,
                    horizontal: 10.0,
                  ),
                  child: Text(
                    'Please note that this action will transfer the full '
                    'balance from your physical gift card to your digital wallet. '
                    'After the transfer, the balance on your physical card will '
                    'become zero.',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                _transferBalanceButton(context, ref, wallets),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildHeader() {
    return const Center(
      child: AutoSizeText(
        'Transfer gift card balance to Wallet',
        style: TextStyle(fontSize: 20),
        maxLines: 1,
      ),
    );
  }

  _transferCard(
      {bool? isLoading,
      required List<Widget> children,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: isLoading != null && isLoading
            ? const Loading()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: children,
              ),
      ),
    );
  }

  _addGiftCardWidget(BuildContext context, WidgetRef ref, UserModel user,
      bool giftCardLoading) {
    return _transferCard(
      isLoading: giftCardLoading,
      children: const [
        Icon(
          FontAwesomeIcons.gift,
          size: 30,
        ),
        Text('Upload Gift Card'),
      ],
      onTap: () {
        PaymentMethodHelpers().showSquareGiftCardEntryForm(context, ref, user);
      },
    );
  }

  _currentGiftCardWidget(BuildContext context, WidgetRef ref, UserModel user,
      Map giftCard, bool giftCardLoading) {
    return _transferCard(
      isLoading: giftCardLoading,
      children: [
        const Icon(
          FontAwesomeIcons.gift,
          size: 30,
        ),
        Column(
          children: [
            Text(
                'Gift Card x${giftCard['gan'].substring(giftCard['gan'].length - 4)}'),
            Text('Balance: \$${(giftCard['amount'] / 100).toStringAsFixed(2)}')
          ],
        ),
      ],
      onTap: () {
        PaymentMethodHelpers().showSquareGiftCardEntryForm(context, ref, user);
      },
    );
  }

  _currentWalletSelectedButton(
      BuildContext context, WidgetRef ref, List<PaymentsModel> wallets) {
    final selectedWallet = ref.watch(selectedWalletProvider);
    return _transferCard(
      children: [
        const Icon(
          FontAwesomeIcons.wallet,
          size: 30,
        ),
        Column(
          children: [
            Text(
              selectedWallet.userId.isEmpty
                  ? wallets.first.cardNickname
                  : selectedWallet.cardNickname,
              textAlign: TextAlign.center,
            ),
            Text(
                'Balance: \$${((selectedWallet.userId.isEmpty ? wallets.first.balance! : selectedWallet.balance!) / 100).toStringAsFixed(2)}'),
          ],
        ),
      ],
      onTap: () {
        NavigationHelpers.navigateToPartScreenSheetOrDialog(
          context,
          const ListOfWalletsSheet(),
        );
      },
    );
  }

  _createNewWallet(BuildContext context, WidgetRef ref, UserModel user,
      List<PaymentsModel> cards) {
    return _transferCard(
      children: [
        const Icon(FontAwesomeIcons.wallet),
      ],
      onTap: () {
        if (cards.isEmpty) {
          ErrorHelpers.showSinglePopError(context,
              error:
                  'Before creating a Wallet, please upload a payment method.');
        } else {
          PaymentMethodHelpers()
              .setSelectedPaymentToValidPaymentMethod(ref, user, cards);
          ModalBottomSheet().partScreen(
            isDismissible: true,
            isScrollControlled: true,
            enableDrag: true,
            context: context,
            builder: (context) => const CreateWalletSheet(),
          );
        }
      },
    );
  }

  _transferBalanceButton(
      BuildContext context, WidgetRef ref, List<PaymentsModel> wallets) {
    final user = ref.watch(currentUserProvider).value!;
    final loading = ref.watch(loadingProvider);

    if (loading) {
      return const Center(
        child: LargeElevatedLoadingButton(),
      );
    } else {
      return Center(
        child: LargeElevatedButton(
          buttonText: 'Transfer Balance',
          onPressed: () {
            _handleBalanceTransferTap(context, ref, user, wallets);
          },
        ),
      );
    }
  }

  _handleBalanceTransferTap(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
    List<PaymentsModel> wallets,
  ) async {
    final selectedWallet = ref.watch(selectedWalletProvider);
    final giftCard = ref.watch(physicalGiftCardBalanceProvider);

    if (giftCard.isEmpty) {
      return ErrorHelpers.showSinglePopError(context,
          error: 'Please upload your gift card.');
    }

    if (giftCard.isNotEmpty && giftCard['amount'] < 0.01) {
      return ErrorHelpers.showSinglePopError(context,
          error: 'This gift card is empty.');
    }

    ref.read(loadingProvider.notifier).state = true;

    final response = await SquarePaymentServices().transferGiftCardBalance(
      ref: ref,
      email: user.email!,
      firstName: user.firstName!,
      walletGan: selectedWallet.userId.isEmpty
          ? wallets.first.gan!
          : selectedWallet.gan!,
      walletUID: selectedWallet.userId.isEmpty
          ? wallets.first.uid ?? ''
          : selectedWallet.uid!,
      physicalCardGan: giftCard['gan'],
      physicalCardAmount: giftCard['amount'],
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (response.data == 200) {
          Navigator.pop(context);
        } else {
          ErrorHelpers.showSinglePopError(
            context,
            error:
                'There was an unexpected error processing this request. Please try again later.',
          );
        }
      },
    );

    ref.read(loadingProvider.notifier).state = false;
  }
}
