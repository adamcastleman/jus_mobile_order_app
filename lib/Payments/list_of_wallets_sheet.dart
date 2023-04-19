import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/gift_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';

class ListOfWalletsSheet extends ConsumerWidget {
  const ListOfWalletsSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WalletProviderWidget(
      builder: (wallets) => Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: SheetNotch(),
            ),
            const Center(
              child: Text(
                'Select Wallet',
                style: TextStyle(fontSize: 22),
              ),
            ),
            JusDivider().thin(),
            ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shrinkWrap: true,
              primary: false,
              itemCount: wallets.length,
              separatorBuilder: (context, index) => JusDivider().thin(),
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(FontAwesomeIcons.wallet),
                title: Text(
                    '${wallets[index].cardNickname} x${wallets[index].gan!.substring(wallets[index].gan!.length - 4)}'),
                subtitle: Text(
                    'Balance: \$${(wallets[index].balance! / 100).toStringAsFixed(2)}'),
                trailing: const ChevronRightIcon(),
                onTap: () {
                  ref.read(currentlySelectedWalletProvider.notifier).state = {
                    'cardNickname': wallets[index].cardNickname,
                    'gan': wallets[index].gan,
                    'balance': wallets[index].balance,
                    'uid': wallets[index].uid,
                  };
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
