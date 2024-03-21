import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Services/square_web_payment_services.dart';
import 'package:universal_html/html.dart' as html;

class SquareWebPaymentForm extends HookWidget {
  final String squareApplicationId;
  final String squareLocationId;
  final PaymentType paymentType;
  final Function(String) cardDetailsResult;

  const SquareWebPaymentForm({
    required this.paymentType,
    required this.squareApplicationId,
    required this.squareLocationId,
    required this.cardDetailsResult,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String viewType = UniqueKey().toString();

    useEffect(() {
      // Create an HTML div element for the payment form
      final divElement = html.DivElement()
        ..id = 'card'
        ..style.width = '100%'
        ..style.height = '75%';

      // Register the div element as a platform view
      ui_web.platformViewRegistry
          .registerViewFactory(viewType, (int viewId) => divElement);

      // Embedding the Square payment form HTML and JavaScript
      _embedSquarePaymentForm(divElement);
      //

      // Cleanup function
      return () {
        // Remove the div element when the dialog is closed
        divElement.remove();
      };
    }, const []);

    return HtmlElementView(viewType: viewType);
  }

  void _embedSquarePaymentForm(html.Element divElement) {
    // Set up the container to use Flexbox layout
    divElement.style
      ..display = 'flex'
      ..flexDirection = 'column'
      ..justifyContent = 'center' // Center the content vertically
      ..alignItems = 'center'; // Center the content horizontally

    // Create the card container
    var cardContainer = html.DivElement()
      ..id = 'card-container'
      ..style.width = 'auto' // Set width to auto
      ..style.height = 'auto'; // Set height to auto

    // Append the card container to the div element
    divElement.append(cardContainer);

    // Call the Square SDK to set up the card form inside the card container
    paymentType == PaymentType.creditCard
        ? SquarePaymentWebServices().squareCreditCardWebForm(
            squareApplicationId,
            squareLocationId,
            (cardDetails) {
              cardDetailsResult(cardDetails);
            },
          )
        : SquarePaymentWebServices().squareGiftCardWebForm(
            squareApplicationId,
            squareLocationId,
            (cardDetails) {
              cardDetailsResult(cardDetails);
            },
          );
  }
}
