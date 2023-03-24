import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

import '../Helpers/enums.dart';

final pageTypeProvider = StateProvider<PageType?>((ref) => null);

final cardNicknameProvider = StateProvider.autoDispose<String>((ref) => '');

final defaultPaymentCheckboxProvider =
    StateProvider.autoDispose<bool?>((ref) => null);

final selectedPaymentMethodProvider =
    StateNotifierProvider<SelectedPaymentMethodNotifier, Map>((ref) {
  return SelectedPaymentMethodNotifier(ref);
});

class SelectedPaymentMethodNotifier extends StateNotifier<Map> {
  SelectedPaymentMethodNotifier(this._ref) : super({}) {
    _defaultPaymentCardStreamProvider =
        _ref.watch(defaultPaymentMethodProvider);
    _defaultPaymentCardStreamProvider.whenData((payment) {
      state = {
        'cardNickname': payment.cardNickname,
        'nonce': payment.nonce,
        'lastFourDigits': payment.lastFourDigits,
        'brand': payment.brand,
      };
    });
  }

  final StateNotifierProviderRef _ref;
  late AsyncValue<PaymentsModel> _defaultPaymentCardStreamProvider;

  void updateSelectedPaymentMethod({required Map card}) {
    state = {
      'cardNickname': card['cardNickname'],
      'nonce': card['nonce'],
      'lastFourDigits': card['lastFourDigits'],
      'brand': card['brand'],
    };
  }
}
