import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:js/js.dart';
import 'package:jus_mobile_order_app/Services/square_web_payment_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/Widgets/Headers/sheet_header.dart';
import 'package:jus_mobile_order_app/constants.dart';

class WebPaymentFormDialog extends StatelessWidget {
  final Widget formWidget;
  final Function(dynamic) onCardDetailsResult;
  const WebPaymentFormDialog(
      {required this.formWidget, required this.onCardDetailsResult, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: AppConstants.paymentsSdkHeight,
          width: AppConstants.paymentsSdkWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SheetHeader(
                color: Colors.white,
                title: 'Add your card',
                onClose: () {
                  Navigator.pop(context);
                },
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: formWidget,
                ),
              ),
              Consumer(
                builder: (context, ref, child) => LargeElevatedButton(
                  buttonText: 'Add Card',
                  onPressed: () {
                    // Call the JavaScript function setTokenizationCallback
                    SquarePaymentWebServices().setTokenizationCallback(
                      allowInterop(
                        (cardDetails) {
                          onCardDetailsResult(cardDetails);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
