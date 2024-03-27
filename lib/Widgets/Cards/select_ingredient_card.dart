import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Sheets/multi_use_ingredient_selection_sheet.dart';

class SelectIngredientCard extends ConsumerWidget {
  final List<IngredientModel> ingredients;
  final int index;
  const SelectIngredientCard(
      {required this.ingredients, required this.index, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final selectedCardColor = ref.watch(selectedCardColorProvider);
    final selectedCardBorderColor = ref.watch(selectedCardBorderColorProvider);

    Iterable<dynamic> currentSelected = selectedIngredients
        .where((element) => element['id'] == ingredients[index].id);

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        handleIngredientSelection(context, currentSelected, ref, user);
      },
      child: Card(
        elevation: 0.0,
        color: currentSelected.isNotEmpty ? selectedCardColor : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: currentSelected.isNotEmpty
                ? selectedCardBorderColor
                : Colors.white,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            SizedBox(
              height: ResponsiveLayout.isWeb(context) ? 90 : 80,
              width: ResponsiveLayout.isWeb(context) ? 90 : 80,
              child: CachedNetworkImage(
                imageUrl: ingredients[index].image,
              ),
            ),
            Spacing.vertical(5),
            AutoSizeText(
              ingredients[index].name,
              style: TextStyle(
                  fontSize: ResponsiveLayout.isWeb(context) ? 14 : 12),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            Spacing.vertical(8),
            determinePricingText(user, ref),
          ],
        ),
      ),
    );
  }

  Widget determinePricingText(UserModel user, WidgetRef ref) {
    final ingredient = ingredients[index];

    if (!ingredient.isExtraCharge) {
      return const SizedBox();
    }

    final price = (ingredient.price / 100).toStringAsFixed(2);

    if (user.subscriptionStatus!.isActive) {
      return const Text(
        'Free for members',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    }

    return Text('\$$price');
  }

  handleIngredientSelection(BuildContext context,
      Iterable<dynamic> currentSelected, WidgetRef ref, UserModel user) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    IngredientModel currentIngredient = ingredients
        .where((element) => element.id == ingredients[index].id)
        .first;
    //Removes an ingredient from the list
    if (currentSelected.isNotEmpty) {
      ref
          .read(selectedIngredientsProvider.notifier)
          .removeIngredient(ingredients[index].id, ref, selectedIngredients);
      //Shows modal sheet when user selects product that is toppable and ingredient that can be both blended and topped.
    } else if (ref.read(productHasToppingsProvider) &&
        currentIngredient.isBlended &&
        currentIngredient.isTopping) {
      ref.read(currentIngredientExtraChargeProvider.notifier).state =
          currentIngredient.isExtraCharge;
      ref.read(currentIngredientIdProvider.notifier).state =
          ingredients[index].id;
      ref.read(currentIngredientIndexProvider.notifier).state = index;
      ref.invalidate(currentIngredientBlendedProvider);
      ref.invalidate(currentIngredientToppingProvider);
      ref.invalidate(extraChargeBlendedIngredientQuantityProvider);
      ref.invalidate(extraChargeToppedIngredientQuantityProvider);
      NavigationHelpers.navigateToPartScreenSheetOrDialog(
        context,
        const MultiUseIngredientSelectionSheet(),
      );

      //Adds ingredient to list that cannot be both blended and topped
    } else {
      ref.read(currentIngredientExtraChargeProvider.notifier).state =
          currentIngredient.isExtraCharge;
      ref.read(selectedIngredientsProvider.notifier).addIngredient(
            ingredient: ingredients[index],
            isExtraCharge: ref.watch(currentIngredientExtraChargeProvider),
            ref: ref,
            user: user,
          );
    }
  }
}
