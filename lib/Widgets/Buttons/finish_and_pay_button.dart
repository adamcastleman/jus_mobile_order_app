import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/Validators/order_validators.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/auth_providers.dart';
import 'package:jus_mobile_order_app/Sheets/finalize_payment_sheet.dart';
import 'package:jus_mobile_order_app/Widgets/Buttons/elevated_button_large.dart';
import 'package:jus_mobile_order_app/constants.dart';

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
    String? validationResult = OrderValidators().checkPickupTime(context, ref);

    if (validationResult != null) {
      ErrorHelpers.showSinglePopError(
        context,
        error: validationResult,
      );
    } else {
      _validateGuestFormAndContinue(context, ref, user, controller);
    }
  }

  void _validateGuestFormAndContinue(BuildContext context, WidgetRef ref,
      UserModel user, ScrollController controller) {
    // If user is not a guest, directly show the finalize payment sheet.
    if (user.uid != null) {
      NavigationHelpers.navigateToPartScreenSheetOrEndDrawer(
        context,
        ref,
        AppConstants.scaffoldKey,
        const FinalizePaymentSheet(),
      );
      return;
    }

    // For guests, validate the form first.
    CheckoutValidators().validateForm(ref);

    // Depending on validation result, either scroll to top or show the finalize payment sheet.
    if (!ref.read(formValidatedProvider)) {
      _scrollToTop(controller);
    } else {
      NavigationHelpers.navigateToPartScreenSheetOrEndDrawer(
        context,
        ref,
        AppConstants.scaffoldKey,
        const FinalizePaymentSheet(),
      );
    }
  }

  void _scrollToTop(ScrollController controller) {
    controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }
}
