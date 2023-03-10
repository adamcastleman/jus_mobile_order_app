import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/credit_card_name_widget.dart';

class CurrentPaymentTile extends ConsumerWidget {
  final bool isScanPage;
  const CurrentPaymentTile({required this.isScanPage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final paymentMethod = ref.watch(savedCreditCardsProvider);
    return currentUser.when(
      loading: () => const ListTile(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (user) => paymentMethod.when(
        loading: () => const ListTile(),
        error: (e, _) => ShowError(
          error: e.toString(),
        ),
        data: (card) {
          return ListTile(
            leading: const Icon(CupertinoIcons.creditcard),
            title: CreditCardName(
              isPayButton: false,
              isScanPage: isScanPage,
            ),
            trailing: const Icon(
              CupertinoIcons.chevron_right,
              size: 14,
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              PaymentsHelpers(ref: ref).determinePaymentSheet(
                  context: context, isCheckoutButton: false);
            },
          );
        },
      ),
    );
  }
}
