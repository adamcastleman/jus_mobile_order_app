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
  const CategorySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final products = Platform.isIOS || Platform.isAndroid
        ? ref.watch(taxableProductsProvider)
        : ref.watch(productsProvider);
    final currentCategory = ref.watch(currentCategoryProvider);
    final selectedCategory = ref.watch(tappedCategoryProvider);
    final controller = useScrollController();

    return SizedBox(
      height: 40,
      child: products.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(error: e.toString()),
        data: (product) {
          final filteredList = filterCategoryDuplicates(product);
          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            controller: controller,
            scrollDirection: Axis.horizontal,
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              _scrollToCategory(
                  ref, filteredList, index, currentCategory, controller);
              return InkWell(
                onTap: () {
                  ref.read(scrollSourceProvider.notifier).state = 'tapped';
                  ref.read(tappedCategoryProvider.notifier).state =
                      filteredList[index]['order'];
                  ref.read(currentCategoryProvider.notifier).state =
                      filteredList[index]['order'];
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: currentCategory == filteredList[index]['order']
                            ? Colors.black
                            : backgroundColor,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      filteredList[index]['category'],
                      style: TextStyle(
                        fontWeight:
                            currentCategory == filteredList[index]['order']
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
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
    List<ProductModel> products,
  ) {
    return products.fold(<Map<String, dynamic>>[],
        (List<Map<String, dynamic>> uniqueCategories, ProductModel product) {
      final String category = product.category;
      final int categoryOrder = product.categoryOrder;

      final bool categoryExists = uniqueCategories
          .any((categoryMap) => categoryMap['category'] == category);
      if (!categoryExists) {
        uniqueCategories.add({'category': category, 'order': categoryOrder});
      }
      return uniqueCategories;
    });
  }

  void _scrollToCategory(WidgetRef ref, List filteredList, int index,
      int currentCategory, ScrollController controller) {
    final itemWidth = ref.watch(categoryItemWidthProvider);
    final isCurrentCategory = currentCategory == filteredList[index]['order'];
    if (isCurrentCategory) {
      controller.animateTo(
        (itemWidth * (currentCategory - 1.75)).toDouble(),
        duration: const Duration(milliseconds: 100),
        curve: Curves.ease,
      );
    }
  }
}
