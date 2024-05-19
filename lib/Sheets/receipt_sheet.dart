import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Models/order_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/product_quantity_limit_provider.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';
import 'package:jus_mobile_order_app/Providers/theme_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';

import '../Helpers/spacing_widgets.dart';

class ReceiptSheet extends ConsumerWidget {
  final OrderModel order;
  const ReceiptSheet({required this.order, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = ref.watch(backgroundColorProvider);
    final products = ref.watch(allProductsProvider);

    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0, left: 12.0, right: 12.0),
        child: ListView(
          primary: false,
          children: [
            const SheetHeader(title: 'Receipt'),
            Spacing.vertical(25),
            Text(
              DateFormat('M/dd/yyyy @ h:mm a')
                  .format(order.createdAt)
                  .toLowerCase(),
              style: const TextStyle(fontSize: 16),
            ),
            Spacing.vertical(20),
            const CategoryWidget(
              text: 'Order Details',
            ),
            Text(
              'Order #: ${order.orderNumber}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              order.totalAmount <= 0
                  ? 'No charge'
                  : '${order.cardBrand} x${order.last4}',
              style: const TextStyle(fontSize: 16),
            ),
            Consumer(builder: (context, ref, child) {
              final locations = ref.watch(allLocationsProvider);
              return Text(
                locations
                    .firstWhere(
                        (element) => element.locationId == order.locationId)
                    .name,
                style: const TextStyle(fontSize: 16),
              );
            }),
            order.pickupTime == null
                ? const SizedBox()
                : Text(
                    'Pickup: ${DateFormat('M/dd/yyyy @ h:mm a').format(order.pickupTime!).toLowerCase()}',
                    style: const TextStyle(fontSize: 16),
                  ),
            order.pickupDate == null
                ? const SizedBox()
                : Text(
                    'Scheduled Pickup: ${DateFormat('M/dd/yyyy').format(order.pickupDate!).toLowerCase()}',
                    style: const TextStyle(fontSize: 16),
                  ),
            Spacing.vertical(20),
            const CategoryWidget(text: 'Items'),
            ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (context, index) => JusDivider.thin(),
              itemBuilder: (context, itemIndex) {
                final product = products.firstWhere(
                    (item) => item.productId == order.items[itemIndex]['id']);
                return ListTile(
                  leading: SizedBox(
                    width: 40,
                    height: 80,
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                    ),
                  ),
                  title: Row(
                    children: [
                      AutoSizeText(
                        product.name,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacing.horizontal(5),
                      product.isScheduled ||
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
                    locationId: order.locationId,
                    productUID: product.uid,
                    builder: (quantityLimit) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        product.isScheduled
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            : order.items[itemIndex]['size'] == null ||
                                    !product.isModifiable
                                ? const SizedBox()
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      order.items[itemIndex]['size'].toString(),
                                      style: const TextStyle(fontSize: 12),
                                    )),
                        order.items[itemIndex]['modifications'].isEmpty
                            ? const SizedBox()
                            : Flexible(
                                child: ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: order
                                      .items[itemIndex]['modifications'].length,
                                  itemBuilder: (context, index) {
                                    // Get the modification as a JSON string
                                    String modificationJsonString =
                                        order.items[itemIndex]['modifications']
                                            [index];

                                    // Decode the JSON
                                    var modification =
                                        jsonDecode(modificationJsonString);

                                    // Check for existence of keys and that they are not null
                                    int quantity = modification
                                                .containsKey('quantity') &&
                                            modification['quantity'] != null
                                        ? int.parse(
                                            modification['quantity'].toString())
                                        : 1; // Default to 1 if quantity is not provided

                                    // Similarly, check for price existence and non-null
                                    int priceInCents = modification
                                                .containsKey('price') &&
                                            modification['price'] != null
                                        ? int.parse(
                                            modification['price'].toString())
                                        : 0; // Default to 0 if price is not provided

                                    double priceInDollars =
                                        (priceInCents * quantity) / 100;

                                    // Declare formattedPrice once before its use
                                    String formattedPrice =
                                        priceInDollars.toStringAsFixed(2);

                                    return Text(
                                      '${modification['name']} ${formattedPrice == '0.00' ? '' : '+\$$formattedPrice'}',
                                      style: const TextStyle(fontSize: 12),
                                    );
                                  },
                                ),
                              ),
                        order.items[itemIndex]['allergies'].isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                width: 150,
                                child: Text(
                                  'Allergies: ${List.generate(
                                    order.items[itemIndex]['allergies'].length,
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
                      '\$${((order.items[itemIndex]['price'] + order.items[itemIndex]['modifierPrice']) / 100).toStringAsFixed(2)}${order.items[itemIndex]['itemQuantity'] == 1 ? '' : '/ea.'}'),
                );
              },
            ),
            Spacing.vertical(20),
            JusDivider.thick(),
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
                  Spacing.vertical(15),
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
    );
  }
}
