import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/outline_button_medium.dart';
import 'package:jus_mobile_order_app/Widgets/Payments/delete_payment_method_confimration_sheet.dart';

class DeletePaymentMethodButton extends StatelessWidget {
  final String cardID;
  const DeletePaymentMethodButton({required this.cardID, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediumOutlineButton(
      buttonText: 'Delete Card',
      onPressed: () {
        HapticFeedback.mediumImpact();
        ModalBottomSheet().partScreen(
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
          context: context,
          builder: (context) =>
              DeletePaymentMethodConfirmationSheet(cardID: cardID),
        );
      },
    );
  }
}
