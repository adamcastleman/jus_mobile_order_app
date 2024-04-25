import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/subscription_invoice_model.dart';
import 'package:jus_mobile_order_app/Models/subscription_model.dart';
import 'package:jus_mobile_order_app/Providers/membership_providers.dart';
import 'package:jus_mobile_order_app/Services/subscription_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large_loading.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/subscription_invoice_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/update_subscription_payment_method_tile.dart';

class ReactivateMembershipDialog extends ConsumerWidget {
  final SubscriptionModel subscriptionData;
  final int monthlyBillingAnchorDate;
  final SubscriptionInvoiceModel invoice;
  final PaymentsModel cardOnFile;
  final List<PaymentsModel> creditCards;

  const ReactivateMembershipDialog(
      {required this.subscriptionData,
      required this.monthlyBillingAnchorDate,
      required this.invoice,
      required this.cardOnFile,
      required this.creditCards,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(updateMembershipLoadingProvider);
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacing.vertical(10),
          Column(
            children: [
              const CategoryWidget(text: 'Subscription Details'),
              SubscriptionInvoiceTile(
                invoice: invoice,
                showTrailingDate: false,
              ),
              Spacing.vertical(25),
              const CategoryWidget(text: 'Payment Method'),
              UpdateSubscriptionPaymentMethodTile(
                subscriptionData: subscriptionData,
                creditCards: creditCards,
                cardOnFile: cardOnFile,
              ),
              JusDivider.thin(),
            ],
          ),
          Spacing.vertical(12),
          Text(
            'You will be charged today, and then on a recurring basis on (or very near) the ${Time().ordinal(monthlyBillingAnchorDate)} of each billing period, until you cancel.',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacing.vertical(12),
          loading == true
              ? const LargeElevatedLoadingButton()
              : LargeElevatedButton(
                  buttonText: 'Resume Membership',
                  onPressed: () async {
                    // ref.read(updateMembershipLoadingProvider.notifier).state =
                    //     true;
                    await SubscriptionServices()
                        .resumeSquareSubscriptionCloudFunction();
                    // Navigator.pop(context);
                    // ref.invalidate(updateMembershipLoadingProvider);
                  },
                ),
        ],
      ),
    );
  }
}
