import 'package:badges/badges.dart' as badge;
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class BagIcon extends ConsumerWidget {
  final double? iconSize;
  const BagIcon({this.iconSize, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);

    num totalItemAmount = 0;
    for (var item in currentOrder) {
      totalItemAmount = totalItemAmount + item['itemQuantity'];
    }
    return badge.Badge(
      badgeStyle: const BadgeStyle(
        badgeColor: Colors.white,
        borderSide: BorderSide(color: Colors.black, width: 1),
        padding: EdgeInsets.all(6),
      ),
      key: const ValueKey(1),
      position: BadgePosition.topEnd(),
      showBadge: totalItemAmount == 0 ? false : true,
      badgeContent: Text(
        '$totalItemAmount',
        style: TextStyle(
          fontSize: totalItemAmount > 9
              ? 10
              : totalItemAmount > 99
                  ? 8
                  : 12,
        ),
      ),
      child: Icon(
        CupertinoIcons.bag,
        size: iconSize ?? 35,
      ),
    );
  }
}
