import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedCreditCardProvider = StateProvider<Map>((ref) => {});

final cardNicknameProvider = StateProvider.autoDispose<String>((ref) => '');

final defaultPaymentSelectedProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final guestCreditCardNonceProvider =
    StateNotifierProvider<AddCardData, Map>((ref) => AddCardData());

class AddCardData extends StateNotifier<Map> {
  AddCardData() : super({});

  add(String nonce, String lastFourDigits, String brand) {
    state = {
      'nonce': nonce,
      'lastFourDigits': lastFourDigits,
      'brand': brand,
    };
  }
}
