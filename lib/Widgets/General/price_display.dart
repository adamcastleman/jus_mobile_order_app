import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Views/membership_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

import '../../Providers/stream_providers.dart';

class PriceDisplay extends ConsumerWidget {
  final ProductModel product;
  const PriceDisplay({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(
              error: e.toString(),
            ),
        data: (user) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              determinePriceRow(ref, user),
              Spacing().vertical(10),
              Row(
                children: [
                  determineSavedAmount(ref, user),
                  Spacing().horizontal(5),
                  InkWell(
                    child: const Icon(
                      CupertinoIcons.info,
                      size: 15,
                    ),
                    onTap: () {
                      ModalBottomSheet().fullScreen(
                        context: context,
                        builder: (context) => const MembershipDetailPage(),
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }

  determinePriceRow(WidgetRef ref, UserModel user) {
    final quantity = ref.watch(itemQuantityProvider);
    final daysQuantity = ref.watch(daysQuantityProvider);
    final currentUser = ref.watch(currentUserProvider);
    final selectedSize = ref.watch(selectedSizeProvider);
    return Row(
      children: [
        AutoSizeText(
          'Non-Member: \$${((((product.price[selectedSize]['amount']) / 100) * daysQuantity) + totalExtraChargeItems(ref)).toStringAsFixed(2)}${quantity == 1 ? '' : '/ea'}',
          style: TextStyle(
              fontSize: 14,
              fontWeight:
                  (currentUser.value?.uid == null || !user.isActiveMember!)
                      ? FontWeight.bold
                      : FontWeight.normal),
        ),
        Spacing().horizontal(5),
        const Text('|'),
        Spacing().horizontal(5),
        AutoSizeText(
          'Members: \$${(((product.memberPrice[selectedSize]['amount'] / 100) * daysQuantity) + totalExtraChargeItemsMembers(ref)).toStringAsFixed(2)}${quantity == 1 ? '' : '/ea'}',
          maxLines: 1,
          style: TextStyle(
              fontSize: 14,
              fontWeight: currentUser.value?.uid == null
                  ? FontWeight.normal
                  : user.isActiveMember!
                      ? FontWeight.bold
                      : FontWeight.normal),
        ),
      ],
    );
  }

  determineSavedAmount(WidgetRef ref, UserModel user) {
    final quantity = ref.watch(itemQuantityProvider);
    final daysQuantity = ref.watch(daysQuantityProvider);
    final selectedSize = ref.watch(selectedSizeProvider);
    final currentUser = ref.watch(currentUserProvider);
    final totalSaved = ((((product.price[selectedSize]['amount'] / 100) +
                    totalExtraChargeItems(ref)) -
                ((product.memberPrice[selectedSize]['amount'] / 100) +
                    totalExtraChargeItemsMembers(ref))) *
            quantity *
            daysQuantity)
        .toStringAsFixed(2);
    if (currentUser.value?.uid == null || !user.isActiveMember!) {
      return Text('You could have saved \$$totalSaved',
          style: const TextStyle(fontWeight: FontWeight.bold));
    } else {
      return Text('You saved \$$totalSaved',
          style: const TextStyle(fontWeight: FontWeight.bold));
    }
  }

  totalExtraChargeItems(WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    double total = 0;
    for (var item in selectedIngredients) {
      total = total + double.parse((item['price']).toString());
    }

    return total;
  }

  totalExtraChargeItemsMembers(WidgetRef ref) {
    final selectedIngredients = ref.watch(selectedIngredientsProvider);
    double total = 0;
    for (var item in selectedIngredients) {
      total = total + double.parse((item['memberPrice']).toString());
    }
    return total;
  }
}
