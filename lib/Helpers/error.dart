import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_double_pop.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';

class ShowError extends StatelessWidget {
  final String? error;

  const ShowError({this.error, super.key});
  @override
  Widget build(BuildContext context) {
    if (error == null) {
      return const SizedBox();
    } else {
      debugPrint(error);
      return Text(
        error!,
        style: const TextStyle(
          color: Colors.red,
        ),
        textAlign: TextAlign.center,
      );
    }
  }
}

class ErrorHelpers {
  static showSinglePopError(BuildContext context, {String? error}) {
    return NavigationHelpers.navigateToPartScreenSheetOrDialog(
      context,
      InvalidSheetSinglePop(
        error: error ?? '',
      ),
    );
  }

  static showDoublePopError(BuildContext context, {String? error}) {
    return NavigationHelpers.navigateToPartScreenSheetOrDialog(
      context,
      InvalidSheetDoublePop(
        error: error ?? '',
      ),
    );
  }
}

enum SquarePaymentsErrorType {
  addressVerificationFailure,
  cardholderInsufficientPermissions,
  cardExpired,
  cardNotSupported,
  cardTokenExpired,
  cardTokenUsed,
  cvvFailure,
  expirationFailure,
  genericDecline,
  giftCardAvailableAmount,
  insufficientFunds,
  insufficientPermissions,
  invalidAccount,
  invalidCard,
  invalidCardData,
  invalidEmailAddress,
  invalidExpiration,
  invalidFees,
  invalidLocation,
  invalidPin,
  invalidPostalCode,
  manuallyEnteredPaymentNotSupported,
  panFailure,
  paymentAmountMismatch,
  paymentLimitExceeded,
  transactionLimit,
  voiceFailure,
  allowablePinTriesExceeded,
  badExpiration,
  cardDeclinedVerificationRequired,
  chipInsertionRequired,
  cardProcessingNotEnabled,
  temporaryError,
}

class SquarePaymentsErrors {
  static String getSquareErrorMessage(String error) {
    final errorCode = error
        .replaceAll('Authorization error: ', '')
        .replaceAll("'", '') // This will remove single quotes
        .trim()
        .replaceAll('\n', '');

    switch (errorCode) {
      case 'ADDRESS_VERIFICATION_FAILURE':
        return 'The card issuer declined the request because the postal code is invalid.';
      case 'CARDHOLDER_INSUFFICIENT_PERMISSIONS':
        return 'The card issuer has declined the transaction due to restrictions on where this card can be used.';
      case 'CARD_EXPIRED':
        return 'The card issuer declined the request because the card is expired.';
      case 'CARD_NOT_SUPPORTED':
        return 'Sorry, we don\'t support this type of card.';
      case 'CARD_TOKEN_EXPIRED':
        return 'The provided card token has expired, please reupload this card.';
      case 'CARD_TOKEN_USED':
        return 'We have already processed the payment or refund for this transaction.';
      case 'CVV_FAILURE':
        return 'The card issuer declined the request because the CVV value is invalid.';
      case 'EXPIRATION_FAILURE':
        return 'The card expiration date is either invalid or indicates that the card is expired.';
      case 'GENERIC_DECLINE':
        return 'This card was declined without any additional information on why. Please contact your bank.';
      case 'GIFT_CARD_AVAILABLE_AMOUNT':
        return 'We can\'t accept partial payments from a gift card if if your purchase also includes a tip';
      case 'INSUFFICIENT_FUNDS':
        return 'There are insufficient funds to cover the cost of this transaction.';
      case 'INSUFFICIENT_PERMISSIONS':
        return 'We\'re sorry, but we cannot accept this payment method.';
      case 'INVALID_ACCOUNT':
        return 'The issuer was not able to locate the account attached to this card.';
      case 'INVALID_CARD':
        return 'The credit card cannot be validated based on the provided details.';
      case 'INVALID_CARD_DATA':
        return 'The provided card data is invalid.';
      case 'INVALID_EMAIL_ADDRESS':
        return 'The provided email address is invalid.';
      case 'INVALID_EXPIRATION':
        return 'The expiration date for the payment card is invalid. For example, it may indicate a date in the past.';
      case 'INVALID_FEES':
        return 'We have stopped this transaction to save you from surging, unreasonable fees. Please try again later.';
      case 'INVALID_LOCATION':
        return 'We cannot accept payments in this specified region.';
      case 'INVALID_PIN':
        return 'The card issuer declined the request because the PIN is invalid.';
      case 'INVALID_POSTAL_CODE':
        return 'The postal code is incorrectly formatted.';
      case 'MANUALLY_ENTERED_PAYMENT_NOT_SUPPORTED':
        return 'The card must be swiped, tapped, or dipped. Payments attempted by manually entering the card number are currently being declined.';
      case 'PAN_FAILURE':
        return 'The specified card number is invalid. For example, it is of incorrect length or is incorrectly formatted.';
      case 'PAYMENT_AMOUNT_MISMATCH':
        return 'The payment was canceled because there was a payment amount mismatch.';
      case 'PAYMENT_LIMIT_EXCEEDED':
        return 'The issuer declined the request because the payment amount exceeded the processing limit for our accounts.';
      case 'TRANSACTION_LIMIT':
        return 'The card issuer has determined the payment amount is either too high or too low - most likely too close to your credit limit.';
      case 'VOICE_FAILURE':
        return 'The card issuer declined the request because the issuer requires voice authorization from the cardholder. Please contact the card issuing bank to authorize the payment.';
      case 'ALLOWABLE_PIN_TRIES_EXCEEDED':
        return 'The card has exhausted its available pin entry retries set by the card issuer. Please contact the card issuer.';
      case 'BAD_EXPIRATION':
        return 'The card expiration date is either missing or incorrectly formatted.';
      case 'CARD_DECLINED_VERIFICATION_REQUIRED':
        return 'The payment card was declined with a request for additional verification.';
      case 'CHIP_INSERTION_REQUIRED':
        return 'The card issuer requires that the card be read using a chip reader.';
      case 'CARD_PROCESSING_NOT_ENABLED':
        return 'This location cannot accept credit card payments right now.';
      case 'VALUE_TOO_LOW':
        return 'We cannot process a \$0.00 charge right now.';
      case 'TEMPORARY_ERROR':
        return 'A temporary internal error occurred. We did not process your transaction. You can safely try again.';
      default:
        return 'Unknown error. Please try again later.';
    }
  }
}
