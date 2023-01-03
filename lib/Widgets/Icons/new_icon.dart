import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';

class NewIcon extends StatelessWidget {
  final ProductModel product;
  const NewIcon({required this.product, super.key});
  @override
  Widget build(BuildContext context) {
    if (product.isNew == true) {
      return Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset('assets/new_icon.jpg'),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
