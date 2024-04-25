import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Sheets/multi_use_ingredient_selection_sheet.dart';

class MultiUseIngredientEditRow extends ConsumerWidget {
  final IngredientModel currentIngredient;
  final int index;
  const MultiUseIngredientEditRow(
      {required this.currentIngredient, required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    final selectedIngredients = ref.watch(selectedIngredientsProvider);

    double pricePerUnit =
        double.tryParse(selectedIngredients[index]['price'].toString()) ?? 0;
    int blended = selectedIngredients[index]['blended'] ?? 0;
    int topping = selectedIngredients[index]['topping'] ?? 0;
    double totalPrice =
        pricePerUnit * (blended + topping) / 100; // Price is in cents.

    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0, left: 14.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        (user.uid == null || user.subscriptionStatus!.isNotActive) &&
                selectedIngredients[index]['isExtraCharge']
            ? Text('\$${totalPrice.toStringAsFixed(2)}')
            : const SizedBox(),
        InkWell(
          child: const CircleAvatar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            radius: 13,
            child: FaIcon(
              FontAwesomeIcons.pencil,
              size: 12,
            ),
          ),
          onTap: () {
            ref.read(currentIngredientExtraChargeProvider.notifier).state =
                currentIngredient.isExtraCharge;
            ref.read(currentIngredientIdProvider.notifier).state =
                selectedIngredients[index]['id'];
            ref.read(currentIngredientIndexProvider.notifier).state = index;
            ref
                .read(extraChargeBlendedIngredientQuantityProvider.notifier)
                .addBlended(selectedIngredients[index]['blended']);
            ref
                .read(extraChargeToppedIngredientQuantityProvider.notifier)
                .addTopping(selectedIngredients[index]['topping']);
            if (currentIngredient.isTopping &&
                currentIngredient.isBlended &&
                !currentIngredient.isExtraCharge) {
              ref.read(currentIngredientBlendedProvider.notifier).state =
                  selectedIngredients[index]['blended'] == 0 ? true : false;
              ref.read(currentIngredientToppingProvider.notifier).state =
                  selectedIngredients[index]['topping'] == 0 ? true : false;
            }
            NavigationHelpers.navigateToPartScreenSheetOrDialog(
              context,
              const MultiUseIngredientSelectionSheet(),
            );
          },
        ),
      ]),
    );
  }
}
