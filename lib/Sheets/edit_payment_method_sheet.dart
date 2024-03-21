import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/add_funds_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/delete_payment_method_button.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/update_payment_method_button.dart';
import 'package:jus_mobile_order_app/Widgets/General/card_info_fields.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Tiles/default_payment_checkbox_tile.dart';
import 'package:jus_mobile_order_app/constants.dart';

class EditPaymentMethodSheet extends ConsumerWidget {
  final PaymentsModel card;
  const EditPaymentMethodSheet({required this.card, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDrawerOpen = AppConstants.scaffoldKey.currentState?.isEndDrawerOpen;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0, left: 12, right: 12),
        child: Wrap(
          children: [
            isDrawerOpen == null || !isDrawerOpen
                ? const Center(
                    child: SheetNotch(),
                  )
                : Spacing.vertical(20),
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
                ? Spacing.vertical(250)
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
                      ? Expanded(child: AddFundsButton(wallet: card))
                      : Expanded(
                          child: DeletePaymentMethodButton(
                            cardID: card.uid ?? '',
                            defaultPayment: card.defaultPayment,
                          ),
                        ),
                  Spacing.horizontal(12.0),
                  Expanded(
                    child: UpdatePaymentMethodButton(card: card),
                  ),
                ],
              ),
            ),
            Spacing.vertical(60),
          ],
        ),
      ),
    );
  }
}
