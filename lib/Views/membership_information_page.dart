import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/display_images_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/membership_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_bulleted_list.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_call_to_action.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_stepper.dart';
import 'package:jus_mobile_order_app/Widgets/General/web_footer_banner.dart';
import 'package:jus_mobile_order_app/constants.dart';
import 'package:jus_mobile_order_app/errors.dart';

class MembershipInformationPage extends ConsumerWidget {
  const MembershipInformationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = AppConstants.scaffoldKey;
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final pastelBrown = ref.watch(pastelBrownProvider);
    final pastelPurple = ref.watch(pastelPurpleProvider);
    final pastelRed = ref.watch(pastelRedProvider);
    return MembershipDetailsProviderWidget(
      builder: (membership) => DisplayImagesProviderWidget(
        builder: (images) => SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CallToActionBanner(
                imagePath: images['images'][3]['url'],
                backgroundColor: pastelRed,
                callToActionText:
                    PlatformUtils.isWeb() ? 'Sign Up' : 'Learn More',
                callToActionOnPressed: () {
                  _membershipSignUpOnPressed(context, ref, user, scaffoldKey);
                },
                titleMaxLines: 1,
                title: 'Membership',
                description:
                    'Members receive exclusive and unlimited access to ${membership.perks[0]['description'].toLowerCase()}',
              ),
              WebBulletListBanner(
                backgroundColor: Colors.white,
                bannerTitle: 'The Perks',
                firstColumnBulletTitle: 'It pays to be a Member:',
                firstColumnBulletItems: [
                  '${membership.perks[0]['description']}',
                  '${membership.perks[1]['name']}',
                  'Discounts on everything we sell'
                ],
                secondColumnBulletTitle: 'Even more benefits:',
                secondColumnBulletItems: [
                  '2x points/\$1 spent',
                  '${membership.perks[4]['name']} - ${membership.perks[4]['description']}',
                  'Additional exclusive discounts dropped throughout the year.'
                ],
              ),
              CallToActionBanner(
                imagePath: images['images'][0]['url'],
                backgroundColor: pastelBrown,
                callToActionText:
                    PlatformUtils.isWeb() ? 'Sign Up' : 'Learn More',
                callToActionOnPressed: () {
                  _membershipSignUpOnPressed(context, ref, user, scaffoldKey);
                },
                title: 'Member Day',
                titleMaxLines: 1,
                description:
                    'Members get one free juice, smoothie, or bowl + 50% off all cleanses.',
                descriptionMaxLines: 4,
              ),
              WebBannerStepper(
                backgroundColor: Colors.white,
                bannerTitle: 'How Membership works',
                bannerSubtitle: '',
                steps: [
                  StepItem(
                      title: 'Sign Up',
                      description:
                          'Subscribe to Membership to begin enjoying savings on everything we sell.'),
                  StepItem(
                      title: 'Order in-store or online',
                      description:
                          'Scan your member code in-store, or to save time, order through the app. You\'ll get your perks all along the way.'),
                  StepItem(
                      title: 'Save money',
                      description:
                          'Enjoy unlimited discounted items, earn bonus points on each purchase, and check back for exclusive deals, just for Members.'),
                ],
              ),
              CallToActionBanner(
                imagePath: images['images'][9]['url'],
                backgroundColor: pastelPurple,
                callToActionText:
                    PlatformUtils.isWeb() ? 'Sign Up' : 'Learn More',
                callToActionOnPressed: () {
                  _membershipSignUpOnPressed(context, ref, user, scaffoldKey);
                },
                titleMaxLines: 1,
                title: 'Affordable Wellness',
                description: 'Savings as high as 70%, available every day.',
              ),
              Spacing.vertical(30),
              PlatformUtils.isIOS() || PlatformUtils.isAndroid()
                  ? const SizedBox()
                  : const WebFooterBanner(),
            ],
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  _membershipSignUpOnPressed(BuildContext context, WidgetRef ref,
      UserModel user, GlobalKey<ScaffoldState> scaffoldKey) {
    if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
      HapticFeedback.lightImpact();
      return ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => InvalidSheetSinglePop(
          error: ErrorMessage.inAppMembershipPurchaseDisclaimer,
        ),
      );
    } else if (user.uid == null || user.uid!.isEmpty) {
      NavigationHelpers.navigateToLoginPage(context);
    } else {
      NavigationHelpers.navigateToMembershipCheckoutPage(ref, scaffoldKey);
    }
  }
}
