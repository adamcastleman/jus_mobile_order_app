import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/display_images_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/menu_card.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_bulleted_list.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_call_to_action.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_stepper.dart';
import 'package:jus_mobile_order_app/Widgets/General/web_footer_banner.dart';

class CleansePageWeb extends HookConsumerWidget {
  const CleansePageWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final pastelRed = ref.watch(pastelRedProvider);
    final pastelBrown = ref.watch(pastelBrownProvider);
    final pastelGreen = ref.watch(pastelGreenProvider);
    final scrollController = useScrollController();
    final products = ref.watch(allProductsProvider);
    final cleanses =
        products.where((item) => item.category == 'Cleanses').toList();
    double listHeight = ResponsiveLayout.isWeb(context) ? 500 : 400;
    return DisplayImagesProviderWidget(
      builder: (images) => SingleChildScrollView(
        controller: scrollController,
        primary: false,
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: listHeight,
              child: _buildCleanseList(
                context,
                cleanses,
                listHeight,
              ),
            ),
            Spacing.vertical(40),
            CallToActionBanner(
              imagePath: images['images'][6]['url'],
              backgroundColor: pastelGreen,
              callToActionText: 'Schedule Now',
              callToActionOnPressed: () {
                scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.decelerate);
              },
              titleMaxLines: 1,
              title: 'Why cleanse?',
              description:
                  'Push a ‘reset’ button on your body. Cleanses rest your digestive system and enrich your body with nutrients from fresh fruits and vegetables.',
            ),
            const WebBulletListBanner(
              backgroundColor: Colors.white,
              bannerTitle: 'The Cleanses',
              firstColumnBulletTitle: 'Full-Day Cleanse',
              firstColumnBulletItems: [
                'Six juices/day for up to five days.',
                'Designed as a complete fast.',
                'Fully rest your digestive system while giving your body the tools it needs for a healthy detox.'
              ],
              secondColumnBulletTitle: 'Half-Day Cleanse',
              secondColumnBulletItems: [
                'Four juices/day for up to five days.',
                'A great introduction to cleansing.',
                'Reap many benefits of a Full-Day Cleanse while still being able to consume some solid foods.'
              ],
            ),
            CallToActionBanner(
              imagePath: images['images'][24]['url'],
              backgroundColor: pastelRed,
              callToActionText: 'Schedule Now',
              callToActionOnPressed: () {
                scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.decelerate);
              },
              title: 'Ordering Your Cleanse',
              titleMaxLines: 1,
              description:
                  'To ensure freshness and maximum nutrient preservation, please order at least 72 hours prior to pickup. Schedule your cleanse pickup online or in-store.',
              descriptionMaxLines: 4,
            ),
            WebBannerStepper(
              backgroundColor: Colors.white,
              bannerTitle: 'Preparing for your cleanse',
              bannerSubtitle: '',
              steps: [
                StepItem(
                    title: 'Before',
                    description:
                        'Phase out processed foods, opting for raw veggies and lean proteins. Prepare to reduce physical activity and exercise due to lower calories and detox.'),
                StepItem(
                    title: 'During',
                    description:
                        'Consume your juices every three hours for consistent nutrition. Match your water intake with juice consumption for hydration and toxin removal. Keep juices chilled, and expect detox symptoms, including caffeine withdrawal.'),
                StepItem(
                    title: 'After',
                    description:
                        'Begin reintroducing food with light options like smoothies, and soups. Gradually add more solid foods such as rice, quinoa, and vegetables. Slowly return to your normal diet as your body adjusts to the food intake.'),
              ],
            ),
            CallToActionBanner(
              imagePath: images['images'][5]['url'],
              backgroundColor: pastelBrown,
              callToActionText:
                  user.uid == null || user.subscriptionStatus!.isNotActive
                      ? 'Sign Up'
                      : 'Schedule Now',
              callToActionOnPressed: () {
                scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.decelerate);
              },
              titleMaxLines: 1,
              title: 'Members save a bundle',
              description:
                  'Become a member and enjoy discounts of over 60% on cleanses',
            ),
            Spacing.vertical(30),
            const WebFooterBanner(),
          ],
          //   ),
          // ),
        ),
      ),
    );
  }

  Widget _buildCleanseList(
      BuildContext context, List<ProductModel> cleanses, double listHeight) {
    // Define the width of each item, including the separator
    final double itemWidth = listHeight;
    const double separatorWidth = 20;

    // Calculate total width of all items
    final double totalWidth =
        cleanses.length * itemWidth + (cleanses.length - 1) * separatorWidth;

    // Get screen width
    final double screenWidth = MediaQuery.of(context).size.width;

    // Check if items fit within the screen width
    if (totalWidth < screenWidth) {
      // Use a Row with MainAxisAlignment.spaceEvenly
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: cleanses
            .map(
              (product) => AspectRatio(
                aspectRatio: ResponsiveLayout.isMobileBrowser(context) ? 2 : 1,
                child: MenuCard(product: product),
              ),
            )
            .toList(),
      );
    } else {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        scrollDirection: Axis.horizontal,
        itemCount: cleanses.length,
        separatorBuilder: (context, index) => Spacing.horizontal(15),
        itemBuilder: (context, index) => AspectRatio(
          aspectRatio: ResponsiveLayout.isMobileBrowser(context) ? 1 / 1.5 : 1,
          child: MenuCard(
            product: cleanses[index],
          ),
        ),
      );
    }
  }
}
