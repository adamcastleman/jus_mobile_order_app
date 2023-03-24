import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';

class PaymentsHelper {
  void updatePaymentMethod(
      {required WidgetRef ref,
      String? cardNickname,
      required String nonce,
      required String lastFourDigits,
      required String brand}) {
    ref
        .read(selectedPaymentMethodProvider.notifier)
        .updateSelectedPaymentMethod(card: {
      'cardNickname': cardNickname ?? '',
      'nonce': nonce,
      'lastFourDigits': lastFourDigits,
      'brand': brand,
    });
  }
}
