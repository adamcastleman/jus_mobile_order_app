import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/extensions.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Payments/add_payment_method_tile.dart';
import 'package:jus_mobile_order_app/Payments/payment_option_tile.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/credit_card_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';

class SelectCreditCardForWalletSheet extends ConsumerWidget {
  const SelectCreditCardForWalletSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    return CreditCardProviderWidget(
      builder: (creditCards) => SizedBox(
        height: 600,
        child: Column(
          children: [
            const SheetNotch(),
            const Padding(
              padding: EdgeInsets.only(top: 22.0, bottom: 12.0),
              child: Text(
                'Choose payment method to load Wallet',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            JusDivider().thick(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: 22.0,
                  horizontal: 12.0,
                ),
                shrinkWrap: true,
                itemCount:
                    creditCards.where((element) => !element.isWallet).length +
                        2,
                separatorBuilder: (context, index) => JusDivider().thin(),
                itemBuilder: (context, index) {
                  List<PaymentsModel> cards = creditCards
                      .where((element) => !element.isWallet)
                      .toList();
                  if (index ==
                      creditCards
                          .where((element) => !element.isWallet)
                          .length) {
                    return AddPaymentMethodTile(
                      isWallet: false,
                      isTransfer: false,
                      title: 'Add Payment Method',
                      onTap: () {
                        PaymentsServices(
                                ref: ref,
                                userID: user.uid,
                                firstName: user.firstName,
                                context: context)
                            .initSquarePayment();
                      },
                    );
                  } else if ((Platform.isIOS || Platform.isMacOS) &&
                      index ==
                          creditCards
                                  .where((element) => !element.isWallet)
                                  .length +
                              1) {
                    return ListTile(
                      leading: const Icon(FontAwesomeIcons.apple),
                      title: Row(
                        children: [
                          const Text('Pay with '),
                          Spacing().horizontal(2),
                          const Icon(
                            FontAwesomeIcons.applePay,
                            size: 35,
                          )
                        ],
                      ),
                      onTap: () {
                        ref.read(applePaySelectedProvider.notifier).state =
                            true;
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    return PaymentOptionTile(
                      icon: CupertinoIcons.creditcard,
                      title:
                          '${cards[index].cardNickname} - ${cards[index].brand.capitalize} ending in ${cards[index].lastFourDigits}',
                      subtitle: const SizedBox(),
                      onTap: () {
                        ref.read(applePaySelectedProvider.notifier).state =
                            false;
                        ref.read(selectedCreditCardProvider.notifier).state = {
                          'cardNickname': cards[index].cardNickname,
                          'isWallet': cards[index].isWallet,
                          'nonce': cards[index].nonce,
                          'lastFourDigits': cards[index].lastFourDigits,
                          'brand': cards[index].brand,
                        };
                        Navigator.pop(context);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
