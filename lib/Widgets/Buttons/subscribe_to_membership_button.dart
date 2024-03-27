import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/payments.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/membership_providers.dart';
import 'package:jus_mobile_order_app/Services/subscription_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

class SubscribeToMembershipButton extends ConsumerWidget {
  final UserModel user;
  final PaymentsModel creditCard;
  const SubscribeToMembershipButton(
      {required this.user, required this.creditCard, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chargedAmount = ref.watch(selectedMembershipPlanPriceProvider);
    final selectedMembershipPlan = ref.watch(selectedMembershipPlanProvider);
    final isDisclaimerBoxChecked =
        ref.watch(membershipDisclaimerCheckboxValueProvider);
    String duration =
        selectedMembershipPlan == MembershipPlan.annual ? 'yr' : 'mo';
    String billingPeriod =
        selectedMembershipPlan == MembershipPlan.annual ? 'year' : 'month';

    return LargeElevatedButton(
        buttonText:
            'Subscribe for \$${PricingHelpers.formatAsCurrency(chargedAmount ?? 0)}/$duration',
        onPressed: () {
          if (!isDisclaimerBoxChecked) {
            ErrorHelpers.showSinglePopError(context,
                error:
                    "You must agree to the 'Membership Terms of Service' before signing up");
            return;
          }
          HapticFeedback.lightImpact();
          ref.read(loadingProvider.notifier).state = true;
          SubscriptionServices.createSubscription(
            orderDetails: {
              'squareCustomerId': user.squareCustomerId,
              'billingPeriod': billingPeriod,
              'startDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
              'cardId': creditCard.cardId,
              'sourceId': 'digital',
            },
            onPaymentSuccess: () {
              HapticFeedback.lightImpact();
              invalidateLoadingProviders(ref);
              PaymentsHelpers.showPaymentSuccessModal(context);
            },
            onError: (error) {
              invalidateLoadingProviders(ref);
              PaymentsHelpers.showPaymentErrorModal(context, ref, error);
            },
          );
        });
  }
}
