import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

import '../../Models/ingredient_model.dart';
import '../../Providers/product_providers.dart';

class SelectToppingsCard extends ConsumerWidget {
  final IngredientModel topping;
  const SelectToppingsCard({required this.topping, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedToppings = ref.watch(selectedToppingsProvider);
    return InkWell(
      onTap: () {
        if (selectedToppings.contains(topping.id)) {
          ref.read(selectedToppingsProvider.notifier).remove(topping.id);
        } else {
          ref.read(selectedToppingsProvider.notifier).add(topping.id);
        }
      },
      child: SizedBox(
        width: 100,
        child: Card(
          color: selectedToppings.contains(topping.id)
              ? Colors.blueGrey[50]
              : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: selectedToppings.contains(topping.id)
                    ? Colors.blueGrey
                    : Colors.white),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: CachedNetworkImage(
                  imageUrl: topping.image,
                ),
              ),
              Spacing().vertical(5),
              AutoSizeText(
                topping.name,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              Spacing().vertical(8),
            ],
          ),
        ),
      ),
    );
  }
}
