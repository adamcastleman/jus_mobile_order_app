import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
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
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Sheets/list_of_wallets_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';

class TransferGiftCardToWalletSheet extends ConsumerWidget {
  const TransferGiftCardToWalletSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final giftCard = ref.watch(physicalGiftCardBalanceProvider);
    return CreditCardProviderWidget(
      builder: (cards) => WalletProviderWidget(
        builder: (wallets) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Wrap(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: SheetNotch(),
                  ),
                  _buildHeader(),
                  JusDivider().thin(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        giftCard.isEmpty
                            ? _addGiftCardWidget(context, ref)
                            : _currentGiftCardWidget(context, ref, giftCard),
                        const Icon(CupertinoIcons.arrow_right),
                        wallets.isEmpty
                            ? _createNewWallet(context, ref, cards)
                            : _currentWalletSelectedButton(
                                context, ref, wallets),
                      ],
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, bottom: 30.0),
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
            ),
          );
        },
      ),
    );
  }

  _buildHeader() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
        child: AutoSizeText(
          'Transfer gift card balance to Wallet.',
          style: TextStyle(fontSize: 20),
          maxLines: 1,
        ),
      ),
    );
  }

  _transferCard({required List<Widget> children, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ),
      ),
    );
  }

  _addGiftCardWidget(BuildContext context, WidgetRef ref) {
    return _transferCard(
      children: const [
        Icon(
          FontAwesomeIcons.gift,
          size: 30,
        ),
        Text('Upload Gift Card'),
      ],
      onTap: () {
        SquarePaymentServices().inputSquareGiftCard(ref);
      },
    );
  }

  _currentGiftCardWidget(BuildContext context, WidgetRef ref, Map giftCard) {
    return _transferCard(
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
        SquarePaymentServices().inputSquareGiftCard(ref);
      },
    );
  }

  _currentWalletSelectedButton(
      BuildContext context, WidgetRef ref, List<PaymentsModel> wallets) {
    final selectedWallet = ref.watch(currentlySelectedWalletProvider);
    return _transferCard(
      children: [
        const Icon(
          FontAwesomeIcons.wallet,
          size: 30,
        ),
        Column(
          children: [
            Text(
              selectedWallet.isEmpty
                  ? wallets.first.cardNickname
                  : selectedWallet['cardNickname'],
              textAlign: TextAlign.center,
            ),
            Text(
                'Balance: \$${((selectedWallet.isEmpty ? wallets.first.balance! : selectedWallet['balance']!) / 100).toStringAsFixed(2)}'),
          ],
        ),
      ],
      onTap: () {
        ModalBottomSheet().partScreen(
          enableDrag: true,
          isDismissible: true,
          isScrollControlled: true,
          context: context,
          builder: (context) => const ListOfWalletsSheet(),
        );
      },
    );
  }

  _createNewWallet(
      BuildContext context, WidgetRef ref, List<PaymentsModel> cards) {
    return _transferCard(
      children: [
        const Icon(FontAwesomeIcons.wallet),
      ],
      onTap: () {
        if (cards.isEmpty) {
          ModalBottomSheet().partScreen(
            context: context,
            builder: (context) => const InvalidSheetSinglePop(
                error:
                    'Before creating a Wallet, please upload a payment method.'),
          );
        } else {
          PaymentsHelper(ref: ref)
              .setSelectedPaymentToValidPaymentMethod(cards);
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
    final selectedWallet = ref.watch(currentlySelectedWalletProvider);
    final giftCard = ref.watch(physicalGiftCardBalanceProvider);

    if (giftCard.isEmpty) {
      return ModalBottomSheet().partScreen(
        context: context,
        builder: (context) =>
            const InvalidSheetSinglePop(error: 'Please upload your gift card.'),
      );
    }

    if (giftCard.isNotEmpty && giftCard['amount'] < 0.01) {
      return ModalBottomSheet().partScreen(
        context: context,
        builder: (context) =>
            const InvalidSheetSinglePop(error: 'This gift card is empty.'),
      );
    }

    ref.read(loadingProvider.notifier).state = true;

    final response = await SquarePaymentServices().transferGiftCardBalance(
      ref: ref,
      email: user.email!,
      firstName: user.firstName!,
      walletGan:
          selectedWallet.isEmpty ? wallets.first.gan : selectedWallet['gan'],
      walletUID:
          selectedWallet.isEmpty ? wallets.first.uid : selectedWallet['uid'],
      physicalCardGan: giftCard['gan'],
      physicalCardAmount: giftCard['amount'],
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (response.data == 200) {
        Navigator.pop(context);
      } else {
        ModalBottomSheet().partScreen(
            context: context,
            builder: (context) => const InvalidSheetSinglePop(
                error:
                    'There was an unexpected error processing this request. Please try again later.'));
      }
    });

    ref.read(loadingProvider.notifier).state = false;
  }
}
