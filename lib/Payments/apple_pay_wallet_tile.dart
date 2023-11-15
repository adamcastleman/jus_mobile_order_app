import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

class ApplePayWalletTile extends StatelessWidget {
  final VoidCallback onTap;
  const ApplePayWalletTile({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(FontAwesomeIcons.apple),
      title: Row(
        children: [
          const Text('Pay with'),
          Spacing().horizontal(7),
          const Icon(
            FontAwesomeIcons.applePay,
            size: 35,
          ),
        ],
      ),
      trailing: const ChevronRightIcon(),
      onTap: onTap,
    );
  }
}
