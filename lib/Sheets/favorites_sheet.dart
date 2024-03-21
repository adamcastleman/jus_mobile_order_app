import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/display_images_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/favorites_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/favorite_card_empty.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/favorites_card.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';
import 'package:jus_mobile_order_app/constants.dart';

class FavoritesSheet extends ConsumerWidget {
  const FavoritesSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pastelPurple = ref.watch(pastelPurpleProvider);
    final isDrawerOpen = AppConstants.scaffoldKey.currentState?.isEndDrawerOpen;
    return FavoritesProviderWidget(
      builder: (favorites) => DisplayImagesProviderWidget(
        builder: (images) => Container(
          height: double.infinity,
          color: pastelPurple,
          padding: EdgeInsets.only(
              top: isDrawerOpen == null || !isDrawerOpen ? 50.0 : 12.0,
              left: 12.0,
              right: 12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SheetHeader(
                  title: 'Favorites',
                  color: pastelPurple,
                  showCloseButton: isDrawerOpen == null || !isDrawerOpen,
                ),
                PlatformUtils.isWeb() ? const SizedBox() : Spacing.vertical(30),
                favorites.isEmpty
                    ? EmptyFavoriteCard(
                        images: images,
                      )
                    : Expanded(
                        child: GridView.builder(
                          shrinkWrap: true,
                          primary: false,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  childAspectRatio: 9 / 18),
                          itemCount: favorites.isEmpty ? 0 : favorites.length,
                          itemBuilder: (context, index) => FavoritesCard(
                            favoriteItem: favorites[index],
                            imageWidth: 175,
                            imageHeight: 175,
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
