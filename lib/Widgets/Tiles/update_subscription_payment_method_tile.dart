import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/payment_methods.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/subscription_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Sheets/select_credit_card_for_wallet_sheet.dart';

class UpdateSubscriptionPaymentMethodTile extends ConsumerWidget {
  final SubscriptionModel subscriptionData;
  final List<PaymentsModel> creditCards;
  final PaymentsModel cardOnFile;
  const UpdateSubscriptionPaymentMethodTile(
      {required this.subscriptionData,
      required this.creditCards,
      required this.cardOnFile,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    return ListTile(
      leading: const Icon(CupertinoIcons.creditcard),
      title: Text(
        PaymentMethodHelpers().displaySelectedCardText(cardOnFile),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: _updatePaymentMethodButton(
          context, ref, user, creditCards, subscriptionData.subscriptionId),
    );
  }

  Widget _updatePaymentMethodButton(BuildContext context, WidgetRef ref,
      UserModel user, List<PaymentsModel> creditCards, String subscriptionId) {
    final isCardFormLoading = ref.watch(squarePaymentSkdLoadingProvider);
    if (isCardFormLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: Loading(),
      );
    } else {
      return TextButton(
        onPressed: () {
          ref.read(squarePaymentSkdLoadingProvider.notifier).state = true;
          NavigationHelpers.navigateToFullScreenSheetOrDialog(
            context,
            SelectCreditCardOnlySheet(
              creditCards: creditCards,
              showApplePay: false,
              onCreditCardSelected: () async {
                try {
                  final card = ref.watch(selectedCreditCardProvider);
                  await SquarePaymentServices()
                      .updateSquareSubscriptionPaymentMethod(
                    squareCustomerId: user.squareCustomerId!,
                    cardId: card.cardId!,
                  );
                } catch (e) {
                  throw Exception('There was a problem');
                } finally {
                  ref.read(squarePaymentSkdLoadingProvider.notifier).state =
                      false;
                }
              },
            ),
          );
        },
        child: const Text(
          'Change',
          style: TextStyle(
            color: Colors.black,
            decoration: TextDecoration.underline,
          ),
        ),
      );
    }
  }
}
