import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/card_details_from_square_card_id_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/square_subscription_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/subscription_data_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/subscription_invoice_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/membership_active_page.dart';
import 'package:jus_mobile_order_app/Views/membership_inactive_page.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';

class MembershipAccountPage extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MembershipAccountPage({required this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final backgroundColor = ref.watch(backgroundColorProvider);
    final bool isDrawerOpen =
        scaffoldKey.currentState?.isEndDrawerOpen ?? false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: ResponsiveLayout.isMobileBrowser(context) ? 40 : 0,
          color: backgroundColor,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: SheetHeader(
            title: 'Membership',
            showCloseButton: !isDrawerOpen,
          ),
        ),
        Container(
          height: 10,
          color: backgroundColor,
        ),
        Expanded(
          // Makes the below content scrollable and flexible
          child: Container(
            color: backgroundColor,
            child: Center(
              child: CreditCardProviderWidget(
                builder: (creditCards) => SubscriptionDataProviderWidget(
                  builder: (subscriptionData) =>
                      SubscriptionInvoiceProviderWidget(
                    squareCustomerId: user.squareCustomerId ?? '',
                    builder: (invoices) =>
                        CardDetailsFromSquareCardIdProviderWidget(
                      cardId: subscriptionData.cardId,
                      builder: (cardOnFile) => SquareSubscriptionProviderWidget(
                        subscriptionId: subscriptionData.subscriptionId,
                        builder: (subscription) {
                          DateTime startDate =
                              DateTime.parse(subscription.startDate);
                          DateTime? chargeThruDate =
                              subscription.chargeThruDate.isEmpty
                                  ? null
                                  : DateTime.parse(subscription.chargeThruDate);
                          int anchorDate =
                              subscription.monthlyBillingAnchorDate == 0 ||
                                      subscription.monthlyBillingAnchorDate ==
                                          null
                                  ? startDate.day
                                  : subscription.monthlyBillingAnchorDate!;
                          if (user.subscriptionStatus!.isActive) {
                            return Container(
                              color: backgroundColor,
                              child: MembershipActivePage(
                                isDrawerOpen: isDrawerOpen,
                                startDate: startDate,
                                chargeThruDate: chargeThruDate,
                                subscriptionData: subscriptionData,
                                invoices: invoices,
                                cardOnFile: cardOnFile,
                                creditCards: creditCards,
                              ),
                            );
                          } else {
                            return Container(
                              color: backgroundColor,
                              child: MembershipInactivePage(
                                ref: ref,
                                isDrawerOpen: isDrawerOpen,
                                subscriptionData: subscriptionData,
                                monthlyBillingAnchorDate: anchorDate,
                                invoices: invoices,
                                cardOnFile: cardOnFile,
                                creditCards: creditCards,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
