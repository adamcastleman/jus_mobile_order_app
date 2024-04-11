import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';

class NewIcon extends StatelessWidget {
  final ProductModel product;
  const NewIcon({required this.product, super.key});
  @override
  Widget build(BuildContext context) {
    double imageSize = ResponsiveLayout.isWeb(context) ? 75 : 50;

    return SizedBox(
      height: imageSize,
      width: imageSize,
      child: Image.asset('assets/new_icon.png'),
    );
  }
}
