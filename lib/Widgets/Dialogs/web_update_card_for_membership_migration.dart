import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:js/js.dart';
import 'package:jus_mobile_order_app/Services/square_web_payment_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/membership_migration_update_payment_button.dart';
import 'package:jus_mobile_order_app/constants.dart';

class WebUpdateCardForMembershipMigration extends StatelessWidget {
  final Widget formWidget;
  final Function(dynamic) onCardDetailsResult;
  const WebUpdateCardForMembershipMigration(
      {required this.formWidget, required this.onCardDetailsResult, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: AppConstants.migrationDialogHeight,
          width: AppConstants.paymentsSdkWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 22.0),
                child: AutoSizeText(
                  'We need to update your payment method for your membership',
                  style: TextStyle(fontSize: 18),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 22.0),
                child: Text(
                  'You will not be charged until your normal billing date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: formWidget,
                ),
              ),
              Consumer(
                builder: (context, ref, child) => Padding(
                  padding: const EdgeInsets.only(top: 22.0, bottom: 10.0),
                  child: MembershipMigrationUpdatePaymentButton(
                    buttonText: 'Update Payment Method',
                    onPressed: () {
                      // Call the JavaScript function setTokenizationCallback
                      SquarePaymentWebServices().setTokenizationCallback(
                        allowInterop(
                          (cardDetails) {
                            onCardDetailsResult(cardDetails);
                          },
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
