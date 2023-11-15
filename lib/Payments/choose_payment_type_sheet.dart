import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Payments/payment_option_tile.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Views/register_page.dart';
import 'package:jus_mobile_order_app/Wallets/create_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';

class ChoosePaymentTypeSheet extends ConsumerWidget {
  const ChoosePaymentTypeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    return CreditCardProviderWidget(
      builder: (creditCards) => WalletProviderWidget(
        builder: (wallets) => PointsDetailsProviderWidget(
          builder: (points) => Wrap(
            children: [
              const Center(
                child: SheetNotch(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JusDivider().thin(),
                    PaymentOptionTile(
                      icon: CupertinoIcons.creditcard,
                      title: 'Add credit card',
                      subtitle: user.uid == null
                          ? null
                          : Text(
                              'Earn ${PointsHelper(ref: ref).pointsDisplayText(isWallet: false)}/\$1'),
                      onTap: () {
                        PaymentsServices(
                                context: context,
                                ref: ref,
                                userID: user.uid,
                                firstName: user.firstName)
                            .initSquarePayment();
                        Navigator.pop(context);
                      },
                    ),
                    JusDivider().thin(),
                    PaymentOptionTile(
                      icon: FontAwesomeIcons.wallet,
                      title: 'Create Wallet',
                      subtitle: user.uid == null
                          ? const SizedBox()
                          : Text(
                              'Earn ${PointsHelper(ref: ref).pointsDisplayText(isWallet: true)}/\$1'),
                      onTap: () async {
                        ref.read(walletTypeProvider.notifier).state =
                            WalletType.createWallet;
                        if (user.uid == null) {
                          ModalBottomSheet().fullScreen(
                            context: context,
                            builder: (context) => const RegisterPage(),
                          );
                        }
                        if (creditCards.isEmpty) {
                          ModalBottomSheet().partScreen(
                            context: context,
                            builder: (context) => const InvalidSheetSinglePop(
                                error:
                                    'Before creating a Wallet, please upload a payment method.'),
                          );
                        } else {
                          ModalBottomSheet().partScreen(
                            enableDrag: true,
                            isScrollControlled: true,
                            isDismissible: true,
                            context: context,
                            builder: (context) => const CreateWalletSheet(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
