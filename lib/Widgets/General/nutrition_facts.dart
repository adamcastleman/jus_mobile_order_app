import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class NutritionFacts extends ConsumerWidget {
  final ProductModel product;
  const NutritionFacts({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSize = ref.watch(selectedSizeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutrition',
          style: Theme.of(context).textTheme.headline6,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              determineStandardRecipeText(),
              !product.isModifiable && !product.isScheduled
                  ? const Text(
                      'Percentages are based on a 2,000 calorie diet.',
                      style: TextStyle(fontSize: 12),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.all(8.0),
          primary: false,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1 / 1,
          ),
          itemCount: product.nutrition[selectedSize].length,
          itemBuilder: (context, index) => Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  product.nutrition[selectedSize]['$index']['name'].toString(),
                  maxLines: 1,
                ),
                AutoSizeText(
                  product.nutrition[selectedSize]['$index']['amount']
                      .toString(),
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
        Spacing().vertical(5),
        !product.isScheduled
            ? AutoSizeText(
                'Servings of fruit: ${product.servingsFruit} | Servings of veggies: ${product.servingsVeggie}',
                style: const TextStyle(fontSize: 15),
                maxLines: 1,
              )
            : const SizedBox(),
      ],
    );
  }

  determineStandardRecipeText() {
    TextStyle textStyle = const TextStyle(fontSize: 12);
    if (product.isModifiable) {
      return Text(
        'Based on standard recipe with no modifications',
        style: textStyle,
      );
    } else {
      return const SizedBox();
    }
  }
}
