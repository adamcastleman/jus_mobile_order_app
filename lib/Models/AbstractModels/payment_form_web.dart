import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Models/AbstractModels/abstract_payment_form.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Services/payments_services_square.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/web_card_entry_dialog.dart';

class PaymentFormWeb extends PaymentFormManager {
  @override
  void generateCreditCardPaymentForm(
      {required BuildContext context,
      required WidgetRef ref,
      required UserModel user,
      VoidCallback? onSuccess}) {
    SquarePaymentServices().initializeSquarePaymentsSdk(
        ref: ref,
        onInitialized: (applicationId, locationId) {
          ref.read(squarePaymentSkdLoadingProvider.notifier).state = false;
          return WebCardEntry.showAddCreditCardDialog(
              context: context,
              applicationId: applicationId,
              locationId: locationId,
              onCardDetailsResult: (cardDetailsString) {
                Map<String, dynamic> cardDetails =
                    jsonDecode(cardDetailsString);
                SquarePaymentServices().processCardDetails(
                  ref: ref,
                  user: user,
                  cardDetails: cardDetails,
                  onPaymentError: (error) =>
                      ErrorHelpers.showSinglePopError(context, error: error),
                );
                onSuccess != null ? onSuccess() : null;
              });
        },
        onCardEntryError: (error) {
          ErrorHelpers.showSinglePopError(context, error: error);
        });
  }

  @override
  void generateGiftCardPaymentForm(
      {required BuildContext context,
      required WidgetRef ref,
      required UserModel user,
      VoidCallback? onSuccess}) {
    SquarePaymentServices().initializeSquarePaymentsSdk(
        ref: ref,
        onInitialized: (applicationId, locationId) {
          ref.read(squarePaymentSkdLoadingProvider.notifier).state = false;
          return WebCardEntry.showAddGiftCardDialog(
              context: context,
              applicationId: applicationId,
              locationId: locationId,
              onCardDetailsResult: (cardDetailsString) {
                Map<String, dynamic> cardDetails =
                    jsonDecode(cardDetailsString);
                SquarePaymentServices().processCardDetails(
                  ref: ref,
                  user: user,
                  cardDetails: cardDetails,
                  onPaymentError: (error) =>
                      ErrorHelpers.showSinglePopError(context, error: error),
                );
                onSuccess != null ? onSuccess() : null;
              });
        },
        onCardEntryError: (error) {
          ErrorHelpers.showSinglePopError(context, error: error);
        });
  }

  @override
  void generateCreditCardPaymentFormForMembershipMigration({
    required BuildContext context,
    required WidgetRef ref,
    required Function(String) onSuccess,
  }) {
    SquarePaymentServices().initializeSquarePaymentsSdk(
        ref: ref,
        onInitialized: (applicationId, locationId) {
          ref.read(loadingProvider.notifier).state = false;
          ref.read(squarePaymentSkdLoadingProvider.notifier).state = false;
          return WebCardEntry.showUpdateCreditCardForMembershipMigrationDialog(
              context: context,
              applicationId: applicationId,
              locationId: locationId,
              onCardDetailsResult: (cardDetailsString) {
                Map<String, dynamic> cardDetails =
                    jsonDecode(cardDetailsString);
                String nonce = cardDetails['nonce'];
                onSuccess(nonce); // Call onSuccess with the nonce
              });
        },
        onCardEntryError: (error) {
          ErrorHelpers.showSinglePopError(context, error: error);
          // Consider how you want to handle errors, perhaps calling onSuccess with an error code
        });
  }
}

PaymentFormManager getManager() => PaymentFormWeb();
