import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/utilities.dart';
import 'package:jus_mobile_order_app/Models/AbstractModels/abstract_payment_form.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';

class PaymentMethodHelpers {

  void addCreditCardAsSelectedPayment(
      BuildContext context, WidgetRef ref, UserModel user,
      {required VoidCallback onSuccess}) {
    final paymentFormManager = PaymentFormManager.instance;
    ref.read(squarePaymentSkdLoadingProvider.notifier).state = true;
    paymentFormManager.generateCreditCardPaymentForm(
      context: context,
      ref: ref,
      user: user,
      onSuccess: onSuccess,
    );
  }

  void showSquareGiftCardEntryForm(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) {
    final paymentFormManager = PaymentFormManager.instance;
    paymentFormManager.generateGiftCardPaymentForm(
      context: context,
      ref: ref,
      user: user,
      onSuccess: () {
        ref.read(squarePaymentSkdLoadingProvider.notifier).state = false;
        if (PlatformUtils.isWeb()) {
          Navigator.pop(context);
        }
      },
    );
  }

  void validateCreateWalletSheet({
    required UserModel user,
    required List<PaymentsModel> paymentSources,
    required VoidCallback onGuest,
    required VoidCallback onEmptyPaymentSource,
    required VoidCallback onSuccess,
  }) {
    if (user.uid == null) {
      onGuest();
      return;
    }
    if (paymentSources.isEmpty) {
      onEmptyPaymentSource();
      return;
    } else {
      onSuccess();
    }
  }

  setCreditCardProviderToValidPaymentMethod(
      WidgetRef ref, PaymentsModel creditCard) {
    ref.read(selectedCreditCardProvider.notifier).state = PaymentsModel(
      userId: creditCard.userId,
      brand: creditCard.brand,
      last4: creditCard.last4,
      defaultPayment: creditCard.defaultPayment,
      cardNickname: creditCard.cardNickname,
      isWallet: creditCard.isWallet,
      cardId: creditCard.cardId,
    );
  }

  setSelectedPaymentToValidPaymentMethod(
      WidgetRef ref, UserModel user, List<PaymentsModel> creditCards) {
    if (creditCards.isEmpty) {
      ref
          .read(selectedPaymentMethodProvider.notifier)
          .updateSelectedPaymentMethod();
    } else {
      final eligibleCard =
          creditCards.firstWhere((element) => !element.isWallet);
      ref
          .read(selectedPaymentMethodProvider.notifier)
          .updateSelectedPaymentMethod(
            user: user,
            cardNickname: eligibleCard.cardNickname,
            isWallet: eligibleCard.isWallet,
            cardId: eligibleCard.cardId,
            gan: eligibleCard.gan,
            brand: eligibleCard.brand,
            balance: eligibleCard.balance,
            last4: eligibleCard.last4,
          );
    }
  }

  String displaySelectedCardText(PaymentsModel? card) {
    if (card == null || card.last4.isEmpty) {
      return 'Add Payment Method';
    }

    // For wallet cards
    if (card.isWallet) {
      return '${card.cardNickname.trim()} - x${card.last4}';
    }

// For non-wallet cards
    String brand = card.brand.isNotEmpty ? displayBrandName(card.brand) : '';
    String cardNickname = card.cardNickname.trim();

// Use conditional expression to format the string based on cardNickname's presence
    return cardNickname.isNotEmpty
        ? '$cardNickname - $brand x${card.last4}'
        : '$brand x${card.last4}'.trim();
  }

  String displayBrandName(String brand) {
    var normalizedBrand =
        brand.toLowerCase().replaceAll('_', '').replaceAll(' ', '');

    switch (normalizedBrand) {
      case 'visa':
        return 'Visa';
      case 'mastercard':
        return 'Mastercard';
      case 'amex':
        return 'AmEx';
      case 'americanexpress':
        return 'AmEx';
      case 'discover':
        return 'Discover';
      case 'jcb':
        return 'JCB';
      case 'chinaunionpay':
        return 'China UnionPay';
      case 'interac':
        return 'Interac';
      case 'dinersclub':
        return 'Diners Club';
      case 'discoverdiners':
        return 'Diners Club';
      default:
        return '';
    }
  }
}
