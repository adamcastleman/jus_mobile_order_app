import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Widgets/General/item_price_display.dart';
import 'package:jus_mobile_order_app/Widgets/General/select_modifier_options.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/ingredient_grid_view.dart';
import 'package:jus_mobile_order_app/Widgets/Lists/modify_ingredients_list.dart';

class ProductModifierPage extends StatelessWidget {
  final ProductModel product;
  const ProductModifierPage({required this.product, super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 12.0),
                  child: Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 18.0),
                  child: PriceDisplay(product: product),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: ModifyIngredientsList(),
                ),
                Spacing().vertical(10),
                const Divider(
                  thickness: 0.5,
                  color: Colors.black,
                ),
                Expanded(
                  child: IngredientGridView(
                    product: product,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SelectModifierOptions(
              product: product,
            ),
          )
        ],
      ),
    );
  }
}
