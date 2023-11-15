import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Payments/card_info_fields.dart';
import 'package:jus_mobile_order_app/Payments/default_payment_checkbox_tile.dart';
import 'package:jus_mobile_order_app/Payments/delete_payment_method_button.dart';
import 'package:jus_mobile_order_app/Payments/update_payment_method_button.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/load_wallet_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';

class EditPaymentMethodSheet extends ConsumerWidget {
  final PaymentsModel card;
  const EditPaymentMethodSheet({required this.card, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0, left: 12, right: 12),
        child: Wrap(
          children: [
            const Center(
              child: SheetNotch(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Edit Card',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Center(
                child: CardInfoFields(
                  card: card,
                ),
              ),
            ),
            card.defaultPayment
                ? Spacing().vertical(250)
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: DefaultPaymentCheckbox(
                      value: ref.watch(defaultPaymentCheckboxProvider) ?? false,
                      onChanged: (value) => ref
                          .read(defaultPaymentCheckboxProvider.notifier)
                          .state = value,
                    ),
                  ),
            Padding(
              padding: card.defaultPayment
                  ? const EdgeInsets.only(top: 12.0, bottom: 22.0)
                  : EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  card.isWallet
                      ? const LoadWalletButton()
                      : DeletePaymentMethodButton(
                          cardID: card.uid,
                          defaultPayment: card.defaultPayment,
                        ),
                  UpdatePaymentMethodButton(card: card),
                ],
              ),
            ),
            Spacing().vertical(60),
          ],
        ),
      ),
    );
  }
}
