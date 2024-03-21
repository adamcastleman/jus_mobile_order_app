import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/web_payment_form_dialog.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/web_update_card_for_membership_migration.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/web_update_card_for_subscription_dialog.dart';
import 'package:jus_mobile_order_app/Widgets/General/square_web_payment_form.dart';

class WebCardEntry {
  static showAddCreditCardDialog({
    required BuildContext context,
    required String applicationId,
    required String locationId,
    required Function(String) onCardDetailsResult,
  }) {
    return showDialog(
      context: context,
      builder: (context) => WebPaymentFormDialog(
        formWidget: SquareWebPaymentForm(
          paymentType: PaymentType.creditCard,
          squareApplicationId: applicationId,
          squareLocationId: locationId,
          cardDetailsResult: (cardDetails) {
            onCardDetailsResult(cardDetails);
          },
        ),
        onCardDetailsResult: (cardDetails) {
          onCardDetailsResult(cardDetails);
        },
      ),
    );
  }

  static showAddGiftCardDialog({
    required BuildContext context,
    required String applicationId,
    required String locationId,
    required Function(String) onCardDetailsResult,
  }) {
    return showDialog(
      context: context,
      builder: (context) => WebPaymentFormDialog(
        formWidget: SquareWebPaymentForm(
          paymentType: PaymentType.giftCard,
          squareApplicationId: applicationId,
          squareLocationId: locationId,
          cardDetailsResult: (cardDetails) {
            onCardDetailsResult(cardDetails);
          },
        ),
        onCardDetailsResult: (cardDetails) {
          onCardDetailsResult(cardDetails);
        },
      ),
    );
  }

  static showUpdateCreditCardForSubscriptionDialog({
    required BuildContext context,
    required String applicationId,
    required String locationId,
    required Function(String) onCardDetailsResult,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WebUpdateCardForSubscription(
        formWidget: SquareWebPaymentForm(
          paymentType: PaymentType.creditCard,
          squareApplicationId: applicationId,
          squareLocationId: locationId,
          cardDetailsResult: (cardDetails) {
            onCardDetailsResult(cardDetails);
          },
        ),
        onCardDetailsResult: (cardDetails) {
          onCardDetailsResult(cardDetails);
        },
      ),
    );
  }

  static showUpdateCreditCardForMembershipMigrationDialog({
    required BuildContext context,
    required String applicationId,
    required String locationId,
    required Function(String) onCardDetailsResult,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WebUpdateCardForMembershipMigration(
        formWidget: SquareWebPaymentForm(
          paymentType: PaymentType.creditCard,
          squareApplicationId: applicationId,
          squareLocationId: locationId,
          cardDetailsResult: (cardDetails) {
            onCardDetailsResult(cardDetails);
          },
        ),
        onCardDetailsResult: (cardDetails) {
          onCardDetailsResult(cardDetails);
        },
      ),
    );
  }
}
