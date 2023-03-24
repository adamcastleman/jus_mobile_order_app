import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
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
    return PointsDetailsProviderWidget(
      builder: (points) => Material(
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
                  _buildQuantityRow(context),
                  _buildDaysRow(context),
                  _determineAddToCartRow(context, ref, points),
                ],
              ),
            ),
          ],
        ),
      ),
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
          const QuantityPickerButton(
            daysPicker: false,
          ),
        ],
      ),
    );
  }

  _buildDaysRow(BuildContext context) {
    if (!product.isScheduled) {
      return const SizedBox();
    } else {
      return Padding(
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
      );
    }
  }

  _determineAddToCartRow(BuildContext context, WidgetRef ref, points) {
    final isModifiable = ref.watch(isModifiableProductProvider);
    final editOrder = ref.watch(editOrderProvider);
    final selectedLocation = LocationHelper().selectedLocation(ref);

    if (selectedLocation == null) {
      return const LargeUntappableButton(
          buttonText: 'Please select a location to order');
    }

    final isProductInStock = LocationHelper().productInStock(ref, product);
    final isLocationAcceptingOrders = LocationHelper().acceptingOrders(ref);
    final isTimeAcceptingOrders = Time().acceptingOrders(context, ref);

    if (!isProductInStock &&
        !isLocationAcceptingOrders &&
        !product.isScheduled) {
      return const LargeUntappableButton(buttonText: 'Not Available');
    }

    if (!isLocationAcceptingOrders ||
        !isTimeAcceptingOrders && !product.isScheduled) {
      return LargeUntappableButton(
          buttonText:
              '${LocationHelper().name(ref)} is not accepting pickup orders');
    }

    if (!isProductInStock) {
      return const LargeUntappableButton(buttonText: 'Not Available');
    }

    final button = isModifiable
        ? _buildCustomizableButton(ref, editOrder, points, context)
        : _buildAddToCartButton(ref, editOrder, points, context);

    return button;
  }

  _buildCustomizableButton(ref, editOrder, points, context) {
    return Row(
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
            _updateCart(ref, editOrder, points, context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  _buildAddToCartButton(ref, editOrder, points, context) {
    return LargeElevatedButton(
      buttonText: editOrder ? 'Update' : 'Add to Cart',
      onPressed: () {
        _updateCart(ref, editOrder, points, context);
        Navigator.pop(context);
      },
    );
  }

  _updateCart(ref, editOrder, points, context) {
    editOrder
        ? ProductHelpers(ref: ref).editItemInCart(product, points)
        : ProductHelpers(ref: ref).addToCart(product, points);
    ProductHelpers(ref: ref).addCost(product, points);
  }
}
