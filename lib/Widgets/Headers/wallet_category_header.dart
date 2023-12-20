import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';

class WalletCategoryHeader extends ConsumerWidget {
  const WalletCategoryHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletType = ref.watch(walletTypeProvider);
    if (walletType == WalletType.createWallet) {
      return const SizedBox();
    } else {
      return const Padding(
        padding: EdgeInsets.only(top: 12.0),
        child: CategoryWidget(text: 'Wallet'),
      );
    }
  }
}
