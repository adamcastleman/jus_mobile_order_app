import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/display_images_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_call_to_action.dart';

class SignedOutProfilePage extends ConsumerWidget {
  final bool? showCloseButton;
  const SignedOutProfilePage({this.showCloseButton, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pastelTan = ref.watch(pastelTanProvider);
    return DisplayImagesProviderWidget(
      builder: (images) => Container(
        height: double.infinity,
        color: pastelTan,
        child: CallToActionBanner(
          imagePath: images['images'][21]['url'],
          backgroundColor: pastelTan,
          callToActionText: PlatformUtils.isWeb() ? 'Sign in' : 'Sign up',
          callToActionOnPressed: () {
            HapticFeedback.lightImpact();
            NavigationHelpers.authNavigation(context);
          },
          titleMaxLines: 1,
          title: PlatformUtils.isWeb()
              ? 'Continue to the sweetest adventure'
              : 'Join the sweetest adventure',
          description: PlatformUtils.isWeb()
              ? 'Sign in to collect points to redeem for free items, save favorite items, and more.'
              : 'Join now to collect points to redeem for free items, save favorite items, and more.',
          isImageOnRight: true,
        ),
      ),
    );
  }
}
