import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/wallet_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Icons/chevron_right_icon.dart';
import 'package:jus_mobile_order_app/constants.dart';

class ListOfWalletsSheet extends ConsumerWidget {
  const ListOfWalletsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value!;
    final isDrawerOpen = AppConstants.scaffoldKey.currentState?.isEndDrawerOpen;
    return WalletProviderWidget(
      builder: (wallets) => Padding(
        padding: EdgeInsets.only(
            top: isDrawerOpen == null || !isDrawerOpen ? 0.0 : 20.0,
            bottom: 40.0),
        child: Wrap(
          children: [
            isDrawerOpen == null || !isDrawerOpen
                ? const SheetNotch()
                : const SizedBox(),
            const Padding(
              padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: Center(
                child: Text(
                  'Select Wallet',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            JusDivider.thin(),
            ListView.separated(
              padding: const EdgeInsets.only(bottom: 20),
              shrinkWrap: true,
              primary: false,
              itemCount: wallets.length,
              separatorBuilder: (context, index) => JusDivider.thin(),
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(FontAwesomeIcons.wallet),
                title: Text(
                    '${wallets[index].cardNickname} x${wallets[index].gan!.substring(wallets[index].gan!.length - 4)}'),
                subtitle: Text(
                  'Balance: \$${(wallets[index].balance! / 100).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const ChevronRightIcon(),
                onTap: () {
                  ref.read(selectedWalletProvider.notifier).state =
                      PaymentsModel(
                    uid: wallets[index].uid,
                    userId: currentUser.uid!,
                    brand: wallets[index].brand,
                    last4: wallets[index].last4,
                    defaultPayment: wallets[index].defaultPayment,
                    cardNickname: wallets[index].cardNickname,
                    balance: wallets[index].balance,
                    gan: wallets[index].gan,
                    isWallet: true,
                  );

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
