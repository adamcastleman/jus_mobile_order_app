import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outline_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/quantity_picker_button.dart';

import '../Helpers/set_standard_ingredients.dart';

class SelectProductOptions extends ConsumerWidget {
  final Function close;
  const SelectProductOptions({required this.close, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      elevation: 30,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 20, right: 20, bottom: 40.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const QuantityPickerButton(),
                    ],
                  ),
                ),
                determineAddToCartRow(ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  determineAddToCartRow(WidgetRef ref) {
    final isModifiable = ref.watch(isModifiableProductProvider);
    if (isModifiable == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediumOutlineButton(
            buttonText: 'Modify',
            buttonColor: Colors.white,
            onPressed: () {
              StandardIngredients(ref: ref).add();
              close();
            },
          ),
          MediumElevatedButton(
            buttonText: 'Add to cart',
            onPressed: () {},
          ),
        ],
      );
    } else {
      return LargeElevatedButton(
        buttonText: 'Add to cart',
        onPressed: () {},
      );
    }
  }
}
