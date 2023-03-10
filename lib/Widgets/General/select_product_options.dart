import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outline_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/quantity_picker_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/untappable_elevated_button_large.dart';

import '../../Helpers/set_standard_ingredients.dart';

class SelectProductOptions extends ConsumerWidget {
  final ProductModel product;
  final Function close;
  const SelectProductOptions(
      {required this.close, required this.product, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsDetail = ref.watch(pointsDetailsProvider);
    return pointsDetail.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (points) => Material(
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
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const QuantityPickerButton(
                          daysPicker: false,
                        ),
                      ],
                    ),
                  ),
                  product.isScheduled
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Number of Days',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const QuantityPickerButton(
                                daysPicker: true,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  determineAddToCartRow(context, ref, points),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  determineAddToCartRow(BuildContext context, WidgetRef ref, points) {
    final isModifiable = ref.watch(isModifiableProductProvider);
    final editOrder = ref.watch(editOrderProvider);

    if (LocationHelper().selectedLocation(ref) == null ||
        product.isScheduled ||
        (LocationHelper().productInStock(ref, product) &&
            LocationHelper().acceptingOrders(ref) &&
            Time().acceptingOrders(context, ref))) {
      return isModifiable
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MediumOutlineButton(
                  buttonText: 'Customize',
                  buttonColor: Colors.white,
                  onPressed: () {
                    StandardIngredients(ref: ref).add();
                    close();
                  },
                ),
                MediumElevatedButton(
                  buttonText: editOrder ? 'Update' : 'Add to Cart',
                  onPressed: () {
                    editOrder
                        ? ProductHelpers(ref: ref)
                            .editItemInCart(product, points)
                        : ProductHelpers(ref: ref).addToCart(product, points);
                    ProductHelpers(ref: ref).addCost(product, points);
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          : LargeElevatedButton(
              buttonText: editOrder ? 'Update' : 'Add to Cart',
              onPressed: () {
                editOrder
                    ? ProductHelpers(ref: ref).editItemInCart(product, points)
                    : ProductHelpers(ref: ref).addToCart(product, points);
                ProductHelpers(ref: ref).addCost(product, points);
                Navigator.pop(context);
              },
            );
    } else {
      return LargeUntappableButton(
          buttonText: (!Time().acceptingOrders(context, ref) ||
                  !LocationHelper().acceptingOrders(ref))
              ? '${LocationHelper().name(ref)} is not accepting pickup orders'
              : 'Not Available');
    }
  }
}
