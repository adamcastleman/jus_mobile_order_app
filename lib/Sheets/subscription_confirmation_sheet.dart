import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Hooks/confetti_controller.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/display_images_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/membership_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_call_to_action.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/constants.dart';

class SubscriptionConfirmationSheet extends HookConsumerWidget {
  const SubscriptionConfirmationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useConfettiController();

    final isTabletOrSmaller =
        MediaQuery.of(context).size.width <= AppConstants.tabletWidth;

    final chargedAmount = ref.watch(selectedMembershipPlanPriceProvider);
    final selectedMembershipPlan = ref.watch(selectedMembershipPlanProvider);
    String billingPeriod = selectedMembershipPlan == MembershipPlan.daily
        ? 'day'
        : selectedMembershipPlan == MembershipPlan.annual
            ? 'year'
            : 'month';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loadingProvider.notifier).state = false;
      ref.read(applePayLoadingProvider.notifier).state = false;
    });

    if (isTabletOrSmaller) {
      _displayConfettiAnimation(controller);
    }
    if (isTabletOrSmaller) {
      return _mobileLayout(
          context, ref, controller, chargedAmount ?? 0, billingPeriod);
    } else {
      return _webLayout(context, ref, chargedAmount ?? 0, billingPeriod);
    }
  }

  Widget _mobileLayout(
      BuildContext context,
      WidgetRef ref,
      ConfettiController controller,
      double chargedAmount,
      String billingPeriod) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      color: ref.watch(backgroundColorProvider),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppConstants.mobilePhoneWidth),
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                primary: false,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: JusCloseButton(
                      removePadding: true,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _invalidateSubscriptionProviders(ref);
                        NavigationHelpers.navigateToHomePage(ref);
                      },
                    ),
                  ),
                  const Center(
                    child: Icon(
                      CupertinoIcons.checkmark_circle,
                      color: Colors.black,
                      size: 100,
                    ),
                  ),
                  _subscriptionTotalCostDisplay(chargedAmount, billingPeriod),
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: controller,
                    shouldLoop: false,
                    blastDirection: 3.14,
                    blastDirectionality: BlastDirectionality.explosive,
                    maxBlastForce: 30,
                    numberOfParticles: 50,
                    gravity: 0.5,
                    colors: const [
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _webLayout(BuildContext context, WidgetRef ref, double chargedAmount,
      String billingPeriod) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final pastelTan = ref.watch(pastelTanProvider);
    return DisplayImagesProviderWidget(
      builder: (images) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: pastelTan,
            height: double.infinity,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 600,
                    maxWidth: 600,
                  ),
                  child: CallToActionBanner(
                    backgroundColor: pastelTan,
                    imagePath: images['images'][25]['url'],
                    title: 'Welcome to Membership',
                    description: 'Start enjoying your exclusive perks today',
                    callToActionText: 'Close',
                    callToActionOnPressed: () {
                      _invalidateSubscriptionProviders(ref);

                      NavigationHelpers.navigateToHomePage(ref);
                      Navigator.pop(context);
                    },
                  ).buildMobileLayout(context),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: double.infinity,
            color: backgroundColor,
            child: Center(
              // Center horizontally
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: double.infinity,
                    maxWidth: 400, // Set your max width here
                  ),
                  child: _subscriptionTotalCostDisplay(
                      chargedAmount, billingPeriod),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subscriptionTotalCostDisplay(
      double chargedAmount, String billingPeriod) {
    TextStyle style =
        const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    return Column(
      children: [
        const CategoryWidget(text: 'Subscription'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: style,
            ),
            Text(
              '\$${PricingHelpers.formatAsCurrency(chargedAmount)}/$billingPeriod',
              style: style,
            ),
          ],
        ),
      ],
    );
  }

  void _invalidateSubscriptionProviders(WidgetRef ref) {
    ref.invalidate(selectedMembershipPlanPriceProvider);
    ref.invalidate(selectedMembershipPlanProvider);
  }

  void _displayConfettiAnimation(ConfettiController controller) {
    Future.delayed(
      const Duration(milliseconds: 150),
      () {
        if (controller.state == ConfettiControllerState.playing) {
          controller.stop();
          controller.play();
        } else {
          controller.play();
        }
      },
    );
  }
}
