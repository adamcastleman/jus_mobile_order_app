import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Payments/create_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Payments/guest_payment_option_tile_sign_up_text.dart';
import 'package:jus_mobile_order_app/Payments/payment_option_tile.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';

class ChoosePaymentTypeSheet extends ConsumerWidget {
  const ChoosePaymentTypeSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserProviderWidget(
      builder: (user) => PointsDetailsProviderWidget(
        builder: (points) => Wrap(
          children: [
            const Center(
              child: SheetNotch(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JusDivider().thin(),
                  PaymentOptionTile(
                    icon: CupertinoIcons.creditcard,
                    title: 'Add credit card',
                    subtitle: user.uid == null
                        ? const GuestSignUpText()
                        : Text(
                            'Earn ${PointsHelper(ref: ref).determinePointsMultipleText(isWallet: false)} per \$1'),
                    onTap: () {
                      HapticFeedback.lightImpact();

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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        user.uid == null
                            ? const GuestSignUpText()
                            : Text(
                                'Earn ${PointsHelper(ref: ref).determinePointsMultipleText(isWallet: true)} per \$1'),
                      ],
                    ),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      ModalBottomSheet().partScreen(
                        enableDrag: true,
                        isScrollControlled: true,
                        isDismissible: true,
                        context: context,
                        builder: (context) => const CreateWalletSheet(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
