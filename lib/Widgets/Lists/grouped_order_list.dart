import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Hooks/grouped_scroll_controller.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/item_card_large.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GroupedOrderList extends HookConsumerWidget {
  const GroupedOrderList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(taxableProductsProvider);
    final tappedCategory = ref.watch(categoryOrderProvider);
    final controller = useGroupedItemScrollController();
    int itemIndex = (products.value!
        .indexWhere((element) => element.categoryOrder == tappedCategory));
    tappedCategory == 0
        ? null
        : controller.scrollTo(
            index: itemIndex, duration: const Duration(milliseconds: 500));

    return products.when(
      loading: () => const Loading(),
      error: (Object e, _) => ShowError(error: e.toString()),
      data: (data) {
        return StickyGroupedListView(
          itemScrollController: controller,
          elements: mapItems(products),
          groupBy: (dynamic element) => element['categoryOrder'],
          groupSeparatorBuilder: (dynamic element) =>
              groupSeparator(context, element),
          initialScrollIndex: 0,
          indexedItemBuilder: (context, dynamic element, int index) {
            return VisibilityDetector(
              key: GlobalKey(),
              onVisibilityChanged: (VisibilityInfo info) {
                Future(() {
                  ref.read(selectedCategoryFromScrollProvider.notifier).state =
                      element['categoryOrder'];
                });
              },
              child: ItemCardLarge(
                index: index,
              ),
            );
          },
          order: StickyGroupedListOrder.ASC,
        );
      },
    );
  }

  mapItems(AsyncValue<List<ProductModel>> products) {
    List newList = [];

    for (var product in products.value!) {
      Map newMap = {
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
      };

      newList.add(newMap);
    }

    return newList;
  }

  groupSeparator(BuildContext context, dynamic element) {
    return Consumer(
      builder: (context, ref, child) => Container(
        color: ref.watch(themeColorProvider),
        padding: const EdgeInsets.only(left: 12, bottom: 22.0),
        child: Text(
          '${element['category']}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
