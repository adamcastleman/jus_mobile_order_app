import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Widgets/General/category_display_widget.dart';

class WalletAddBalanceHeader extends StatelessWidget {
  final WalletType walletType;
  const WalletAddBalanceHeader({required this.walletType, super.key});

  @override
  Widget build(BuildContext context) {
    String walletText;
    if (walletType == WalletType.createWallet) {
      walletText = 'Initial Balance';
    } else {
      walletText = 'Add to Wallet';
    }
    return CategoryWidget(
      text: walletText,
    );
  }
}
