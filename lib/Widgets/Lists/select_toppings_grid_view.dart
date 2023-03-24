import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/toppings_only_provider_widget.dart';

import '../Cards/select_multiple_ingredients_card.dart';

class SelectToppingsGridView extends ConsumerWidget {
  const SelectToppingsGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToppingsOnlyProviderWidget(
      builder: (toppings) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select up to three toppings:',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Spacing().vertical(10),
          Flexible(
            child: GridView.builder(
              padding: const EdgeInsets.all(0.0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              primary: false,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1 / 1.2,
                  crossAxisCount: 3,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3),
              itemCount: toppings.length,
              itemBuilder: (context, index) => SelectMultipleIngredientsCard(
                ingredient: toppings[index],
                isAllergy: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
