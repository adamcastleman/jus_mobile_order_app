import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/AbstractModels/payment_import_manager.dart'
    if (dart.library.io) 'package:jus_mobile_order_app/Models/AbstractModels/payment_form_mobile.dart'
    if (dart.library.js) 'package:jus_mobile_order_app/Models/AbstractModels/payment_form_web.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';

abstract class PaymentFormManager {
  static final PaymentFormManager _instance = getManager();

  static PaymentFormManager get instance {
    return _instance;
  }

  void generateCreditCardPaymentForm({
    required BuildContext context,
    required WidgetRef ref,
    required UserModel user,
    VoidCallback? onSuccess,
  });

  void generateGiftCardPaymentForm({
    required BuildContext context,
    required WidgetRef ref,
    required UserModel user,
    VoidCallback? onSuccess,
  });

  void generateCreditCardPaymentFormForMembershipMigration({
    required BuildContext context,
    required WidgetRef ref,
    required Function(String) onSuccess,
  });
}
