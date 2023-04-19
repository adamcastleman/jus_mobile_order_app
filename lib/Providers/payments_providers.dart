import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

final pageTypeProvider =
    StateProvider<PageType>((ref) => PageType.editPaymentMethod);

final cardNicknameProvider = StateProvider<String>((ref) => '');

final defaultPaymentCheckboxProvider =
    StateProvider.autoDispose<bool?>((ref) => null);

final applePaySelectedProvider = StateProvider<bool>((ref) => false);

final physicalGiftCardBalanceProvider =
    StateProvider.autoDispose<Map>((ref) => {});

final currentlySelectedWalletProvider =
    StateProvider.autoDispose<Map>((ref) => {});

final selectedPaymentMethodProvider =
    StateNotifierProvider<SelectedPaymentMethodNotifier, Map>((ref) {
  return SelectedPaymentMethodNotifier(ref);
});

class SelectedPaymentMethodNotifier extends StateNotifier<Map> {
  SelectedPaymentMethodNotifier(this._ref) : super({}) {
    _defaultPaymentCardStreamProvider =
        _ref.watch(defaultPaymentMethodProvider);
    _defaultPaymentCardStreamProvider.whenData((payment) {
      if (_defaultPaymentCardStreamProvider.hasValue) {
        state = {
          'cardNickname': payment.cardNickname,
          'nonce': payment.nonce,
          'balance': payment.balance,
          'gan': payment.gan,
          'lastFourDigits': payment.lastFourDigits,
          'brand': payment.brand,
          'isWallet': payment.isWallet,
        };
      }
    });
  }

  final StateNotifierProviderRef _ref;
  late AsyncValue<PaymentsModel> _defaultPaymentCardStreamProvider;

  updateSelectedPaymentMethod({required Map card}) {
    state = {
      'cardNickname': card['cardNickname'],
      'nonce': card['nonce'],
      'gan': card['gan'],
      'balance': card['balance'],
      'lastFourDigits': card['lastFourDigits'],
      'brand': card['brand'],
      'isWallet': card['isWallet'],
    };
  }

  removeSelectedPaymentMethod() {
    state = {};
  }
}

final selectedLoadAmountIndexProvider = StateProvider<int>((ref) => 3);

final selectedLoadAmountProvider = StateProvider<int?>((ref) => null);

final loadAmountsProvider = Provider<List<int>>((ref) => [
      1000,
      1500,
      2000,
      2500,
      3000,
      3500,
      4000,
      4500,
      5000,
      5500,
      6000,
      6500,
      7000,
      7500,
      8000,
      8500,
      9000,
      9500,
      10000,
    ]);
