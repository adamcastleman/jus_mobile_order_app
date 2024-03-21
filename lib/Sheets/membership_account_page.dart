import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/card_details_from_square_card_id_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/square_subscription_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/subscription_data_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Sheets/select_credit_card_for_wallet_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';

class MembershipAccountPage extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MembershipAccountPage({required this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDrawerOpen = scaffoldKey.currentState?.isEndDrawerOpen;
    final user = ref.watch(currentUserProvider).value ?? const UserModel();

    return CreditCardProviderWidget(
      builder: (creditCards) => SubscriptionDataProviderWidget(
        builder: (subscriptionData) =>
            CardDetailsFromSquareCardIdProviderWidget(
          cardId: subscriptionData.cardId,
          builder: (card) => SquareSubscriptionProviderWidget(
            subscriptionId: subscriptionData.subscriptionId,
            builder: (subscription) {
              DateTime startDate =
                  DateFormat('yyyy-MM-dd').parse(subscription.startDate);
              String formattedStartDate =
                  DateFormat('M/d/yyyy').format(startDate);
              return Padding(
                padding: EdgeInsets.only(
                  top: isDrawerOpen == true ? 8.0 : 40.0,
                  left: 12.0,
                  right: 12.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SheetHeader(
                          title: 'Membership',
                          showCloseButton: isDrawerOpen == null || isDrawerOpen
                              ? false
                              : true),
                      Spacing.vertical(25),
                      const CategoryWidget(text: 'Subscription Details'),
                      ListTile(
                        leading: startDate.isBefore(DateTime.now())
                            ? const Icon(CupertinoIcons.clock)
                            : const Icon(CupertinoIcons.calendar),
                        title: startDate.isBefore(DateTime.now())
                            ? const Text('Start date')
                            : const Text('Next billing date'),
                        trailing: Text(formattedStartDate),
                      ),
                      startDate.isBefore(DateTime.now())
                          ? ListTile(
                              leading: const Icon(CupertinoIcons.calendar),
                              title: const Text('Next billing date'),
                              trailing: Text(formattedStartDate),
                            )
                          : const SizedBox(),
                      Spacing.vertical(15),
                      const CategoryWidget(text: 'Your Benefits'),
                      ListTile(
                        leading: const Icon(CupertinoIcons.money_dollar_circle),
                        title: const Text('Total savings'),
                        trailing: Text('\$${subscriptionData.totalSaved ?? 0}'),
                      ),
                      ListTile(
                        leading: const Icon(CupertinoIcons.gift),
                        title: const Text('Bonus points'),
                        trailing: Text('${subscriptionData.bonusPoints ?? 0}'),
                      ),
                      Spacing.vertical(15),
                      const CategoryWidget(text: 'Payment Method'),
                      ListTile(
                        leading: const Icon(CupertinoIcons.creditcard),
                        title: Text('${card.cardNickname} x${card.last4}'),
                        trailing: _updatePaymentMethodButton(context, ref, user,
                            creditCards, subscriptionData.subscriptionId),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
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
          NavigationHelpers.navigateToPartScreenSheetOrDialog(
            context,
            SelectCreditCardOnlySheet(
              creditCards: creditCards,
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
              color: Colors.blue,
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue),
        ),
      );
    }
  }
}
