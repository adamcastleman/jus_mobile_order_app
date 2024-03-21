import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/favorites_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outlined_button_medium.dart';

class NameFavoriteItemSheet extends ConsumerWidget {
  final ProductModel currentProduct;
  const NameFavoriteItemSheet({required this.currentProduct, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          height: MediaQuery.of(context).size.height * 0.30,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Name your favorite',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextFormField(
                  initialValue: ref.watch(favoriteItemNameProvider),
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) =>
                      ref.read(favoriteItemNameProvider.notifier).state = value,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: MediumOutlineButton(
                        buttonText: 'Cancel',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Spacing.horizontal(5),
                    Flexible(
                      child: MediumElevatedButton(
                        buttonText: 'Add to favorites',
                        onPressed: () {
                          Navigator.pop(context);
                          _addItemToFavorites(context, ref, user);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addItemToFavorites(BuildContext context, WidgetRef ref, UserModel user) {
    FavoritesServices(ref: ref).addToFavorites(
      context: context,
      currentIngredients: addIngredients(ref),
      currentToppings: addToppings(ref),
      onError: (error) {
        ErrorHelpers.showSinglePopError(context, error: error);
      },
    );
  }

  addIngredients(WidgetRef ref) {
    var standardIngredients = ref.watch(standardIngredientsProvider);
    var selectedIngredients = ref.watch(selectedIngredientsProvider);

    if (selectedIngredients.isNotEmpty) {
      return selectedIngredients;
    }
    return standardIngredients;
  }

  addToppings(WidgetRef ref) {
    final selectedToppings = ref.watch(selectedToppingsProvider);
    if (selectedToppings.isNotEmpty) {
      return selectedToppings;
    } else {
      return [];
    }
  }
}
