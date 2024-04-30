import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/announcements_model.dart';
import 'package:jus_mobile_order_app/Models/top_banner_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/announcements_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/display_images_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/top_banner_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/banner_call_to_action.dart';
import 'package:jus_mobile_order_app/Widgets/General/home_greeting.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/favorites_list.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/announcement_tile.dart';

class MobileHomePage extends StatelessWidget {
  final WidgetRef ref;
  const MobileHomePage({required this.ref, super.key});

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    return DisplayImagesProviderWidget(
      builder: (images) => TopBannerProviderWidget(
        builder: (banner) => AnnouncementsProviderWidget(
          builder: (announcements) {
            if (user.uid == null) {
              return _guestHomePage(
                  context, user, banner, images, announcements);
            }
            return _userHomePage(context, user, images, banner, announcements);
          },
        ),
      ),
    );
  }

  _guestHomePage(
    BuildContext context,
    UserModel user,
    TopBannerModel banner,
    dynamic images,
    List<AnnouncementsModel> announcements,
  ) {
    final pastelBlue = ref.watch(pastelBlueProvider);
    final pastelRed = ref.watch(pastelRedProvider);
    final pastelBrown = ref.watch(pastelBrownProvider);
    final pastelPurple = ref.watch(pastelPurpleProvider);

    return Scaffold(
      appBar: _homeAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _displayAnnouncementTile(user, announcements),
            CallToActionBanner(
              imagePath: banner.image,
              backgroundColor: banner.color == null
                  ? pastelRed
                  : ref.watch(banner.color ?? pastelRedProvider),
              callToActionText: 'Order Now',
              callToActionOnPressed: () {
                HapticFeedback.lightImpact();
                NavigationHelpers().navigateToMenuPage(context, ref);
              },
              titleMaxLines: 1,
              title: banner.title,
              description: banner.description,
              isImageOnRight: true,
            ),
            CallToActionBanner(
              imagePath: images['images'][14]['url'],
              backgroundColor: pastelPurple,
              callToActionText: 'Sign Up',
              callToActionOnPressed: () {
                HapticFeedback.lightImpact();
                NavigationHelpers.navigateToRegisterPage(context);
              },
              titleMaxLines: 1,
              title: 'Save Favorites',
              description:
                  'Create an account to save your favorites so it\'s faster and easier to order next time.',
              isImageOnRight: false,
            ),
            CallToActionBanner(
              imagePath: images['images'][8]['url'],
              backgroundColor: pastelBrown,
              callToActionText: 'Learn More',
              callToActionOnPressed: () {
                HapticFeedback.lightImpact();
                NavigationHelpers.navigateToPointsInformationPage(
                  context,
                  ref,
                );
              },
              titleMaxLines: 1,
              title: 'Get Free Stuff',
              description:
                  'Collect points as you shop, and redeem these points for free items.',
              isImageOnRight: false,
            ),
            CallToActionBanner(
              imagePath: images['images'][12]['url'],
              backgroundColor: pastelBlue,
              callToActionText: 'View Map',
              callToActionOnPressed: () {
                HapticFeedback.lightImpact();
                NavigationHelpers().navigateToLocationPage(context, ref);
              },
              titleMaxLines: 1,
              title: 'Locations',
              description: 'Find a store near you.',
            )
          ],
        ),
      ),
    );
  }

  _userHomePage(
    BuildContext context,
    UserModel user,
    dynamic images,
    TopBannerModel banner,
    List<AnnouncementsModel> announcements,
  ) {
    final pastelRed = ref.watch(pastelRedProvider);
    final pastelPurple = ref.watch(pastelPurpleProvider);
    final pastelBlue = ref.watch(pastelBlueProvider);
    final pastelBrown = ref.watch(pastelBrownProvider);
    final favorites = ref.watch(allFavoritesProvider);
    return Scaffold(
      appBar: _homeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _displayAnnouncementTile(user, announcements),
            CallToActionBanner(
              imagePath: banner.image,
              backgroundColor: pastelRed,
              callToActionText: 'Order Now',
              callToActionOnPressed: () {
                HapticFeedback.lightImpact();
                NavigationHelpers().navigateToMenuPage(context, ref);
              },
              titleMaxLines: 1,
              title: banner.title,
              description: banner.description,
              isImageOnRight: true,
            ),
            favorites.isEmpty
                ? CallToActionBanner(
                    imagePath: images['images'][14]['url'],
                    backgroundColor: pastelPurple,
                    callToActionText: 'See Menu',
                    callToActionOnPressed: () {
                      HapticFeedback.lightImpact();
                      NavigationHelpers().navigateToMenuPage(context, ref);
                    },
                    titleMaxLines: 1,
                    title: 'Save Favorites',
                    description:
                        'Select your favorite item and tap the heart for faster reordering',
                    isImageOnRight: false,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22.0),
                    child: FavoritesList(
                      favorites: favorites,
                    ),
                  ),
            CallToActionBanner(
              imagePath: images['images'][8]['url'],
              backgroundColor: pastelBrown,
              callToActionText: 'View Points',
              callToActionOnPressed: () {
                HapticFeedback.lightImpact();
                NavigationHelpers.navigateToScanPage(
                  context,
                  ref,
                );
              },
              titleMaxLines: 1,
              title: 'Points and Rewards',
              description:
                  'Earn points as you spend and redeem these points for free stuff',
              isImageOnRight: false,
            ),
            CallToActionBanner(
              imagePath: images['images'][12]['url'],
              backgroundColor: pastelBlue,
              callToActionText: 'View Map',
              callToActionOnPressed: () {
                HapticFeedback.lightImpact();
                NavigationHelpers().navigateToLocationPage(context, ref);
              },
              titleMaxLines: 1,
              title: 'Locations',
              description: 'Find a store near you.',
            )
          ],
        ),
      ),
    );
  }

  AppBar _homeAppBar() {
    return AppBar(
      title: const MobileHomeGreeting(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.asset(
            'assets/jus_logo_icon.png',
            scale: 3,
          ),
        ),
      ],
    );
  }

  Widget _displayAnnouncementTile(
      UserModel user, List<AnnouncementsModel> announcements) {
    if (announcements.isEmpty) {
      return const SizedBox();
    } else {
      return Column(
        children: [
          user.uid == null ? const SizedBox() : Spacing.vertical(25),
          AnnouncementTile(
            announcements: announcements,
          ),
          Spacing.vertical(25),
        ],
      );
    }
  }
}
