import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/product_quantity_limit_provider.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/quantity_picker_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/select_product_add_to_cart.dart';

class SelectProductOptions extends ConsumerWidget {
  final ProductModel product;
  final Function close;
  const SelectProductOptions(
      {required this.close, required this.product, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProductQuantityLimitProviderWidget(
      productUID: product.uid,
      builder: (quantityLimit) {
        return PointsDetailsProviderWidget(
          builder: (points) => Material(
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            elevation: 30,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 20, right: 20, bottom: 40.0),
                  child: Column(
                    children: [
                      _buildQuantityRow(context),
                      _buildScheduledRow(context, quantityLimit),
                      AddToCartRow(
                        product: product,
                        close: close,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildQuantityRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Quantity',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          QuantityPickerButton(
            product: product,
            scheduledPicker: false,
          ),
        ],
      ),
    );
  }

  _buildScheduledRow(BuildContext context, ProductQuantityModel quantityLimit) {
    if (!product.isScheduled) {
      return const SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              quantityLimit.scheduledProductDescriptor ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            QuantityPickerButton(
              product: product,
              scheduledPicker: true,
            ),
          ],
        ),
      );
    }
  }
}
