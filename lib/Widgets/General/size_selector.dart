import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/constants.dart';

class SizeSelector extends ConsumerWidget {
  final ProductModel product;
  const SizeSelector({required this.product, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSize = ref.watch(itemSizeProvider);
    final selectedCardColor = ref.watch(selectedCardColorProvider);
    final selectedCardBorderColor = ref.watch(selectedCardBorderColorProvider);
    var variations = product.variations
        .where(
            (element) => element['customerType'] == AppConstants.nonMemberType)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            product.variations.length ~/ 2,
            (index) => InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                ref.read(itemSizeProvider.notifier).state = index;
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16.0),
                height: 70,
                width: 70,
                child: Card(
                  elevation: 1,
                  color:
                      selectedSize == index ? selectedCardColor : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        color: selectedSize == index
                            ? selectedCardBorderColor
                            : Colors.transparent,
                        width: 0.5),
                  ),
                  child: Center(
                    child: Text('${variations[index]['name']}'),
                  ),
                ),
              ),
            ),
          ),
        ),
        Spacing.vertical(25),
        //
      ],
    );
  }
}
