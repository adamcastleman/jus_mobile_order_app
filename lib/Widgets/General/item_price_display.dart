import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class PriceDisplay extends ConsumerWidget {
  final ProductModel product;
  final UserModel user;

  const PriceDisplay({required this.product, required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMember = user.uid != null &&
        user.subscriptionStatus == SubscriptionStatus.active;
    final quantity = ref.watch(itemQuantityProvider);
    final PricingHelpers pricingHelpers = PricingHelpers();
    final nonMemberPrice =
        pricingHelpers.productDetailPriceNonMember(ref, product);
    final memberPrice =
        pricingHelpers.productDetailPriceForMembers(ref, product);
    return Row(
      children: [
        _buildPriceText(
          label: 'Non-Member',
          price: nonMemberPrice,
          quantity: quantity,
          bold: !isMember,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('|'),
        ),
        _buildPriceText(
          label: 'Members',
          price: memberPrice,
          quantity: quantity,
          bold: isMember,
        ),
      ],
    );
  }

  AutoSizeText _buildPriceText(
      {required String label,
      required double price,
      required int quantity,
      required bool bold}) {
    return AutoSizeText(
      '$label: \$${PricingHelpers.formatAsCurrency(price)}${quantity == 1 ? '' : '/ea'}',
      style: TextStyle(
        fontSize: 14,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
