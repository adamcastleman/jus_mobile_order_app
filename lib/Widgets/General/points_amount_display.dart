import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

class PointsAmountDisplay extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(pointsDetailsProvider);

    return points.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (points) => Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          border: hasBorder ? Border.all(width: 0.5) : null,
        ),
        child: Text(
          '${points.rewardsAmounts.where((element) => element['products'].contains(product.productID)).first['amount']}-point item',
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}
