import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/confirm_button.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/select_multiple_ingredients_card.dart';

class AllergiesSheet extends ConsumerWidget {
  const AllergiesSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredients = ref.watch(modifiableIngredientsProvider);
    final backgroundColor = ref.watch(backgroundColorProvider);
    return ingredients.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (data) => Container(
        color: backgroundColor,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          shrinkWrap: true,
          children: [
            Spacing().vertical(60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                JusCloseButton(
                  removePadding: true,
                  onPressed: () {
                    ref.invalidate(selectedAllergiesProvider);
                    Navigator.pop(context);
                  },
                  iconSize: 22,
                ),
                const ConfirmButton(),
              ],
            ),
            Spacing().vertical(10),
            const Text(
              'Select allergies:',
              style: TextStyle(fontSize: 20),
            ),
            Spacing().vertical(10),
            const Text(
              'These are the ingredients we use in our stores.',
              style: TextStyle(fontSize: 12),
            ),
            Spacing().vertical(5),
            const Text(
              'If your allergy is not in this list, you do not need to worry.',
              style: TextStyle(fontSize: 12),
            ),
            Spacing().vertical(20),
            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1 / 1.1,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) => SelectMultipleIngredientsCard(
                ingredient: data[index],
                isAllergy: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
