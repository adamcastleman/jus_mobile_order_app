import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/display_images_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_call_to_action.dart';

class EmptyBagPage extends ConsumerWidget {
  const EmptyBagPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pastelBrown = ref.watch(pastelBrownProvider);
    return DisplayImagesProviderWidget(
      builder: (images) => Container(
        height: double.infinity,
        color: pastelBrown,
        child: CallToActionBanner(
          imagePath: images['images'][7]['url'],
          backgroundColor: pastelBrown,
          callToActionText: 'Order Now',
          callToActionOnPressed: () {
            HapticFeedback.lightImpact();
            NavigationHelpers().navigateToMenuPage(context, ref);
          },
          titleMaxLines: 1,
          title: 'So close, you can almost taste it',
          description:
              'Cold pressed juices, smoothies, and bowls are only one tap away.',
          isImageOnRight: true,
        ),
      ),
    );
  }
}
