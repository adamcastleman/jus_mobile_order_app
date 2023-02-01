import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';

class ProductDescription extends StatelessWidget {
  final List<ProductModel> products;
  final int itemIndex;
  final double fontSize;
  const ProductDescription(
      {required this.products,
      required this.itemIndex,
      required this.fontSize,
      super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: AutoSizeText(
        products[itemIndex].description,
        style: TextStyle(fontSize: fontSize),
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
        maxLines: 3,
      ),
    );
  }
}
