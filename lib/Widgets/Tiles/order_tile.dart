import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/product_model.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Views/product_detail_page.dart';
import 'package:jus_mobile_order_app/Widgets/General/order_tile_display_modifications.dart';
import 'package:jus_mobile_order_app/Widgets/General/order_tile_edit_row.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/pricing.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

class OrderTile extends ConsumerWidget {
  final int orderIndex;

  const OrderTile({required this.orderIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final backgroundColor = ref.watch(themeColorProvider);
    final currentOrder = ref.watch(currentOrderItemsProvider);
    return products.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (data) {
        ProductModel currentProduct = data
            .where((element) =>
                element.productID == currentOrder[orderIndex]['productID'])
            .first;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: OpenContainer(
              openElevation: 0,
              closedElevation: 0,
              tappable: false,
              transitionType: ContainerTransitionType.fadeThrough,
              transitionDuration: const Duration(milliseconds: 600),
              closedColor: backgroundColor!,
              openColor: backgroundColor,
              openBuilder: (context, open) {
                return ProductDetailPage(
                  product: currentProduct,
                );
              },
              closedBuilder: (context, close) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: SizedBox(
                        width: 65,
                        child: CachedNetworkImage(
                          imageUrl: currentProduct.image,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: determinePriceDisplay(ref, currentProduct),
                          ),
                          ListTile(
                            title: AutoSizeText(
                              currentProduct.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  determineItemSizingDisplay(
                                      ref, currentProduct),
                                  Spacing().vertical(3),
                                  OrderTileDisplayModifications(
                                    currentProduct: currentProduct,
                                    orderIndex: orderIndex,
                                  ),
                                  Spacing().vertical(10),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final currentUser =
                                          ref.watch(currentUserProvider);
                                      return currentUser.when(
                                        loading: () => const Loading(),
                                        error: (e, _) =>
                                            ShowError(error: e.toString()),
                                        data: (user) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              top: user.uid == null ||
                                                      !user.isActiveMember!
                                                  ? 0
                                                  : 6,
                                            ),
                                            child: OrderTileEditRow(
                                              index: orderIndex,
                                              currentProduct: currentProduct,
                                              close: close,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        );
      },
    );
  }

  determinePriceDisplay(WidgetRef ref, ProductModel currentProduct) {
    final currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (data) {
        if (data.uid == null || !data.isActiveMember!) {
          return Text(
            Pricing(ref: ref).productPrice(currentProduct, orderIndex),
            style: const TextStyle(fontSize: 16),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Pricing(ref: ref).productPrice(currentProduct, orderIndex),
                style: const TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
              Spacing().horizontal(5),
              Text(
                Pricing(ref: ref)
                    .productPriceMembers(currentProduct, orderIndex),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  determineItemSizingDisplay(WidgetRef ref, ProductModel currentProduct) {
    TextStyle style = const TextStyle(fontSize: 13);
    final currentOrder = ref.watch(currentOrderItemsProvider);
    if (!currentProduct.isScheduled &&
        (!currentProduct.isModifiable && !currentProduct.hasToppings)) {
      return const SizedBox();
    } else if (currentProduct.isScheduled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing().vertical(4),
          Text(
            'Quantity: ${currentOrder[orderIndex]['itemQuantity']}',
            style: style,
          ),
          Text(
            'Number of Days: ${currentOrder[orderIndex]['daysQuantity'] ?? ''}',
            style: style,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Text(
            '${currentProduct.price[currentOrder[orderIndex]['itemSize']]['name'] ?? ''}',
            style: style,
          )
        ],
      );
    }
  }
}
