import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Payments/delete_payment_method_confirmation_sheet.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_order_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outline_button_medium.dart';

class DeletePaymentMethodButton extends StatelessWidget {
  final String cardID;
  final bool defaultPayment;
  const DeletePaymentMethodButton(
      {required this.cardID, required this.defaultPayment, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediumOutlineButton(
      buttonText: 'Delete Card',
      onPressed: () {
        HapticFeedback.mediumImpact();
        if (defaultPayment) {
          ModalBottomSheet().partScreen(
              context: context,
              builder: (context) => const InvalidOrderSheet(
                  error:
                      'Before deleting, please choose a new default payment method.'));
        } else {
          ModalBottomSheet().partScreen(
            isScrollControlled: true,
            isDismissible: true,
            enableDrag: true,
            context: context,
            builder: (context) =>
                DeletePaymentMethodConfirmationSheet(cardID: cardID),
          );
        }
      },
    );
  }
}
