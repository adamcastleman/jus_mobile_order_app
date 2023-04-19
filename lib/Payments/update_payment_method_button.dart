import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Payments/invalid_payment_sheet.dart';
import 'package:jus_mobile_order_app/Services/payment_methods_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';

import '../Providers/payments_providers.dart';

class UpdatePaymentMethodButton extends ConsumerWidget {
  final PaymentsModel card;
  const UpdatePaymentMethodButton({required this.card, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MediumElevatedButton(
      buttonText: 'Save',
      onPressed: () {
        HapticFeedback.mediumImpact();
        _validateFormAndSaveNicknameToDatabase(context, ref);
        _validateDefaultCheckboxAndUpdateDatabase(context, ref);
        Navigator.pop(context);
      },
    );
  }

  void _validateFormAndSaveNicknameToDatabase(
      BuildContext context, WidgetRef ref) {
    final cardNickname = ref.watch(cardNicknameProvider);
    if (cardNickname.isEmpty && card.cardNickname.isEmpty) {
      ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => const InvalidPaymentSheet(
          error: 'Card nickname cannot be empty',
        ),
      );
    } else {
      cardNickname.isEmpty
          ? ref.read(cardNicknameProvider.notifier).state = card.cardNickname
          : ref.read(cardNicknameProvider.notifier).state = cardNickname;

      PaymentMethodsServices(ref: ref).updateCardNickname(
          context: context, cardNickname: cardNickname, cardID: card.uid);
    }
  }

  void _validateDefaultCheckboxAndUpdateDatabase(
      BuildContext context, WidgetRef ref) {
    if (ref.read(defaultPaymentCheckboxProvider) == true) {
      PaymentMethodsServices().updateDefaultPayment(context, card.uid);
    }
  }
}
