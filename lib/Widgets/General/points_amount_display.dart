import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/points_details_provider_widget.dart';

class PointsAmountDisplay extends StatelessWidget {
  final double fontSize;
  final double padding;
  final bool hasBorder;
  final ProductModel product;
  const PointsAmountDisplay(
      {required this.product,
      required this.fontSize,
      required this.padding,
      required this.hasBorder,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PointsDetailsProviderWidget(builder: (points) {
      var qualifyingProducts = points.rewardsAmounts
          .where((element) => element['products'].contains(product.productID));
      return qualifyingProducts.isEmpty
          ? const SizedBox()
          : Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                border: hasBorder ? Border.all(width: 0.5) : null,
              ),
              child: Text(
                '${qualifyingProducts.first['amount']}-point item',
                style: TextStyle(fontSize: fontSize),
              ),
            );
    });
  }
}
