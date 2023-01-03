import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/quantity_picker_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/size_selector_price_display.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/select_toppings_grid_view.dart';

class AddToCartOptions extends ConsumerWidget {
  final ProductModel product;
  const AddToCartOptions({required this.product, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.brown[50],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      elevation: 30,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 20, right: 20, bottom: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20.0),
                  child: SizeAndPriceSelector(
                    product: product,
                  ),
                ),
                determineSelectToppingsGrid(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quantity',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const QuantityPickerButton(),
                  ],
                ),
                Spacing().vertical(15),
                LargeElevatedButton(
                  buttonText: 'Add to cart',
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  determineSelectToppingsGrid() {
    if (product.isModifiable == false && product.hasToppings) {
      return const SelectToppingsGridView(
        isQuickAdd: true,
      );
    } else {
      return const SizedBox();
    }
  }
}
