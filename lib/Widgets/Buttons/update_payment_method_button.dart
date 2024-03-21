import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Services/payment_method_database_services.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_medium.dart';

import '../../Providers/payments_providers.dart';

class UpdatePaymentMethodButton extends ConsumerWidget {
  final PaymentsModel card;
  const UpdatePaymentMethodButton({required this.card, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MediumElevatedButton(
      buttonText: 'Save',
      onPressed: () {
        _validateFormAndSaveNicknameToDatabase(context, ref);
        _validateDefaultCheckboxAndUpdateDatabase(context, ref);
      },
    );
  }

  _validateFormAndSaveNicknameToDatabase(BuildContext context, WidgetRef ref) {
    final cardNickname = ref.watch(cardNicknameProvider);

    if (cardNickname.isEmpty && card.cardNickname.isEmpty) {
      ErrorHelpers.showSinglePopError(context,
          error: 'Card nickname cannot be empty.');
    } else if (cardNickname.length > 20) {
      ErrorHelpers.showSinglePopError(context,
          error: 'This nickname is too long, please choose a shorter name.');
    } else {
      cardNickname.isEmpty
          ? ref.read(cardNicknameProvider.notifier).state = card.cardNickname
          : ref.read(cardNicknameProvider.notifier).state = cardNickname;
      ref.read(loadingProvider.notifier).state = true;

      PaymentMethodDatabaseServices(ref: ref).updateCardNickname(
          cardNickname: cardNickname,
          cardID: card.uid ?? '',
          onSuccess: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
            ref.read(loadingProvider.notifier).state = false;
          },
          onError: (error) {
            ErrorHelpers.showSinglePopError(context, error: error);
            ref.read(loadingProvider.notifier).state = false;
          });
    }
  }

  void _validateDefaultCheckboxAndUpdateDatabase(
      BuildContext context, WidgetRef ref) {
    if (ref.read(defaultPaymentCheckboxProvider) == true) {
      PaymentMethodDatabaseServices().updateDefaultPayment(
          cardID: card.uid ?? '',
          onError: (error) {
            ErrorHelpers.showSinglePopError(context, error: error);
          });
    }
  }
}
