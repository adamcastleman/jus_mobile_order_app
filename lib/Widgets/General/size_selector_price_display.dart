import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class SizeAndPriceSelector extends ConsumerWidget {
  final ProductModel product;
  const SizeAndPriceSelector({required this.product, super.key});
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
              determineSizeSelector(user, ref),
              Spacing().vertical(10),
              displayPrice(user, ref),
            ],
          );
        });
  }

  displayPrice(UserModel user, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final selectedSize = ref.watch(selectedSizeProvider);
    final quantity = ref.watch(itemQuantityProvider);
    if (currentUser.value?.uid == null || !user.isActiveMember!) {
      return Text(
          'You could have saved \$${((((product.price[selectedSize]['amount'] / 100) + totalExtraChargeItems(ref)) - ((product.memberPrice[selectedSize]['amount'] / 100) + totalExtraChargeItemsMembers(ref))) * quantity).toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold));
    } else {
      return Text(
          'You saved \$${((((product.price[selectedSize]['amount'] / 100) + totalExtraChargeItems(ref)) - ((product.memberPrice[selectedSize]['amount'] / 100) + totalExtraChargeItemsMembers(ref))) * quantity).toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold));
    }
  }

  determineSizeSelector(UserModel user, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final quantity = ref.watch(itemQuantityProvider);
    final selectedSize = ref.watch(selectedSizeProvider);
    if (product.isModifiable != true) {
      return Row(
        children: [
          AutoSizeText(
            'Non-Member: \$${(product.price[0]['amount'] / 100).toStringAsFixed(2)}${quantity == 1 ? '' : '/ea'}',
            style: TextStyle(
                fontSize: 14,
                fontWeight:
                    currentUser.value?.uid == null || !user.isActiveMember!
                        ? FontWeight.bold
                        : FontWeight.normal),
          ),
          Spacing().horizontal(5),
          const Text('|'),
          Spacing().horizontal(5),
          AutoSizeText(
            'Members: \$${(product.memberPrice[0]['amount'] / 100).toStringAsFixed(2)}${quantity == 1 ? '' : '/ea'}',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            product.price.length,
            (index) => InkWell(
              onTap: () {
                ref.read(selectedSizeProvider.notifier).state = index;
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16.0),
                height: 70,
                width: 70,
                child: Card(
                  elevation: 2,
                  color: selectedSize == index
                      ? Colors.blueGrey[50]
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(
                        color: selectedSize == index
                            ? Colors.blueGrey
                            : Colors.transparent,
                        width: 0.5),
                  ),
                  child: Center(
                    child: Text('${product.price[index]['name']}'),
                  ),
                ),
              ),
            ),
          ),
        ),
        Spacing().vertical(25),
        Row(
          children: [
            AutoSizeText(
              'Non-Member: \$${((product.price[selectedSize]['amount'] / 100) + totalExtraChargeItems(ref)).toStringAsFixed(2)}${quantity == 1 ? '' : '/ea'}',
              maxLines: 1,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      currentUser.value?.uid == null || !user.isActiveMember!
                          ? FontWeight.bold
                          : FontWeight.normal),
            ),
            Spacing().horizontal(5),
            const Text('|'),
            Spacing().horizontal(5),
            AutoSizeText(
              'Members: \$${((product.memberPrice[selectedSize]['amount'] / 100) + totalExtraChargeItemsMembers(ref)).toStringAsFixed(2)}${quantity == 1 ? '' : '/ea'}',
              maxLines: 1,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: currentUser.value?.uid == null
                      ? FontWeight.normal
                      : user.isActiveMember!
                          ? FontWeight.bold
                          : FontWeight.normal),
            ),
          ],
        ),
      ],
    );
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
