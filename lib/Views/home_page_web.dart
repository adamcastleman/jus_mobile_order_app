import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/display_images_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/membership_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/scan_floating_action_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_call_to_action.dart';
import 'package:jus_mobile_order_app/Widgets/General/web_footer_banner.dart';

class HomePageWeb extends StatelessWidget {
  final WidgetRef ref;
  const HomePageWeb({required this.ref, super.key});

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final points = ref.watch(pointsInformationProvider);
    final pastelBlue = ref.watch(pastelBlueProvider);
    final pastelRed = ref.watch(pastelRedProvider);
    final pastelPurple = ref.watch(pastelPurpleProvider);
    final pastelBrown = ref.watch(pastelBrownProvider);
    return MembershipDetailsProviderWidget(
      builder: (membership) => DisplayImagesProviderWidget(
        builder: (images) => Scaffold(
          floatingActionButton: _showScanFloatingActionButton(context, user),
          body: ListView(
            primary: false,
            children: [
              const Text('Web test version: 2'),
              CallToActionBanner(
                backgroundColor: pastelBlue,
                imagePath: images['images'][11]['url'],
                title: 'Elevate your health.',
                description:
                    'Nutrient-dense juices, smoothies, bowls, and cleanses '
                    'designed to fuel your active, healthy life.',
                callToActionText: 'Order Now',
                callToActionOnPressed: () async {
                  NavigationHelpers().navigateToMenuPage(context, ref);
                },
                titleMaxLines: 1,
                descriptionMaxLines: 3,
              ),
              CallToActionBanner(
                imagePath: images['images'][4]['url'],
                backgroundColor: pastelRed,
                callToActionText: 'Learn More',
                callToActionOnPressed: () {
                  NavigationHelpers.handleMembershipNavigation(
                      context, ref, user);
                },
                titleMaxLines: 1,
                title: 'Membership',
                description:
                    'Members receive exclusive and unlimited access to ${membership.perks[0]['description'].toLowerCase()}',
                isImageOnRight: false,
              ),
              CallToActionBanner(
                imagePath: images['images'][2]['url'],
                backgroundColor: pastelPurple,
                callToActionText: 'Learn More',
                callToActionOnPressed: () {
                  NavigationHelpers.navigateToPointsInformationPage(
                      context, ref);
                },
                titleMaxLines: 1,
                title: 'Points & Rewards',
                description: '${points.perks[0]['description']}',
              ),
              CallToActionBanner(
                imagePath: images['images'][8]['url'],
                backgroundColor: pastelBrown,
                callToActionText: 'Learn More',
                callToActionOnPressed: () {
                  NavigationHelpers.navigateToCleansePageWeb(context, ref);
                },
                titleMaxLines: 1,
                title: 'Cleanses',
                description:
                    'Push a ‘reset’ button on your body. Cleanses rest your digestive system and enrich your body with nutrients from fresh fruits and vegetables.',
                isImageOnRight: false,
              ),
              CallToActionBanner(
                imagePath: images['images'][12]['url'],
                backgroundColor: pastelBlue,
                callToActionText: 'View Map',
                callToActionOnPressed: () {
                  NavigationHelpers().navigateToLocationPage(context, ref);
                },
                titleMaxLines: 1,
                title: 'Locations',
                description: 'Find a store near you.',
              ),
              Spacing.vertical(40),
              const WebFooterBanner(),
            ],
          ),
        ),
      ),
    );
  }

  _showScanFloatingActionButton(BuildContext context, UserModel user) {
    if (user.uid == null || user.uid!.isEmpty) {
      return const SizedBox();
    }
    if (ResponsiveLayout.isWeb(context) || ResponsiveLayout.isTablet(context)) {
      return const SizedBox();
    }

    return ScanFloatingActionButton(
      onPressed: () {
        ScanHelpers.cancelQrTimer(ref);
        ScanHelpers.handleScanAndPayPageInitializers(ref);
        NavigationHelpers.navigateToScanPage(context, ref);
      },
    );
  }
}
