import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/points_providers.dart';

class PointsValueItemWidget extends ConsumerWidget {
  final double fontSize;
  final double padding;
  final bool hasBorder;
  final ProductModel product;

  const PointsValueItemWidget({
    required this.product,
    required this.fontSize,
    required this.padding,
    required this.hasBorder,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(pointsInformationProvider);
    var qualifyingProducts = points.rewardsAmounts
        .where((element) => element['products'].contains(product.productId));

    return qualifyingProducts.isEmpty
        ? const SizedBox()
        : Wrap(
            children: [
              Container(
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  border: hasBorder ? Border.all(width: 0.5) : null,
                ),
                child: Text(
                  '${qualifyingProducts.first['amount']}-point item',
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ],
          );
  }
}
