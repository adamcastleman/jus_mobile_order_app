import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/payment_methods.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Sheets/create_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Views/register_page.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_with_loading_icon.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/payment_option_tile.dart';
import 'package:jus_mobile_order_app/constants.dart';

class ChoosePaymentTypeSheet extends ConsumerWidget {
  const ChoosePaymentTypeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final creditCardKey = UniqueKey();
    final walletKey = UniqueKey();
    return CreditCardProviderWidget(
      builder: (creditCards) => Wrap(
        children: [
          PlatformUtils.isIOS() || PlatformUtils.isAndroid()
              ? const Center(
                  child: SheetNotch(),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentOptionTile(
                  icon: CupertinoIcons.creditcard,
                  title: 'Add credit card',
                  subtitle: user.uid == null
                      ? null
                      : Text(
                          'Earn ${PointsHelper().pointsDisplayText(ref: ref, isWallet: false)}/\$1'),
                  trailing: SizedBox(
                    height: 20,
                    width: 20,
                    child: ChevronRightWithLoadingIcon(
                      tileKey: creditCardKey,
                    ),
                  ),
                  onTap: () {
                    ref.read(tileKeyProvider.notifier).state = creditCardKey;
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
                ),
                JusDivider.thin(),
                PaymentOptionTile(
                  icon: FontAwesomeIcons.wallet,
                  title: 'Create Wallet',
                  subtitle: user.uid == null
                      ? const SizedBox()
                      : Text(
                          'Earn ${PointsHelper().pointsDisplayText(ref: ref, isWallet: true)}/\$1'),
                  trailing: SizedBox(
                    height: 20,
                    width: 20,
                    child: ChevronRightWithLoadingIcon(
                      tileKey: walletKey,
                    ),
                  ),
                  onTap: () async {
                    ref.read(walletTypeProvider.notifier).state =
                        WalletType.createWallet;
                    PaymentMethodHelpers().validateCreateWalletSheet(
                        user: user,
                        paymentSources: creditCards,
                        onGuest: () => NavigationHelpers
                            .navigateToFullScreenSheetOrEndDrawer(context, ref,
                                AppConstants.scaffoldKey, const RegisterPage()),
                        onEmptyPaymentSource: () =>
                            ErrorHelpers.showSinglePopError(
                              context,
                              error:
                                  'To create a Wallet, you must have a card on file.',
                            ),
                        onSuccess: () =>
                            NavigationHelpers.navigateToPartScreenSheetOrDialog(
                              context,
                              const CreateWalletSheet(),
                            ));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
