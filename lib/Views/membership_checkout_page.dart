import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/extensions.dart';
import 'package:jus_mobile_order_app/Helpers/payment_methods.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/membership_details_model.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/membership_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/membership_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/login_page.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/membership_terms_of_service_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/subscribe_to_membership_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/default_payment_tile.dart';
import 'package:jus_mobile_order_app/constants.dart';

class MembershipCheckoutPage extends ConsumerWidget {
  const MembershipCheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final selectedPlanColor = ref.watch(forestGreenProvider);
    final selectedMembershipPlan = ref.watch(selectedMembershipPlanProvider);
    final selectedSubscriptionPrice =
        ref.watch(selectedMembershipPlanPriceProvider);
    final selectedCreditCard = ref.watch(selectedCreditCardProvider);
    final tileKey = UniqueKey();
    final isDisclaimerChecked =
        ref.watch(membershipDisclaimerCheckboxValueProvider);
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    if (user.uid == null) {
      return const Center(
        child: LoginPage(),
      );
    }
    return MembershipDetailsProviderWidget(
      builder: (membershipDetails) => CreditCardProviderWidget(
        builder: (creditCards) {
          _updateSelectedCreditCardIfNecessary(
              ref, creditCards, selectedCreditCard);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (selectedSubscriptionPrice == null) {
              ref.read(selectedMembershipPlanPriceProvider.notifier).state =
                  membershipDetails.subscriptionPrice[0]['amount'] / 100;
            }
          });
          return Scaffold(
            body: Container(
              padding: EdgeInsets.only(
                top: PlatformUtils.isWeb() ? 8.0 : 50.0,
                left: 12.0,
                right: 12.0,
                bottom: 25.0,
              ),
              color: backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SheetHeader(
                    title: 'Subscribe to Membership',
                    showCloseButton: false,
                  ),
                  Column(
                    children: [
                      const CategoryWidget(text: 'Membership plan'),
                      ..._membershipPlanCheckbox(ref, membershipDetails,
                          selectedMembershipPlan, selectedPlanColor),
                    ],
                  ),
                  Column(
                    children: [
                      const CategoryWidget(text: 'Payment Method'),
                      _determinePaymentTile(
                          context, ref, user, creditCards, tileKey),
                      JusDivider.thin(),
                      _membershipAgreementCheckbox(ref, isDisclaimerChecked),
                    ],
                  ),
                  SubscribeToMembershipButton(
                    user: user,
                    creditCard: selectedCreditCard,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _updateSelectedCreditCardIfNecessary(WidgetRef ref,
      List<PaymentsModel> creditCards, PaymentsModel selectedCreditCard) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (selectedCreditCard.cardId == null ||
            selectedCreditCard.cardId!.isEmpty) {
          ref.read(selectedCreditCardProvider.notifier).state = PaymentsModel(
            userId: creditCards.first.userId,
            brand: creditCards.first.brand,
            last4: creditCards.first.last4,
            defaultPayment: creditCards.first.defaultPayment,
            cardNickname: creditCards.first.cardNickname,
            isWallet: creditCards.first.isWallet,
            cardId: creditCards.first.cardId,
          );
        }
      },
    );
  }

  List<Widget> _membershipPlanCheckbox(
      WidgetRef ref,
      MembershipDetailsModel membershipDetails,
      MembershipPlan selectedMembershipPlan,
      Color selectedPlanColor) {
    return List.generate(MembershipPlan.values.length, (index) {
      bool isPlanSelected =
          selectedMembershipPlan == MembershipPlan.values[index];
      double subscriptionPrice =
          membershipDetails.subscriptionPrice[index]['amount'] / 100;
      bool isDailyPlan = MembershipPlan.values[index] == MembershipPlan.daily;
      bool isAnnualPlan = MembershipPlan.values[index] == MembershipPlan.annual;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Card(
          elevation: 0.0,
          color: isPlanSelected ? selectedPlanColor : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: CheckboxListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 22.0),
            title: Text(
              MembershipPlan.values[index].name.capitalize,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isPlanSelected ? Colors.white : Colors.black),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    isDailyPlan
                        ? '\$${PricingHelpers.formatAsCurrency(subscriptionPrice)}/day'
                        : isAnnualPlan
                            ? '\$${PricingHelpers.formatAsCurrency(subscriptionPrice / 12)}/mo'
                            : '\$${PricingHelpers.formatAsCurrency(subscriptionPrice)}/mo',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isPlanSelected ? Colors.white : Colors.black),
                  ),
                ),
                Text(
                    _subscriptionDescriptionText(
                        membershipDetails.subscriptionPrice[index]),
                    style: TextStyle(
                        color: isPlanSelected ? Colors.white : Colors.black)),
              ],
            ),
            value: isPlanSelected,
            checkColor: selectedPlanColor,
            activeColor: Colors.white,
            onChanged: (value) {
              if (value != null && value) {
                ref.read(selectedMembershipPlanPriceProvider.notifier).state =
                    subscriptionPrice;
                ref.read(selectedMembershipPlanProvider.notifier).state =
                    MembershipPlan.values[index];
              }
            },
          ),
        ),
      );
    });
  }

  String _subscriptionDescriptionText(dynamic membershipDetails) {
    if (membershipDetails['name'] == MembershipPlan.daily.name) {
      return 'Test with this setup, as it renews daily, the shortest available cadence';
    } else if (membershipDetails['name'] == MembershipPlan.annual.name) {
      return 'Billed at \$${PricingHelpers.formatAsCurrency(membershipDetails['amount'] / 100)} per year, and auto-renews until canceled';
    } else {
      return 'Auto-renews at \$${PricingHelpers.formatAsCurrency(membershipDetails['amount'] / 100)} per month until canceled';
    }
  }

  _membershipAgreementCheckbox(WidgetRef ref, bool isDisclaimerChecked) {
    return CheckboxListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 22.0),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: AppConstants.membershipDisclaimerText,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              const WidgetSpan(
                child: MembershipTermsOfServiceButton(),
              ),
            ],
          ),
        ),
        value: isDisclaimerChecked,
        onChanged: (value) {
          ref.read(membershipDisclaimerCheckboxValueProvider.notifier).state =
              value!;
        });
  }

  _determinePaymentTile(BuildContext context, WidgetRef ref, UserModel user,
      List<PaymentsModel> creditCards, UniqueKey tileKey) {
    if (creditCards.isEmpty) {
      return AddPaymentMethodTile(
        tileKey: tileKey,
        isWallet: false,
        isTransfer: false,
        title: 'Add Payment Method',
        onTap: () {
          ref.read(tileKeyProvider.notifier).state = tileKey;
          PaymentMethodHelpers().addCreditCardAsSelectedPayment(
            context,
            ref,
            user,
            onSuccess: () {
              ref.read(squarePaymentSkdLoadingProvider.notifier).state = false;
              if (PlatformUtils.isWeb()) {
                Navigator.pop(context);
              }
            },
          );
        },
      );
    } else {
      return DefaultPaymentTile(creditCards: creditCards);
    }
  }
}
