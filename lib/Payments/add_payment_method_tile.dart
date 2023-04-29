import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/user_provider_widget.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/payment_method_icons.dart';

class AddPaymentMethodTile extends ConsumerWidget {
  final bool isWallet;
  final bool isTransfer;
  final String title;
  final VoidCallback onTap;
  const AddPaymentMethodTile(
      {required this.isWallet,
      required this.isTransfer,
      required this.title,
      required this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return UserProviderWidget(
      builder: (user) => ListTile(
        leading: isTransfer
            ? const Icon(
                CupertinoIcons.arrow_2_squarepath,
                color: Colors.black,
              )
            : isWallet
                ? const Icon(
                    FontAwesomeIcons.wallet,
                    color: Colors.black,
                  )
                : const AddPaymentMethodIcon(),
        title: Text(title),
        subtitle: user.uid == null || isWallet || isTransfer
            ? null
            : const Text(
                'Your payment method will be saved for future use.',
                style: TextStyle(fontSize: 12),
              ),
        trailing: const ChevronRightIcon(),
        onTap: onTap,
      ),
    );
  }
}
