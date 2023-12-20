import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/products.dart';
import 'package:jus_mobile_order_app/Helpers/set_standard_ingredients.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Models/points_details_model.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/product_quantity_limit_provider.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outlined_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/untappable_elevated_button_large.dart';

class AddToBagRow extends ConsumerWidget {
  final ProductModel product;
  final Function close;
  const AddToBagRow({required this.product, required this.close, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isModifiable = ref.watch(isModifiableProductProvider);
    final selectedLocation = LocationHelper().selectedLocation(ref);
    final isProductInStock = LocationHelper().isProductInStock(ref, product);
    final isLocationAcceptingOrders = LocationHelper().acceptingOrders(ref);
    final isTimeAcceptingOrders = Time().acceptingOrders(context, ref);

    if (selectedLocation == null) {
      return const LargeUntappableButton(
          buttonText: 'Please select a location to order');
    }

    if (!isProductInStock ||
        (!isLocationAcceptingOrders && !product.isScheduled)) {
      return const LargeUntappableButton(buttonText: 'Not Available');
    }

    if (!isLocationAcceptingOrders ||
        !isTimeAcceptingOrders && !product.isScheduled) {
      return LargeUntappableButton(
          buttonText:
              '${LocationHelper().locationName(ref)} is not accepting pickup orders');
    }

    return isModifiable
        ? _buildCustomizableRow(context, ref)
        : _buildNonCustomizableAddToCartButton(context, ref);
  }

  _buildCustomizableRow(BuildContext context, WidgetRef ref) {
    final editOrder = ref.watch(editOrderProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MediumOutlineButton(
          buttonText: 'Customize',
          buttonColor: Colors.white,
          onPressed: () {
            HapticFeedback.lightImpact();
            StandardIngredients(ref: ref).add();
            close();
          },
        ),
        ProductQuantityLimitProviderWidget(
          productUID: product.uid,
          builder: (quantityLimit) => PointsDetailsProviderWidget(
            builder: (points) => MediumElevatedButton(
              buttonText: editOrder ? 'Update' : 'Add to Bag',
              onPressed: () {
                _addToBagAndUpdateCosts(context, ref, points, quantityLimit);
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  _buildNonCustomizableAddToCartButton(
    BuildContext context,
    WidgetRef ref,
  ) {
    final editOrder = ref.watch(editOrderProvider);
    return ProductQuantityLimitProviderWidget(
      productUID: product.uid,
      builder: (quantityLimit) => PointsDetailsProviderWidget(
        builder: (points) => LargeElevatedButton(
          buttonText: editOrder ? 'Update' : 'Add to Bag',
          onPressed: () {
            _addToBagAndUpdateCosts(context, ref, points, quantityLimit);
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _addToBagAndUpdateCosts(
    BuildContext context,
    WidgetRef ref,
    PointsDetailsModel points,
    ProductQuantityModel quantityLimit,
  ) {
    final editOrder = ref.watch(editOrderProvider);
    if (product.isScheduled) {
      OrderHelpers(ref: ref).setScheduledLimitProviders(quantityLimit);
    }
    if (editOrder) {
      ProductHelpers(ref: ref).editItemInBag(product, points);
    } else {
      ProductHelpers(ref: ref).addToBag(product, points);
    }
    ProductHelpers(ref: ref).addCost(product, points);
  }
}
