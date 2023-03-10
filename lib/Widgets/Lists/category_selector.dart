import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';

class CategorySelector extends HookConsumerWidget {
  const CategorySelector({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final products = Platform.isIOS || Platform.isAndroid
        ? ref.watch(taxableProductsProvider)
        : ref.watch(productsProvider);
    final currentCategory = ref.watch(selectedCategoryFromScrollProvider);
    final controller = useScrollController();

    double itemWidth = 80;
    return SizedBox(
      height: 40,
      child: products.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(error: e.toString()),
        data: (product) {
          List filteredList = filterCategoryDuplicates(product);
          return ListView.builder(
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
                  ref.read(categoryOrderProvider.notifier).state =
                      filteredList[index]['order'];
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: currentCategory == filteredList[index]['order']
                              ? Colors.black
                              : backgroundColor),
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
            },
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> filterCategoryDuplicates(
      List<ProductModel> products) {
    Set<String> categorySet = {};
    List<Map<String, dynamic>> filteredList = [];

    for (var product in products) {
      if (!categorySet.contains(product.category)) {
        categorySet.add(product.category);
        filteredList.add(
            {'category': product.category, 'order': product.categoryOrder});
      }
    }

    return filteredList;
  }
}
