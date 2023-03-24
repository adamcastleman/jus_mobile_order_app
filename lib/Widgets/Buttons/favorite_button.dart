import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/favorites_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/favorites_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Services/favorites_services.dart';
import 'package:jus_mobile_order_app/Sheets/name_favorite_item_sheet.dart';
import 'package:jus_mobile_order_app/Views/register_page.dart';

class FavoriteButton extends ConsumerWidget {
  final ProductModel product;
  const FavoriteButton({required this.product, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserProviderWidget(
      builder: (user) => FavoritesProviderWidget(
        builder: (favorites) =>
            _buildFavoriteButton(context, ref, user, favorites),
      ),
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
          determineFavoriteOrRegister(context, user, ref);
        },
      );
    } else {
      return IconButton(
        icon: const Icon(FontAwesomeIcons.solidHeart),
        iconSize: 22,
        onPressed: () {
          FavoritesServices(uid: user.uid!)
              .deleteFromFavorites(docID: matchingFavorite.first.uid);
        },
      );
    }
  }

  determineFavoriteOrRegister(
      BuildContext context, UserModel user, WidgetRef ref) {
    if (user.uid == null) {
      return ModalBottomSheet().fullScreen(
        context: context,
        builder: (context) => const RegisterPage(),
      );
    } else {
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
}
