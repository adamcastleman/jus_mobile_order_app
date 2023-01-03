import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outline_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/set_standard_ingredients.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/Sheets/add_to_cart_sheet.dart';

class LargeItemCardActionsRow extends ConsumerWidget {
  final ProductModel product;
  final Function? close;

  const LargeItemCardActionsRow({this.close, required this.product, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(taxableProductsProvider);

    return products.when(
      data: (data) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: MediumOutlineButton(
                buttonText: 'Details',
                onPressed: () {
                  StandardIngredients(ref: ref).set(product);
                  close != null ? close!() : null;
                }),
          ),
          Spacing().horizontal(10),
          Flexible(
            child: MediumElevatedButton(
                buttonText: 'Add to cart',
                onPressed: () {
                  StandardIngredients(ref: ref).set(product);
                  ModalBottomSheet().partScreen(
                    isDismissible: true,
                    isScrollControlled: true,
                    enableDrag: false,
                    context: context,
                    builder: (context) => Wrap(
                      children: [
                        AddToCartOptions(product: product),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      loading: () => const Loading(),
    );
  }
}
