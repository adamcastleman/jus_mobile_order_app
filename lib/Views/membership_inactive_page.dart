import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/extensions.dart';
import 'package:jus_mobile_order_app/Helpers/formatters.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/subscription_invoice_model.dart';
import 'package:jus_mobile_order_app/Models/subscription_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Views/checkout_page_membership.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/reactivate_membership_dialog.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';
import 'package:jus_mobile_order_app/constants.dart';
import 'package:jus_mobile_order_app/errors.dart';

class MembershipInactivePage extends ConsumerWidget {
  final bool isDrawerOpen;
  final int monthlyBillingAnchorDate;
  final SubscriptionModel subscriptionData;
  final List<SubscriptionInvoiceModel> invoices;
  final PaymentsModel cardOnFile;
  final List<PaymentsModel> creditCards;
  const MembershipInactivePage(
      {required this.isDrawerOpen,
      required this.monthlyBillingAnchorDate,
      required this.subscriptionData,
      required this.invoices,
      required this.cardOnFile,
      required this.creditCards,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(
        top: isDrawerOpen ? 8.0 : 50.0,
        left: 12.0,
        right: 12.0,
        bottom: 50.0,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Stretch column items horizontally
        children: [
          SheetHeader(
            title: 'Membership',
            showCloseButton: !isDrawerOpen,
          ),
          Expanded(
            // Expanded to center the text widgets vertically
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your subscription is ${SubscriptionStatusFormatter.format(user.subscriptionStatus!.name).uncapitalize}.',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Spacing.vertical(4),
                user.subscriptionStatus! == SubscriptionStatus.paused
                    ? const Text(
                        'This typically occurs when your latest payment has failed. You may need to update your payment method.',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      )
                    : const Text(
                        'You are no longer being charged.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ],
            ),
          ),
          LargeElevatedButton(
            buttonText: 'Reactivate Membership',
            onPressed: () {
              _reactivateMembershipOnTap(context, ref, user);
            },
          ),
        ],
      ),
    );
  }

  _reactivateMembershipOnTap(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) {
    if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
      NavigationHelpers.navigateToPartScreenSheet(
          context,
          InvalidSheetSinglePop(
              error: ErrorMessage.inAppMembershipReactivationDisclaimer));
    } else if (user.subscriptionStatus! == SubscriptionStatus.paused) {
      NavigationHelpers.showDialogWeb(
        height: 450,
        context,
        ReactivateMembershipDialog(
          ref: ref,
          subscriptionData: subscriptionData,
          monthlyBillingAnchorDate: monthlyBillingAnchorDate,
          invoice: invoices[0],
          cardOnFile: cardOnFile,
          creditCards: creditCards,
        ),
      );
    } else {
      NavigationHelpers.navigateToFullScreenSheetOrEndDrawer(context, ref,
          AppConstants.scaffoldKey, const MembershipCheckoutPage());
    }
  }
}