import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/order_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/product_quantity_limit_provider.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/products_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/close_button.dart';

class ReceiptSheet extends ConsumerWidget {
  final OrderModel order;
  const ReceiptSheet({required this.order, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    return ProductsProviderWidget(
      builder: (products) => Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 12.0, right: 12.0),
          child: ListView(
            primary: false,
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: JusCloseButton(
                  removePadding: true,
                ),
              ),
              Text(
                'Receipt',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Spacing().vertical(25),
              Text(
                'Order #: ${order.orderNumber}',
                style: const TextStyle(fontSize: 16),
              ),
              Spacing().vertical(5),
              Text(
                DateFormat('M/dd/yyyy @ h:mm a')
                    .format(order.createdAt)
                    .toLowerCase(),
                style: const TextStyle(fontSize: 16),
              ),
              Spacing().vertical(20),
              const Text(
                'Items',
                style: TextStyle(fontSize: 18),
              ),
              JusDivider().thin(),
              ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                separatorBuilder: (context, index) => JusDivider().thin(),
                itemBuilder: (context, itemIndex) {
                  final currentProduct = products.firstWhere((element) =>
                      element.productID == order.items[itemIndex]['id']);
                  return ListTile(
                    leading: SizedBox(
                      height: 80,
                      child: CachedNetworkImage(
                        imageUrl: currentProduct.image,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          currentProduct.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Spacing().horizontal(5),
                        currentProduct.isScheduled ||
                                order.items[itemIndex]['itemQuantity'] == 1
                            ? const SizedBox()
                            : Text(
                                'x${order.items[itemIndex]['itemQuantity']}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )
                      ],
                    ),
                    subtitle: ProductQuantityLimitProviderWidget(
                      locationID: order.locationID,
                      productUID: currentProduct.uid,
                      builder: (quantityLimit) => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          currentProduct.isScheduled
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Quantity: ${order.items[itemIndex]['itemQuantity']}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                          '${quantityLimit.scheduledProductDescriptor}: ${order.items[itemIndex]['itemQuantity']}',
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                )
                              : order.items[itemIndex]['size'] == null
                                  ? const SizedBox()
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        order.items[itemIndex]['size'],
                                        style: const TextStyle(fontSize: 12),
                                      )),
                          order.items[itemIndex]['modifications'].isEmpty
                              ? const SizedBox()
                              : Flexible(
                                  child: ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: order
                                        .items[itemIndex]['modifications']
                                        .length,
                                    itemBuilder: (context, index) => Text(
                                      order.items[itemIndex]['modifications']
                                          [index],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                          order.items[itemIndex]['allergies'].isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  width: 150,
                                  child: Text(
                                    'Allergies: ${List.generate(
                                      order
                                          .items[itemIndex]['allergies'].length,
                                      (index) => order.items[itemIndex]
                                          ['allergies'][index],
                                    ).join(', ')}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    trailing: Text(
                        '\$${(order.items[itemIndex]['price'] / 100).toStringAsFixed(2)}${order.items[itemIndex]['itemQuantity'] == 1 ? '' : '/ea.'}'),
                  );
                },
              ),
              Spacing().vertical(20),
              JusDivider().thick(),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.discountAmount > 0 ? 'Original' : 'Subtotal',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          '\$${NumberFormat.currency(
                            locale: 'en_US',
                            symbol: '',
                            decimalDigits: 2,
                          ).format(order.discountAmount > 0 ? (order.originalSubtotalAmount / 100) : order.discountedSubtotalAmount / 100)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    order.discountAmount <= 0
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Discounts',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '\$${NumberFormat.currency(
                                  locale: 'en_US',
                                  symbol: '',
                                  decimalDigits: 2,
                                ).format(order.discountAmount / 100)}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.green),
                              ),
                            ],
                          ),
                    order.discountAmount <= 0
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Subtotal',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '\$${NumberFormat.currency(
                                  locale: 'en_US',
                                  symbol: '',
                                  decimalDigits: 2,
                                ).format((order.discountedSubtotalAmount / 100))}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tax',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '\$${NumberFormat.currency(
                            locale: 'en_US',
                            symbol: '',
                            decimalDigits: 2,
                          ).format(order.taxAmount / 100)}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    order.tipAmount <= 0
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tip',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '\$${NumberFormat.currency(
                                  locale: 'en_US',
                                  symbol: '',
                                  decimalDigits: 2,
                                ).format(order.tipAmount / 100)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                    order.pointsEarned <= 0
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Points Earned',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '+${order.pointsEarned}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.green),
                              ),
                            ],
                          ),
                    order.pointsRedeemed <= 0
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Points Redeemed',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${order.pointsRedeemed}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                    Spacing().vertical(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${NumberFormat.currency(
                            locale: 'en_US',
                            symbol: '',
                            decimalDigits: 2,
                          ).format((order.totalAmount + order.tipAmount) / 100)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    //   Row(
    //   children: [
    //     SizedBox(
    //       height: 80,
    //       child: CachedNetworkImage(
    //         imageUrl: currentProduct.image,
    //       ),
    //     ),
    //     Spacing().horizontal(15),
    //     Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Row(
    //           children: [
    //             Text(
    //               currentProduct.name,
    //               style: const TextStyle(
    //                   fontWeight: FontWeight.bold),
    //             ),
    //             Spacing().horizontal(5),
    //             currentProduct.isScheduled ||
    //                     order.items[itemIndex]['itemQuantity'] ==
    //                         1
    //                 ? const SizedBox()
    //                 : Text(
    //                     'x${order.items[itemIndex]['itemQuantity']}',
    //                     style: const TextStyle(
    //                         fontWeight: FontWeight.bold),
    //                   )
    //           ],
    //         ),
    //         ProductQuantityLimitProviderWidget(
    //           locationID: order.locationID,
    //           productUID: currentProduct.uid,
    //           builder: (quantityLimit) => Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               currentProduct.isScheduled
    //                   ? Align(
    //                       alignment: Alignment.centerLeft,
    //                       child: Column(
    //                         crossAxisAlignment:
    //                             CrossAxisAlignment.start,
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           Text(
    //                             'Quantity: ${order.items[itemIndex]['itemQuantity']}',
    //                             style:
    //                                 const TextStyle(fontSize: 12),
    //                           ),
    //                           Text(
    //                               '${quantityLimit.scheduledProductDescriptor}: ${order.items[itemIndex]['itemQuantity']}',
    //                               style: const TextStyle(
    //                                   fontSize: 12)),
    //                         ],
    //                       ),
    //                     )
    //                   : order.items[itemIndex]['size'] == null
    //                       ? const SizedBox()
    //                       : Align(
    //                           alignment: Alignment.centerLeft,
    //                           child: Text(order.items[itemIndex]
    //                               ['size'])),
    //
    //               // Flexible(
    //               //   child: ListView.builder(
    //               //     primary: false,
    //               //     shrinkWrap: true,
    //               //     physics:
    //               //         const NeverScrollableScrollPhysics(),
    //               //     itemCount: order
    //               //             .items[itemIndex]
    //               //                 ['modifications']
    //               //             .isEmpty
    //               //         ? 0
    //               //         : order
    //               //             .items[itemIndex]
    //               //                 ['modifications']
    //               //             .length,
    //               //     itemBuilder: (context, index) => order
    //               //             .items[itemIndex]
    //               //                 ['modifications']
    //               //             .isEmpty
    //               //         ? const SizedBox()
    //               //         : Text(
    //               //             order.items[itemIndex]
    //               //                 ['modifications'][index],
    //               //             style: const TextStyle(
    //               //                 fontSize: 12),
    //               //           ),
    //               //   ),
    //               // ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //     Align(
    //       alignment: Alignment.centerRight,
    //       child: Text(
    //           '\$${(order.items[itemIndex]['price'] / 100)}'),
    //     ),
    //   ],
    // );
  }
}
