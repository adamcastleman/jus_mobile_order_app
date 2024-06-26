import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Cards/menu_card.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';

class ListOfTaxableProductsByGroup extends HookConsumerWidget {
  const ListOfTaxableProductsByGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final products = ref.watch(allProductsProvider);
    final crossAxisCountMobile =
        ref.watch(productGridCrossAxisCountMobileProvider);
    final crossAxisCountTablet =
        ref.watch(productGridCrossAxisCountTabletProvider);
    final crossAxisCountWeb = ref.watch(productGridCrossAxisCountWebProvider);
    final mainAxisSpacing = ref.watch(productGridMainAxisSpacingProvider);
    final crossAxisSpacing = ref.watch(productGridCrossAxisSpacingProvider);
    final headerHeight = ref.watch(categoryHeaderHeightProvider);
    final aspectRatio = _getAspectRatio(context, ref);

    _scrollToHeader(context, ref, scrollController, products);
    if (PlatformUtils.isIOS() || PlatformUtils.isAndroid()) {
      return _productGridView(
        ref: ref,
        scrollController: scrollController,
        crossAxisCount: crossAxisCountMobile,
        aspectRatio: aspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        headerHeight: headerHeight,
        products: products,
      );
    }
    return ResponsiveLayout(
      mobileBrowser: _productGridView(
        ref: ref,
        scrollController: scrollController,
        crossAxisCount: crossAxisCountMobile,
        aspectRatio: aspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        headerHeight: headerHeight,
        products: products,
      ),
      tablet: _productGridView(
        ref: ref,
        scrollController: scrollController,
        crossAxisCount: crossAxisCountTablet,
        aspectRatio: aspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        headerHeight: headerHeight,
        products: products,
      ),
      web: _productGridView(
        ref: ref,
        scrollController: scrollController,
        crossAxisCount: crossAxisCountWeb,
        aspectRatio: aspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        headerHeight: headerHeight,
        products: products,
      ),
    );
  }

  Widget _productGridView(
      {required WidgetRef ref,
      required int crossAxisCount,
      required double mainAxisSpacing,
      required double crossAxisSpacing,
      required double aspectRatio,
      required ScrollController scrollController,
      required List<ProductModel> products,
      required double headerHeight}) {
    return GroupedListView.grid(
      //If we change the left or right padding here, we also must update the
      //calculation in _calculateCardHeight
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 20,
      ),
      key: const PageStorageKey<String>('my-scroll-key'),
      controller: scrollController,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      itemsAspectRatio: aspectRatio,
      items: products,
      itemGrouper: (ProductModel product) => product.category,
      headerBuilder: (context, category) {
        return _buildCategoryHeader(context, category, headerHeight);
      },
      gridItemBuilder: (context, countInGroup, itemIndexInGroup, product,
              itemIndexInOriginalList) =>
          _buildGridItem(context, countInGroup, itemIndexInGroup, product,
              itemIndexInOriginalList),
    );
  }

  Widget _buildCategoryHeader(
    BuildContext context,
    String category,
    double headerHeight,
  ) {
    return SizedBox(
      height: headerHeight,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          category,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int countInGroup,
      int itemIndexInGroup, ProductModel product, int itemIndexInOriginalList) {
    final categoryItemCount = <int, int>{};
    // keep track of the number of items in each category so that we can use
    // this information later to calculate the total row height and main axis
    // spacing in the _calculateScrollOffset function.
    categoryItemCount.update(
      product.categoryOrder,
      (count) => count + 1,
      ifAbsent: () => 1,
    );

    return MenuCard(product: product);
  }

  Widget groupSeparator(BuildContext context, ProductModel element) {
    return Consumer(
      builder: (context, ref, child) {
        final themeColor = ref.watch(backgroundColorProvider);
        return Container(
          color: themeColor,
          padding: const EdgeInsets.only(left: 12, bottom: 22.0),
          child: Text(
            element.category,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        );
      },
    );
  }

  double _calculateSelectedHeaderHeight(WidgetRef ref) {
    final selectedCategory = ref.watch(tappedCategoryProvider);
    final headerHeight = ref.watch(categoryHeaderHeightProvider);
    return (selectedCategory - 1) * headerHeight;
  }

  double _calculateRowHeight(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = ref.read(ResponsiveLayout.isMobileBrowser(context)
        ? productGridCrossAxisCountMobileProvider
        : ResponsiveLayout.isTablet(context)
            ? productGridCrossAxisCountTabletProvider
            : productGridCrossAxisCountWebProvider);
    final crossAxisSpacing = ref.read(productGridCrossAxisSpacingProvider);
    final aspectRatio = _getAspectRatio(context, ref);

    //Calculate total horizontal padding based on the number of items per row
    //The '+ 20' refers to the fact that we have added 10 px of symmetric,
    //horizontal padding to the GridView - this has adjusted the
    //aspect ratio by that amount, which we adjust for here. If that padding
    //changes up there, it also needs to here.
    final totalHorizontalPadding =
        ((crossAxisCount - 1) * crossAxisSpacing) + 20;

    // Calculate the width and height of each item based on the screen width and aspect ratio
    final itemWidth = (screenWidth - totalHorizontalPadding) / crossAxisCount;
    final itemHeight = itemWidth / aspectRatio;

    return itemHeight;
  }

  //This function calculates the total scroll offset needed to scroll to
  //a selected category. The offset is determined by the height of the
  //selected category's header, the height of each row of items, and the
  //vertical spacing between each row of items.
  double _calculateHeaderOffsetFromCategorySelector(BuildContext context,
      WidgetRef ref, List<ProductModel> products, int tappedCategory) {
    final crossAxisCount = ref.watch(ResponsiveLayout.isMobileBrowser(context)
        ? productGridCrossAxisCountMobileProvider
        : ResponsiveLayout.isTablet(context)
            ? productGridCrossAxisCountTabletProvider
            : productGridCrossAxisCountWebProvider);
    // Calculate the height of the selected category's header.
    final headerHeight = _calculateSelectedHeaderHeight(ref);

    // Calculate the height of each item card in the list.
    final itemHeight = _calculateRowHeight(context, ref);

    // Get the value of the main axis spacing between items in the grid.
    final mainAxisSpacing = ref.watch(productGridMainAxisSpacingProvider);

    // Create a map of category groupings, with each category containing
    // the corresponding items from the products list.
    final categoryGroups =
        groupBy(products, (product) => product.categoryOrder);

    // Initialize variables to keep track of the total row height and
    // vertical spacing between rows.
    double totalRowHeight = 0;
    double totalMainAxisSpacing = 0;

    // Iterate through all category groups up to the selected category
    // to calculate the total row height and vertical spacing needed
    // to scroll to the selected category.
    for (var i = 1; i < tappedCategory; i++) {
      // If the current category exists in the product list, calculate
      // its row height and vertical spacing.
      if (categoryGroups.containsKey(i)) {
        final itemCount = categoryGroups[i]!.length;
        final rowCount = (itemCount / crossAxisCount).ceil();

        // If the row count for the current category is greater than 1,
        // calculate the total vertical spacing between the rows.
        if (rowCount > 1) {
          totalMainAxisSpacing += (rowCount - 1) * mainAxisSpacing;
        }

        // Calculate the total row height for the current category.
        totalRowHeight += rowCount * itemHeight;
      }
    }

    // Calculate the total height needed to scroll to the selected category,
    // which includes the height of the selected category's header, the total
    // row height, and the vertical spacing between rows.
    final totalHeight = headerHeight + totalRowHeight + totalMainAxisSpacing;

    return totalHeight;
  }

  // Calculates the vertical offsets of category headers in the grid view
  // based on the height of each product card, the spacing between the cards,
  // and the height of the category header.
  List<double> _calculateHeaderOffsetFromUserScrolling(
      BuildContext context, WidgetRef ref, List<ProductModel> products) {
    final crossAxisCount = ref.watch(PlatformUtils.isWeb()
        ? productGridCrossAxisCountWebProvider
        : productGridCrossAxisCountMobileProvider);
    // Get the height of the category header from the provider
    final headerHeight = ref.watch(categoryHeaderHeightProvider);

    // Calculate the height of each product card based on the device size and
    // the number of columns in the grid view
    final itemHeight = _calculateRowHeight(context, ref);

    // Get the spacing between the cards from the provider
    final mainAxisSpacing = ref.watch(productGridMainAxisSpacingProvider);

    // Group the products by their category order and calculate the total
    // height of each group
    final categoryGroups =
        groupBy(products, (product) => product.categoryOrder);

    // Initialize an empty list to hold the header offsets
    final headerOffsets = <double>[];

    // Initialize the current offset to zero
    double currentOffset = 0;

    // Loop through each category group to calculate the offset of its header
    for (var i = 1; i <= categoryGroups.length; i++) {
      // Add the current offset to the list of header offsets
      headerOffsets.add(currentOffset);

      // Get the current group and calculate its height based on the number
      // of products and the height of each card
      final group = categoryGroups[i];
      final itemCount = group?.length ?? 0;
      final rowCount = (itemCount / crossAxisCount).ceil();
      final groupHeight = rowCount * itemHeight +
          (rowCount - 1) * mainAxisSpacing +
          headerHeight;

      // Add the group height to the current offset for the next group
      currentOffset += groupHeight;
    }

    // Return the list of header offsets
    return headerOffsets;
  }

  _scrollToHeader(BuildContext context, WidgetRef ref,
      ScrollController scrollController, List<ProductModel> products) {
    final tappedCategory = ref.watch(tappedCategoryProvider);
    var listOfHeaders =
        _calculateHeaderOffsetFromUserScrolling(context, ref, products);

    if (tappedCategory != 0) {
      scrollController.animateTo(
        _calculateHeaderOffsetFromCategorySelector(
            context, ref, products, tappedCategory),
        duration: const Duration(milliseconds: 800),
        curve: Curves.ease,
      );
    }
    scrollController.addListener(() {
      if (ref.read(scrollSourceProvider) == 'tapped') {
        return;
      } else {
        final currentOffset = scrollController.offset;
        final index = listOfHeaders.indexWhere(
          // 20 refers to the symmetric horizontal padding we've added to the
          //grid.
          (headerOffset) => (currentOffset - headerOffset).abs() <= 20,
        );

        if (index != -1) {
          ref.read(currentCategoryProvider.notifier).state = index + 1;
        }
      }
      scrollController.position.isScrollingNotifier.addListener(() {
        final isScrolling = scrollController.position.isScrollingNotifier.value;
        if (!isScrolling) {
          ref.read(scrollSourceProvider.notifier).state = 'scroll';
        }
      });
    });
  }

  _getAspectRatio(BuildContext context, WidgetRef ref) {
    return ref.watch(
      ResponsiveLayout.isMobileBrowser(context)
          ? productGridMobileAspectRatioProvider
          : ResponsiveLayout.isTablet(context)
              ? productGridTabletAspectRatioProvider
              : productGridWebAspectRatioProvider,
    );
  }
}
