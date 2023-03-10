import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/points.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';

class ChoosePaymentTypeSheet extends ConsumerWidget {
  const ChoosePaymentTypeSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final pointsDetails = ref.watch(pointsDetailsProvider);
    return pointsDetails.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (points) => currentUser.when(
        error: (e, _) => ShowError(error: e.toString()),
        loading: () => const Loading(),
        data: (user) => Wrap(
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
                  ListTile(
                    leading: const Icon(CupertinoIcons.creditcard),
                    title: const Text(
                      'Add credit card',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: user.uid == null
                        ? guestSignUpText()
                        : Text(
                            'Earn ${PointsHelper(ref: ref).determinePointsMultipleText(isJusCard: ref.watch(selectedCreditCardProvider)['isGiftCard'] ?? false)} per \$1'),
                    trailing: const Icon(
                      CupertinoIcons.chevron_right,
                      size: 15,
                    ),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      PaymentsServices(
                              context: context,
                              ref: ref,
                              uid: user.uid,
                              firstName: user.firstName)
                          .initSquarePayment();
                    },
                  ),
                  JusDivider().thin(),
                  ListTile(
                    leading: const Icon(CupertinoIcons.gift),
                    title: const Text(
                      'Add jüs card',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Turn your gift card into a jüs card.'),
                        user.uid == null
                            ? guestSignUpText()
                            : Text(
                                'Earn ${PointsHelper(ref: ref).determinePointsMultipleText(isJusCard: ref.watch(selectedCreditCardProvider)['isGiftCard'] ?? false)} per \$1'),
                      ],
                    ),
                    trailing: const Icon(
                      CupertinoIcons.chevron_right,
                      size: 15,
                    ),
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      PaymentsServices(
                              context: context,
                              ref: ref,
                              uid: user.uid,
                              firstName: user.firstName)
                          .initSquareGiftCardPayment();
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

  guestSignUpText() {
    return const Text(
        'Sign up to collect points. Redeem points for free items');
  }
}
