import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Widgets/General/item_price_display.dart';
import 'package:jus_mobile_order_app/Widgets/General/member_savings_widget.dart';

class ProductFinancialDetails extends StatelessWidget {
  final UserModel user;
  final ProductModel product;
  final VoidCallback memberInfoOnTap;
  const ProductFinancialDetails(
      {required this.user,
      required this.product,
      required this.memberInfoOnTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PriceDisplay(product: product, user: user),
        Spacing.vertical(10),
        Row(
          children: [
            MemberSavingsWidget(
              user: user,
              product: product,
              onTap: memberInfoOnTap,
            ),
          ],
        ),
      ],
    );
  }
}
