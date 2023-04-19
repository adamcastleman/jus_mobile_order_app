import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Models/order_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/orders_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_activities_provider_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/transaction_history_tile.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';

class TransactionHistoryListView extends StatelessWidget {
  const TransactionHistoryListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final monthYearFormat = DateFormat('yyyy-MM');
    return WalletActivitiesProviderWidget(
      builder: (activities) => OrdersProviderWidget(builder: (orders) {
        return GroupedListView.list(
          primary: false,
          items: orders,
          itemGrouper: (OrderModel order) =>
              monthYearFormat.format(DateTime.now()),
          headerBuilder: (context, createdAt) =>
              _buildHeader(context, createdAt),
          listItemBuilder: (context, int countInGroup, int itemIndexInGroup,
                  OrderModel order, int itemIndexInOriginalList) =>
              Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                TransactionHistoryTile(
                  order: order,
                  tileIndex: itemIndexInOriginalList,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, String createdAt) {
    final monthYearFormat = DateFormat('yyyy-MM');
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          DateFormat('MMMM yyyy').format(monthYearFormat.parse(createdAt)),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
