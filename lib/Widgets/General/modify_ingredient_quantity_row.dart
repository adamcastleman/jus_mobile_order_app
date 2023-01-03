import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class ModifyIngredientQuantityRow extends ConsumerWidget {
  final int index;
  const ModifyIngredientQuantityRow({required this.index, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    final user = ref.watch(currentUserProvider);
    final ingredients = ref.watch(modifiableIngredientsProvider);
    return ingredients.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (ingredients) => user.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(
          error: e.toString(),
        ),
        data: (user) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    child: const Icon(
                      CupertinoIcons.minus_circled,
                      size: 20,
                    ),
                    onTap: () {
                      ref
                          .read(selectedIngredientsProvider.notifier)
                          .removeQuantityAmount(index, ref, ingredients, user);
                    },
                  ),
                  Spacing().horizontal(8.0),
                  InkWell(
                    child: const Icon(
                      CupertinoIcons.plus_circle,
                      size: 20,
                    ),
                    onTap: () {
                      ref
                          .read(selectedIngredientsProvider.notifier)
                          .addQuantityAmount(
                              index: index,
                              ref: ref,
                              isExtraCharge: ref
                                  .read(currentIngredientExtraChargeProvider),
                              ingredients: ingredients,
                              user: user);
                    },
                  ),
                ],
              ),
              InkWell(
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  radius: 13,
                  child: Text(
                      '${selectedIngredients[index]['amount'] == 0.5 ? '1/2' : selectedIngredients[index]['amount']}'),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
