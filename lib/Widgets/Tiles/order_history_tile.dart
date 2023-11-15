import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/order_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/location_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/products_provider_widget.dart';
import 'package:jus_mobile_order_app/Sheets/receipt_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

class OrderHistoryTile extends StatelessWidget {
  final OrderModel order;
  final int tileIndex;
  const OrderHistoryTile(
      {required this.order, required this.tileIndex, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LocationsProviderWidget(
      builder: (locations) => ProductsProviderWidget(
        builder: (products) => InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            ModalBottomSheet().fullScreen(
                context: context,
                builder: (context) => ReceiptSheet(order: order));
          },
          child: Column(
            children: [
              order.pointsRedeemed != 0
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ListTile(
                        title: Text(
                          '${order.pointsRedeemed} points redeemed',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                            DateFormat('M/d/yyyy').format(order.createdAt)),
                      ))
                  : const SizedBox(),
              ListTile(
                leading: determineOrderIcon(order),
                title: Text(
                  order.orderSource,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.totalAmount <= 0
                        ? 'No charge'
                        : '${order.cardBrand} x${order.lastFourDigits}'),
                    Text(locations
                        .firstWhere(
                            (element) => element.locationID == order.locationID)
                        .name),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${NumberFormat.currency(
                            locale: 'en_US',
                            symbol: '',
                            decimalDigits: 2,
                          ).format((order.totalAmount + order.tipAmount) / 100)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '+${order.pointsEarned}',
                              style: const TextStyle(color: Colors.green),
                            ),
                            const Text(' points'),
                          ],
                        ),
                        Text(DateFormat('M/d/yyyy').format(order.createdAt)),
                      ],
                    ),
                    Spacing().horizontal(10),
                    const ChevronRightIcon(),
                  ],
                ),
                onTap: () {
                  ModalBottomSheet().fullScreen(
                      context: context,
                      builder: (context) => ReceiptSheet(order: order));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  determineOrderIcon(OrderModel order) {
    switch (order.orderSource) {
      case 'Mobile Order':
        {
          return const Icon(CupertinoIcons.device_phone_portrait);
        }
      case 'Web Order':
        {
          return const Icon(CupertinoIcons.keyboard);
        }
      case 'In-Store':
        {
          return const Icon(CupertinoIcons.home);
        }
      default:
        const Icon(CupertinoIcons.home);
    }
  }
}
