import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/Sheets/multi_use_ingredient_selection_sheet.dart';

import '../../Providers/stream_providers.dart';

class SelectIngredientCard extends ConsumerWidget {
  final List<IngredientModel> ingredients;
  final int index;
  const SelectIngredientCard(
      {required this.ingredients, required this.index, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (user) {
        Iterable<dynamic> currentSelected = selectedIngredients
            .where((element) => element['id'] == ingredients[index].id);

        return InkWell(
          onTap: () {
            handleIngredientSelection(context, currentSelected, ref, user);
          },
          child: Card(
            color:
                currentSelected.isNotEmpty ? Colors.blueGrey[50] : Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color:
                    currentSelected.isNotEmpty ? Colors.blueGrey : Colors.white,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: CachedNetworkImage(
                    imageUrl: ingredients[index].image,
                  ),
                ),
                Spacing().vertical(5),
                AutoSizeText(
                  ingredients[index].name,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                Spacing().vertical(8),
                determinePricingText(user, ref),
              ],
            ),
          ),
        );
      },
    );
  }

  determinePricingText(UserModel user, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser.value?.uid == null &&
        user.isActiveMember != true &&
        ingredients[index].isExtraCharge) {
      return Text('\$${(ingredients[index].price / 100).toStringAsFixed(2)}');
    } else if (user.isActiveMember != true &&
        ingredients[index].isExtraCharge) {
      return Text('\$${(ingredients[index].price / 100).toStringAsFixed(2)}');
    } else if (user.isActiveMember == true &&
        ingredients[index].isExtraCharge) {
      return const Text(
        'Free for members',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  handleIngredientSelection(BuildContext context,
      Iterable<dynamic> currentSelected, WidgetRef ref, UserModel user) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    IngredientModel currentIngredient = ingredients
        .where((element) => element.id == ingredients[index].id)
        .first;
    //Removes an ingredient from the list
    if (currentSelected.isNotEmpty) {
      HapticFeedback.lightImpact();
      ref
          .read(selectedIngredientsProvider.notifier)
          .removeIngredient(ingredients[index].id, ref, selectedIngredients);
      //Shows modal sheet when user selects product that is toppable and ingredient that can be both blended and topped.
    } else if (ref.read(productHasToppingsProvider) &&
        currentIngredient.isBlended &&
        currentIngredient.isTopping) {
      ref.read(currentIngredientExtraChargeProvider.notifier).state =
          currentIngredient.isExtraCharge;
      ref.read(currentIngredientIDProvider.notifier).state =
          ingredients[index].id;
      ref.read(currentIngredientIndexProvider.notifier).state = index;
      ref.invalidate(currentIngredientBlendedProvider);
      ref.invalidate(currentIngredientToppingProvider);
      ref.invalidate(extraChargeBlendedIngredientQuantityProvider);
      ref.invalidate(extraChargeToppedIngredientQuantityProvider);
      HapticFeedback.lightImpact();
      ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => const MultiUseIngredientSelectionSheet(),
      );
      //Adds ingredient to list that cannot be both blended and topped
    } else {
      ref.read(currentIngredientExtraChargeProvider.notifier).state =
          currentIngredient.isExtraCharge;
      HapticFeedback.lightImpact();
      ref.read(selectedIngredientsProvider.notifier).addIngredient(
            ingredients: ingredients,
            index: index,
            isExtraCharge: ref.watch(currentIngredientExtraChargeProvider),
            ref: ref,
            user: user,
          );
    }
  }
}
