import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Services/payment_method_database_services.dart';

class DeletePaymentMethodConfirmationSheet extends StatelessWidget {
  final String cardID;
  const DeletePaymentMethodConfirmationSheet({required this.cardID, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 30.0, bottom: 40.0, left: 12.0, right: 12.0),
      child: Wrap(
        children: [
          const AutoSizeText(
            'Remove this payment method?',
            style: TextStyle(fontSize: 22),
            maxLines: 1,
          ),
          Spacing.vertical(40),
          JusDivider.thick(),
          // Spacing().vertical(30),
          ListTile(
            textColor: Colors.black,
            title: const Text(
              'No, keep payment method',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          JusDivider.thin(),
          ListTile(
            textColor: Colors.red,
            title: const Text(
              'Yes, remove payment method',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              PaymentMethodDatabaseServices().deletePaymentMethod(
                cardID: cardID,
                onError: (error) {
                  ErrorHelpers.showSinglePopError(context,
                      error: error.toString());
                },
              );
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
