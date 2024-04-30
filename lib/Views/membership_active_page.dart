import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/formatters.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/subscription_invoice_model.dart';
import 'package:jus_mobile_order_app/Models/subscription_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/membership_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Services/subscription_services.dart';
import 'package:jus_mobile_order_app/Sheets/cancel_membership_confirmation_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outlined_button_square_large.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/subscription_invoice_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/update_subscription_payment_method_tile.dart';

class MembershipActivePage extends ConsumerWidget {
  final bool isDrawerOpen;
  final DateTime startDate;
  final DateTime? chargeThruDate;
  final SubscriptionModel subscriptionData;
  final List<SubscriptionInvoiceModel> invoices;
  final PaymentsModel cardOnFile;
  final List<PaymentsModel> creditCards;
  const MembershipActivePage(
      {required this.isDrawerOpen,
      required this.startDate,
      this.chargeThruDate,
      required this.subscriptionData,
      required this.invoices,
      required this.cardOnFile,
      required this.creditCards,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final backgroundColor = ref.watch(backgroundColorProvider);
    const trailingStyle = TextStyle(fontSize: 16);
    String formattedStartDate = DateFormat('M/d/yyyy').format(startDate);
    String? formattedChargeThruDate = chargeThruDate == null
        ? ''
        : DateFormat('M/d/yyyy').format(chargeThruDate ?? DateTime.now());

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(
        top: isDrawerOpen == true ? 8.0 : 50.0,
        left: 12.0,
        right: 12.0,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                children: [
                  SheetHeader(
                    title: 'Membership',
                    showCloseButton: isDrawerOpen == true ? false : true,
                  ),
                  Spacing.vertical(15),
                  const CategoryWidget(text: 'Subscription Details'),
                  ListTile(
                    leading: Icon(_displayStatusIcon(user.subscriptionStatus!)),
                    title: const Text('Status'),
                    trailing: Text(
                        SubscriptionStatusFormatter.format(
                            user.subscriptionStatus!.name),
                        style: trailingStyle),
                  ),
                  _buildStartDateListTile(
                      user, formattedStartDate, trailingStyle),
                  chargeThruDate == null || startDate.isBefore(DateTime.now())
                      ? ListTile(
                          leading: const Icon(CupertinoIcons.calendar),
                          title: user.subscriptionStatus! ==
                                  SubscriptionStatus.pendingCancel
                              ? const Text('Cancel date')
                              : const Text('Next billing date'),
                          trailing: Text(formattedChargeThruDate,
                              style: trailingStyle),
                        )
                      : const SizedBox(),
                  Spacing.vertical(10),
                  user.subscriptionStatus! == SubscriptionStatus.pendingCancel
                      ? Column(
                          children: [
                            Spacing.vertical(10),
                            const Text(
                              'You can still use this membership until the end of the current billing cycle',
                              textAlign: TextAlign.center,
                            ),
                            Spacing.vertical(10),
                            LargeOutlineSquareButton(
                              buttonText: 'Reinstate Membership',
                              onPressed: () async {
                                ref
                                    .read(updateMembershipLoadingProvider
                                        .notifier)
                                    .state = true;
                                await SubscriptionServices()
                                    .undoCancelSquareSubscriptionCloudFunction();
                                ref.invalidate(updateMembershipLoadingProvider);
                              },
                            ),
                            Spacing.vertical(25),
                          ],
                        )
                      : LargeOutlineSquareButton(
                          buttonText: 'Cancel Membership',
                          onPressed: () {
                            NavigationHelpers.navigateToPartScreenSheetOrDialog(
                              context,
                              CancelMembershipConfirmationSheet(
                                ref: ref,
                              ),
                            );
                          },
                        ),
                  Spacing.vertical(25),
                  const CategoryWidget(text: 'Your Benefits'),
                  ListTile(
                    leading: const Icon(CupertinoIcons.money_dollar_circle),
                    title: const Text('Total savings'),
                    trailing: Text('\$${subscriptionData.totalSaved ?? 0}',
                        style: trailingStyle),
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.gift),
                    title: const Text('Bonus points'),
                    trailing: Text('${subscriptionData.bonusPoints ?? 0}',
                        style: trailingStyle),
                  ),
                  Spacing.vertical(25),
                  const CategoryWidget(text: 'Payment Method'),
                  UpdateSubscriptionPaymentMethodTile(
                    subscriptionData: subscriptionData,
                    creditCards: creditCards,
                    cardOnFile: cardOnFile,
                  ),
                  Spacing.vertical(25),
                  const CategoryWidget(text: 'Subscription Payments'),
                  ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: invoices.length,
                    separatorBuilder: (context, index) => JusDivider.thin(),
                    itemBuilder: (context, index) {
                      return SubscriptionInvoiceTile(invoice: invoices[index]);
                    },
                  ),
                  const Text('We show up to 10 billing cycles.'),
                  // Spacing.vertical(15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartDateListTile(
      UserModel user, String formattedStartDate, TextStyle trailingStyle) {
    // Check if startDate is before now and status is pendingCancel
    if (startDate.isBefore(DateTime.now()) &&
        user.subscriptionStatus == SubscriptionStatus.pendingCancel) {
      return const SizedBox();
    }

    IconData leadingIcon = startDate.isBefore(DateTime.now())
        ? CupertinoIcons.clock
        : CupertinoIcons.calendar;
    String titleText;

    if (user.subscriptionStatus == SubscriptionStatus.pendingCancel) {
      titleText = 'Cancel date';
    } else if (startDate.isBefore(DateTime.now())) {
      titleText = 'Member since';
    } else {
      titleText = 'Next billing date';
    }

    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(titleText),
      trailing: Text(formattedStartDate, style: trailingStyle),
    );
  }

  IconData _displayStatusIcon(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return CupertinoIcons.check_mark_circled;
      case SubscriptionStatus.pendingCancel:
        return CupertinoIcons.check_mark_circled;
      case SubscriptionStatus.paused:
        return CupertinoIcons.pause_circle;
      case SubscriptionStatus.canceled:
        return CupertinoIcons.minus_circle;
      default:
        return CupertinoIcons.exclamationmark_circle;
    }
  }
}
