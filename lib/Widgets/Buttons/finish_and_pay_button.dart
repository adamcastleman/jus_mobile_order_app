import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/order_validators.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:jus_mobile_order_app/Sheets/tip_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';

import '../../Helpers/Validators/checkout_validators.dart';

class FinishAndPayButton extends ConsumerWidget {
  final UserModel user;
  final ScrollController controller;

  const FinishAndPayButton(
      {required this.user, required this.controller, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LargeElevatedButton(
      buttonText: 'Finish and Pay',
      onPressed: () {
        HapticFeedback.lightImpact();
        _validateCheckoutData(context, ref, user, controller);
      },
    );
  }

  _validateCheckoutData(BuildContext context, WidgetRef ref, UserModel user,
      ScrollController controller) {
    String? validationResult =
        OrderValidators(ref: ref).checkPickupTime(context);

    if (validationResult != null) {
      ModalBottomSheet().partScreen(
        context: context,
        builder: (context) => InvalidSheetSinglePop(error: validationResult),
      );
    } else {
      _validateGuestFormAndContinue(context, ref, user, controller);
    }
  }

  void _validateGuestFormAndContinue(BuildContext context, WidgetRef ref,
      UserModel user, ScrollController controller) {
    // If user is not a guest, directly show the tip sheet.
    if (user.uid != null) {
      _showTipSheet(context, ref);
      return;
    }

    // For guests, validate the form first.
    CheckoutValidators(ref: ref).validateForm();

    // Depending on validation result, either scroll to top or show the tip sheet.
    if (!ref.read(formValidatedProvider)) {
      _scrollToTop(controller);
    } else {
      _showTipSheet(context, ref);
    }
  }

  void _scrollToTop(ScrollController controller) {
    controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void _showTipSheet(BuildContext context, WidgetRef ref) {
    ModalBottomSheet().partScreen(
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      context: context,
      builder: (context) => const TipSheet(),
    );
  }
}
