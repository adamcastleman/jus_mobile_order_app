import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/display_images_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_bulleted_list.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_call_to_action.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_rewards.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_stepper.dart';
import 'package:jus_mobile_order_app/Widgets/General/web_footer_banner.dart';

class PointsInformationPage extends ConsumerWidget {
  final bool showCloseButton;
  const PointsInformationPage({required this.showCloseButton, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final points = ref.watch(pointsInformationProvider);
    final pastelBrown = ref.watch(pastelBrownProvider);
    final backgroundColor = ref.watch(backgroundColorProvider);
    return DisplayImagesProviderWidget(
      builder: (images) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0.0,
            scrolledUnderElevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: const SizedBox(),
            actions: [
              showCloseButton
                  ? const JusCloseButton(
                      color: Colors.grey,
                    )
                  : const SizedBox(),
            ],
          ),
          body: user.uid == null
              ? pointsInformationGuest(
                  context, ref, user, points, images, pastelBrown)
              : pointsInformationUser(context, ref, user, points, images,
                  backgroundColor, pastelBrown),
        );
      },
    );
  }

  pointsInformationUser(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
    PointsDetailsModel points,
    dynamic images,
    Color backgroundColor,
    Color pastelBrown,
  ) {
    return Container(
      color: backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _rewardAmounts(context, ref, user, images, points, pastelBrown),
            _thePerksRewardsBanner(points),
          ],
        ),
      ),
    );
  }

  pointsInformationGuest(BuildContext context, WidgetRef ref, UserModel user,
      PointsDetailsModel points, dynamic images, Color pastelBrown) {
    final pastelBlue = ref.watch(pastelBlueProvider);
    final pastelPurple = ref.watch(pastelPurpleProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: const SizedBox(),
        actions: [
          showCloseButton
              ? const JusCloseButton(
                  color: Colors.grey,
                )
              : const SizedBox(),
        ],
      ),
      body: SingleChildScrollView(
        primary: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CallToActionBanner(
              imagePath: images['images'][2]['url'],
              backgroundColor: pastelPurple,
              callToActionText: 'Sign up',
              callToActionOnPressed: () {
                HapticFeedback.lightImpact();
                NavigationHelpers.navigateToRegisterPage(context);
              },
              titleMaxLines: 1,
              title: 'Points & Rewards',
              description: '${points.perks[0]['description']}',
            ),
            _thePerksRewardsBanner(points),
            _rewardAmounts(context, ref, user, images, points, pastelBrown),
            WebBannerStepper(
              backgroundColor: Colors.white,
              bannerTitle: 'How Rewards Work',
              bannerSubtitle: '',
              steps: [
                StepItem(
                    title: 'Sign Up',
                    description:
                        'Create an account to start earning points as you spend.'),
                StepItem(
                    title: 'Order in-store or online',
                    description:
                        'Scan your points code in-store, or to save time, order through the app. You\'ll get your perks all along the way.'),
                StepItem(
                    title: 'Get free stuff',
                    description: 'Redeem your points for free items.'),
              ],
            ),
            CallToActionBanner(
              imagePath: images['images'][23]['url'],
              backgroundColor: pastelBlue,
              callToActionText: 'Learn More',
              callToActionOnPressed: () {
                HapticFeedback.lightImpact();
                NavigationHelpers.handleMembershipNavigation(
                  context,
                  ref,
                  user,
                  showCloseButton:
                      PlatformUtils.isIOS() || PlatformUtils.isAndroid(),
                );
              },
              titleMaxLines: 1,
              title: 'It pays to be a Member',
              description: '${points.perks[2]['description']}',
            ),
            Spacing.vertical(30),
            PlatformUtils.isIOS() || PlatformUtils.isAndroid()
                ? const SizedBox()
                : const WebFooterBanner(),
          ],
        ),
      ),
    );
  }

  Widget _thePerksRewardsBanner(PointsDetailsModel points) {
    return WebBulletListBanner(
      backgroundColor: Colors.white,
      bannerTitle: 'The Perks',
      firstColumnBulletTitle: 'Earnings tiers:',
      firstColumnBulletItems: [
        '${points.perks[1]['name']}.',
        '${points.perks[2]['name']}.',
        '${points.perks[3]['description']}'
      ],
      secondColumnBulletTitle: 'Even more benefits:',
      secondColumnBulletItems: const [
        'Check the app for bonus points promotions',
        'Earn points using cash or card.',
        'Additional discounts dropped throughout the year.'
      ],
    );
  }

  Widget _rewardAmounts(BuildContext context, WidgetRef ref, UserModel user,
      dynamic images, PointsDetailsModel points, Color pastelBrown) {
    return Column(
      children: [
        WebRewardsBanner(
          images: [
            images['images'][15]['url'],
            images['images'][16]['url'],
            images['images'][17]['url'],
            images['images'][18]['url'],
            images['images'][19]['url'],
            images['images'][20]['url'],
          ],
          backgroundColor: pastelBrown,
          points: points,
          title: '${points.perks[0]['name']}',
          titleMaxLines: 1,
          description: 'Save up your points and redeem them for free items',
          descriptionMaxLines: 2,
          callToActionText:
              user.uid == null || user.uid!.isEmpty ? 'Sign Up' : 'Order Now',
          callToActionOnPressed: () {
            if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
              Navigator.pop(context);
              if (ref.watch(isCheckOutPageProvider) == true) {
                Navigator.pop(context);
              }
            }

            user.uid == null || user.uid!.isEmpty
                ? NavigationHelpers.navigateToRegisterPage(context)
                : NavigationHelpers().navigateToMenuPage(context, ref);
          },
        ),
      ],
    );
  }
}
