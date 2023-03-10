import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Hooks/grouped_scroll_controller.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/item_card_large.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ListOfTaxableProductsByGroup extends HookConsumerWidget {
  const ListOfTaxableProductsByGroup({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(taxableProductsProvider);
    final tappedCategory = ref.watch(categoryOrderProvider);
    final controller = useGroupedItemScrollController();

    return products.when(
      loading: () => const Loading(),
      error: (Object e, _) => ShowError(error: e.toString()),
      data: (product) {
        int itemIndex = product
            .indexWhere((element) => element.categoryOrder == tappedCategory);
        if (tappedCategory != 0) {
          controller.scrollTo(
              index: itemIndex, duration: const Duration(milliseconds: 500));
        }

        return StickyGroupedListView(
          itemScrollController: controller,
          elements: mapItems(product),
          groupBy: (element) => element['categoryOrder'],
          groupSeparatorBuilder: (element) => groupSeparator(context, element),
          initialScrollIndex: 0,
          indexedItemBuilder: (context, element, index) {
            return VisibilityDetector(
              key: GlobalKey(),
              onVisibilityChanged: (VisibilityInfo info) {
                Future(() {
                  ref.read(selectedCategoryFromScrollProvider.notifier).state =
                      element['categoryOrder'];
                });
              },
              child: LargeItemCard(
                index: index,
              ),
            );
          },
          order: StickyGroupedListOrder.ASC,
        );
      },
    );
  }

  List<Map<String, dynamic>> mapItems(List<ProductModel> products) {
    return products
        .map((product) => {
              'uid': product.uid,
              'name': product.name,
              'category': product.category,
              'categoryOrder': product.categoryOrder,
              'price': product.price,
              'memberPrice': product.memberPrice,
              'ingredients': product.ingredients,
              'isActive': product.isActive,
              'isModifiable': product.isModifiable,
              'isFeatured': product.isFeatured,
              'isRecommended': product.isRecommended,
              'isTaxable': product.taxable,
            })
        .toList();
  }

  groupSeparator(BuildContext context, dynamic element) {
    return Consumer(
      builder: (context, ref, child) {
        final themeColor = ref.watch(backgroundColorProvider);
        return Container(
          color: themeColor,
          padding: const EdgeInsets.only(left: 12, bottom: 22.0),
          child: Text(
            '${element['category']}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        );
      },
    );
  }
}
