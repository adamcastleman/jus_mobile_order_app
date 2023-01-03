import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';

class CategorySelector extends HookConsumerWidget {
  const CategorySelector({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(themeColorProvider);
    final products = Platform.isIOS || Platform.isAndroid
        ? ref.watch(taxableProductsProvider)
        : ref.watch(productsProvider);
    final currentCategory = ref.watch(selectedCategoryFromScrollProvider);
    final controller = useScrollController();
    List filteredList = filterCategoryDuplicates(products);
    double itemWidth = 80;
    return SizedBox(
      height: 40,
      child: products.when(
        loading: () => const Loading(),
        error: (Object e, _) => ShowError(error: e.toString()),
        data: (data) => ListView.builder(
            physics: const ClampingScrollPhysics(),
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              currentCategory == filteredList[index]['order']
                  ? controller.animateTo(
                      (itemWidth * (currentCategory - 1.75)).toDouble(),
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease)
                  : null;
              return InkWell(
                onTap: () {
                  ref.watch(categoryOrderProvider.notifier).state =
                      filteredList[index]['order'];
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: currentCategory == filteredList[index]['order']
                              ? Colors.black
                              : backgroundColor!),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      filteredList[index]['category'],
                      style: TextStyle(
                          fontWeight:
                              currentCategory == filteredList[index]['order']
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  filterCategoryDuplicates(AsyncValue<List<ProductModel>> products) {
    List categoryList = [];
    List filteredList = [];
    for (var product in products.value!) {
      Map newMap = {
        'category': product.category,
        'order': product.categoryOrder,
      };
      categoryList.add(newMap);
    }
    final flattenList = categoryList.map((item) => jsonEncode(item)).toList();
    final removeDuplicatesFromCategoryList = flattenList.toSet().toList();
    final filteredCategoryList = removeDuplicatesFromCategoryList
        .map((item) => jsonDecode(item))
        .toList();
    filteredList = filteredCategoryList;
    return filteredList;
  }
}
