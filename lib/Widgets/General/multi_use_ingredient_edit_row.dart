import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/ingredient_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Sheets/multi_use_ingredient_selection_sheet.dart';

class MultiUseIngredientEditRow extends ConsumerWidget {
  final IngredientModel currentIngredient;
  final int index;
  const MultiUseIngredientEditRow(
      {required this.currentIngredient, required this.index, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (user) => Padding(
        padding: const EdgeInsets.only(
            top: 8.0, right: 8.0, bottom: 8.0, left: 14.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          (user.uid == null || !user.isActiveMember!) &&
                  selectedIngredients[index]['isExtraCharge']
              ? Text(
                  '\$${(double.parse(selectedIngredients[index]['price']) / 100).toStringAsFixed(2)}')
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
              ref.read(currentIngredientIDProvider.notifier).state =
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
                    selectedIngredients[index]['blended'];
                ref.read(currentIngredientToppingProvider.notifier).state =
                    selectedIngredients[index]['topping'];
              }

              ModalBottomSheet().partScreen(
                context: context,
                builder: (context) => const MultiUseIngredientSelectionSheet(),
              );
            },
          ),
        ]),
      ),
    );
  }
}
