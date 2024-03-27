import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/discounts_provider.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/product_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/General/order_tile_display_modifications.dart';
import 'package:jus_mobile_order_app/Widgets/General/order_tile_display_quantity.dart';
import 'package:jus_mobile_order_app/Widgets/General/order_tile_edit_row.dart';
import 'package:jus_mobile_order_app/Widgets/General/order_tile_size_display.dart';

class OrderTile extends ConsumerWidget {
  final int orderIndex;

  const OrderTile({required this.orderIndex, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final isMember = user.uid != null && user.subscriptionStatus!.isActive;
    final products = ref.watch(allProductsProvider);
    final ingredients = ref.watch(allIngredientsProvider);
    final backgroundColor = ref.watch(backgroundColorProvider);
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final onCheckoutPage = ref.watch(isCheckOutPageProvider);
    final product = products.firstWhere(
      (item) => item.productId == currentOrder[orderIndex]['productId'],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: OpenContainer(
        openElevation: 0,
        closedElevation: 0,
        tappable: false,
        transitionType: ContainerTransitionType.fadeThrough,
        transitionDuration: const Duration(milliseconds: 600),
        closedColor: backgroundColor,
        openColor: backgroundColor,
        openBuilder: (context, open) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(selectedProductProvider.notifier).state = product;
          });
          return SafeArea(
            bottom: false,
            top: false,
            child: ProductDetailPage(
              product: product,
              ingredients: ingredients,
              //This handles page changes when we interact with buttons like
              //member pricing info, etc. for Web.
              onNavigationChange: () {
                NavigationHelpers.handleMembershipNavigationOnWeb(context, ref);
              },
            ),
          );
        },
        closedBuilder: (context, close) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: SizedBox(
                width: 65,
                child: CachedNetworkImage(
                  imageUrl: product.image,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        determinePriceDisplay(ref, product, isMember),
                        Spacing.vertical(10),
                        determineDiscountTagDisplay(ref),
                      ],
                    ),
                  ),
                  ListTile(
                    title: AutoSizeText(
                      product.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          onCheckoutPage && product.isScheduled == false
                              ? OrderTileDisplayQuantity(orderIndex: orderIndex)
                              : const SizedBox(),
                          OrderTileSizeDisplay(
                            currentProduct: product,
                            orderIndex: orderIndex,
                          ),
                          Spacing.vertical(3),
                          OrderTileDisplayModifications(
                            currentProduct: product,
                            orderIndex: orderIndex,
                          ),
                          Spacing.vertical(7),
                          Padding(
                            padding: EdgeInsets.only(
                              top: !isMember ? 0 : 12,
                            ),
                            child: onCheckoutPage
                                ? const SizedBox()
                                : OrderTileEditRow(
                                    index: orderIndex,
                                    product: product,
                                    close: close,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  determinePriceDisplay(
      WidgetRef ref, ProductModel currentProduct, bool isMember) {
    final PricingHelpers pricingHelpers = PricingHelpers();
    if (!isMember) {
      return Text(
        pricingHelpers.orderTileProductPriceForNonMembers(
            ref, currentProduct, orderIndex),
        style: const TextStyle(fontSize: 16),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            pricingHelpers.orderTileProductPriceForNonMembers(
                ref, currentProduct, orderIndex),
            style: const TextStyle(
              fontSize: 14,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
          Spacing.horizontal(5),
          Text(
            pricingHelpers.orderTileProductPriceForMembers(
                ref, currentProduct, orderIndex),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      );
    }
  }

  Widget determineDiscountTagDisplay(WidgetRef ref) {
    final matchingIndices = determineOrderIndexOfDiscountedItems(ref);
    Map matchingIndex = {};
    try {
      matchingIndex = matchingIndices.firstWhere(
        (element) => element['index'] == orderIndex,
      );
    } catch (e) {
      matchingIndex = {};
    }

    if (matchingIndex['value'] == 0) {
      return const SizedBox();
    } else {
      return SizedBox(
        width: 125,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          reverse: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                CupertinoIcons.tags,
              ),
              Spacing.horizontal(2),
              matchingIndex['value'] < 2
                  ? const SizedBox()
                  : Text(
                      'x${matchingIndex['value']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
            ],
          ),
        ),
      );
    }
  }

  List<Map<String, dynamic>> determineOrderIndexOfDiscountedItems(
      WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderItemsProvider);
    final currentOrderDiscounts = ref.watch(discountTotalProvider);
    List<Map<String, dynamic>> orderDiscountIndexes = [];
    for (int i = 0; i < currentOrder.length; i++) {
      int value = currentOrderDiscounts
          .where(
              (discount) => discount['itemKey'] == currentOrder[i]['itemKey'])
          .length;
      orderDiscountIndexes.add({'index': i, 'value': value});
    }
    return orderDiscountIndexes;
  }
}
