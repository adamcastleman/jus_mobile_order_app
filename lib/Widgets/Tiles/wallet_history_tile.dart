import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/extensions.dart';
import 'package:jus_mobile_order_app/Models/wallet_activities_model.dart';

class WalletHistoryTile extends StatelessWidget {
  final WalletActivitiesModel wallet;
  final int tileIndex;
  const WalletHistoryTile(
      {required this.wallet, required this.tileIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        CupertinoIcons.money_dollar,
        size: 30,
      ),
      title: Text(
        wallet.activity.toLowerCase().capitalize,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'WALLET x${wallet.gan.substring(wallet.gan.length - 4)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '+\$${(wallet.amount / 100).toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.green),
          ),
          Text(DateFormat('M/d/yyyy').format(wallet.createdAt)),
        ],
      ),
    );
  }
}
