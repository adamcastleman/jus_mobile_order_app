import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_call_to_action.dart';

class EmptyFavoriteCard extends ConsumerWidget {
  final dynamic images;
  const EmptyFavoriteCard({required this.images, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pastelPurple = ref.watch(pastelPurpleProvider);
    return CallToActionBanner(
      imagePath: images['images'][14]['url'],
      backgroundColor: pastelPurple,
      callToActionText: 'View Menu',
      callToActionOnPressed: () {
        HapticFeedback.lightImpact();
        Navigator.pop(context);
        NavigationHelpers().navigateToMenuPage(context, ref);
      },
      titleMaxLines: 1,
      title: 'Got a favorite?',
      description:
          'Create an account to save your favorites so it\'s faster and easier to order next time.',
      isImageOnRight: false,
    ).buildMobileLayout(context);
  }
}
