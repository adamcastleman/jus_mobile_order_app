import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/extensions.dart';
import 'package:jus_mobile_order_app/Helpers/formatters.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/subscriptions.dart';
import 'package:jus_mobile_order_app/Helpers/url_launcher_services.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/subscription_invoice_model.dart';
import 'package:jus_mobile_order_app/Models/subscription_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Views/membership_checkout_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/constants.dart';
import 'package:jus_mobile_order_app/errors.dart';

class MembershipInactivePage extends StatelessWidget {
  final WidgetRef ref;
  final bool isDrawerOpen;
  final int monthlyBillingAnchorDate;
  final SubscriptionModel subscriptionData;
  final List<SubscriptionInvoiceModel> invoices;
  final PaymentsModel cardOnFile;
  final List<PaymentsModel> creditCards;
  const MembershipInactivePage(
      {required this.ref,
      required this.isDrawerOpen,
      required this.monthlyBillingAnchorDate,
      required this.subscriptionData,
      required this.invoices,
      required this.cardOnFile,
      required this.creditCards,
      super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final loading = ref.watch(loadingProvider);
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(
        top: isDrawerOpen ? 8.0 : 0.0,
        left: 12.0,
        right: 12.0,
        bottom: 50.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.center, // Stretch column items horizontally

        children: [
          Text(
            'Your subscription is ${SubscriptionStatusFormatter.format(user.subscriptionStatus!.name).uncapitalize}.',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Spacing.vertical(8),
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
          Spacing.vertical(60),
          loading
              ? const LargeElevatedLoadingButton()
              : LargeElevatedButton(
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
  ) async {
    if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
      NavigationHelpers.navigateToPartScreenSheet(
          context,
          InvalidSheetSinglePop(
              error: ErrorMessage.inAppMembershipReactivationDisclaimer));
    } else if (user.subscriptionStatus! == SubscriptionStatus.paused) {
      ref.read(loadingProvider.notifier).state = true;
      var invoiceId = await SubscriptionHelpers()
          .getUnpaidInvoiceId(user.squareCustomerId!);
      ref.read(loadingProvider.notifier).state = false;
      String url = 'https://squareupsandbox.com/pay-invoice/$invoiceId';
      await UrlLauncherService().payInvoice(context, url);
      NavigationHelpers.popEndDrawer(context);
    } else {
      NavigationHelpers.navigateToFullScreenSheetOrEndDrawer(context, ref,
          AppConstants.scaffoldKey, const MembershipCheckoutPage());
    }
  }
}
