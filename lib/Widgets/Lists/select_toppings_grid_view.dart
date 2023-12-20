import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/product_quantity_limit_provider.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/toppings_only_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

import '../Cards/select_multiple_ingredients_card.dart';

class SelectToppingsGridView extends ConsumerWidget {
  const SelectToppingsGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProductUID = ref.watch(selectedProductUIDProvider);
    return ProductQuantityLimitProviderWidget(
      productUID: selectedProductUID!,
      builder: (quantityLimits) => ToppingsOnlyProviderWidget(
        builder: (toppings) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quantityLimits.toppingsDescriptor!,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Spacing.vertical(10),
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
      ),
    );
  }
}
