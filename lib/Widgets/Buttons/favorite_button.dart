import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/favorites_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/favorites_services.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Sheets/name_favorite_item_sheet.dart';
import 'package:jus_mobile_order_app/Views/register_page.dart';

class FavoriteButton extends ConsumerWidget {
  final ProductModel product;
  const FavoriteButton({required this.product, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    return user.uid == null
        ? _guestFavoriteButton(context)
        : FavoritesProviderWidget(
            builder: (favorites) =>
                _buildFavoriteButton(context, ref, user, favorites),
          );
  }

  Widget _guestFavoriteButton(BuildContext context) {
    return IconButton(
      icon: const Icon(FontAwesomeIcons.heart),
      iconSize: 22,
      onPressed: () {
        ModalBottomSheet().fullScreen(
          context: context,
          builder: (context) => const RegisterPage(),
        );
      },
    );
  }

  Widget _buildFavoriteButton(BuildContext context, WidgetRef ref,
      UserModel user, List<FavoritesModel> favorite) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final standardIngredients = ref.watch(standardIngredientsProvider);
    final matchingFavorite = favorite.where((fav) =>
        const DeepCollectionEquality.unordered().equals(
          fav.ingredients,
          selectedIngredients.isEmpty
              ? standardIngredients
              : selectedIngredients,
        ) &&
        const DeepCollectionEquality.unordered().equals(
          fav.allergies,
          ref.watch(selectedAllergiesProvider),
        ) &&
        const DeepCollectionEquality.unordered().equals(
          fav.size,
          ref.watch(itemSizeProvider),
        ) &&
        (fav.toppings.isEmpty ||
            const DeepCollectionEquality.unordered().equals(
              fav.toppings,
              ref.watch(selectedToppingsProvider),
            )));

    if (matchingFavorite.isEmpty) {
      return IconButton(
        icon: const Icon(FontAwesomeIcons.heart),
        iconSize: 22,
        onPressed: () {
          nameFavorite(context, user, ref);
        },
      );
    } else {
      return IconButton(
        icon: const Icon(FontAwesomeIcons.solidHeart),
        iconSize: 22,
        onPressed: () {
          HapticFeedback.lightImpact();
          FavoritesServices().deleteFromFavorites(
              context: context,
              docID: matchingFavorite.first.uid,
              onError: (error) {
                ModalBottomSheet().partScreen(
                  context: context,
                  builder: (context) => InvalidSheetSinglePop(
                    error: error,
                  ),
                );
              });
        },
      );
    }
  }

  nameFavorite(BuildContext context, UserModel user, WidgetRef ref) {
    ref.read(favoriteItemNameProvider.notifier).state = product.name;
    ModalBottomSheet().partScreen(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      builder: (context) => NameFavoriteItemSheet(
        currentProduct: product,
      ),
    );
  }
}
