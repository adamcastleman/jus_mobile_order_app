import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/guest_payment_option_tile_sign_up_text.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/payment_option_tile.dart';

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
                            'Earn ${PointsHelper(ref: ref).determinePointsMultipleText(isJusCard: false)} per \$1'),
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
                    icon: CupertinoIcons.gift,
                    title: 'Add jüs card',
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Turn your gift card into a jüs card.'),
                        user.uid == null
                            ? const GuestSignUpText()
                            : Text(
                                'Earn ${PointsHelper(ref: ref).determinePointsMultipleText(isJusCard: true)} per \$1'),
                      ],
                    ),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      PaymentsServices(
                              context: context,
                              ref: ref,
                              userID: user.uid,
                              firstName: user.firstName)
                          .initSquareGiftCardPayment();
                      Navigator.pop(context);
                    },
                  ),
                  JusDivider().thin(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
