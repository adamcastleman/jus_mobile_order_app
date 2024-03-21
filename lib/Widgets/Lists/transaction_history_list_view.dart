import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Models/order_model.dart';
import 'package:jus_mobile_order_app/Models/wallet_activities_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/orders_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_activities_provider_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/order_history_tile.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/wallet_history_tile.dart';
import 'package:simple_grouped_listview/simple_grouped_listview.dart';

class TransactionHistoryListView extends StatelessWidget {
  const TransactionHistoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    final monthYearFormat = DateFormat('yyyy-MM');
    return WalletActivitiesProviderWidget(
      builder: (wallet) => OrdersProviderWidget(builder: (orders) {
        final combinedList = [...orders, ...wallet];
        combinedList.sort((a, b) {
          final aCreatedAt = (a is OrderModel
              ? a.createdAt
              : (a as WalletActivitiesModel).createdAt);
          final bCreatedAt = (b is OrderModel
              ? b.createdAt
              : (b as WalletActivitiesModel).createdAt);
          return bCreatedAt.compareTo(aCreatedAt);
        });

        return GroupedListView.list(
            primary: false,
            items: combinedList,
            itemGrouper: (dynamic item) =>
                monthYearFormat.format(item.createdAt),
            headerBuilder: (context, createdAt) =>
                _buildHeader(context, createdAt),
            listItemBuilder: (context, int countInGroup, int itemIndexInGroup,
                dynamic item, int itemIndexInOriginalList) {
              if (item is OrderModel) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      OrderHistoryTile(
                        order: item,
                        tileIndex: itemIndexInOriginalList,
                      ),
                      JusDivider.thin(),
                    ],
                  ),
                );
              }
              {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      wallet.isEmpty
                          ? const SizedBox()
                          : WalletHistoryTile(
                              wallet: item, tileIndex: itemIndexInOriginalList),
                      JusDivider.thin(),
                    ],
                  ),
                );
              }
            });
      }),
    );
  }

  Widget _buildHeader(BuildContext context, String createdAt) {
    final monthYearFormat = DateFormat('yyyy-MM');
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
        child: Text(
          DateFormat('MMMM yyyy').format(monthYearFormat.parse(createdAt)),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
