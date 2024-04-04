import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

final pageTypeProvider =
    StateProvider<PageType>((ref) => PageType.editPaymentMethod);

final walletTypeProvider = StateProvider<WalletType?>((ref) => null);

final cardNicknameProvider = StateProvider<String>((ref) => '');

final defaultPaymentCheckboxProvider =
    StateProvider.autoDispose<bool?>((ref) => null);

final applePaySelectedProvider = StateProvider<bool>((ref) => false);

final isApplePayCompletedProvider = StateProvider<bool>((ref) => false);

final isLoadWalletAndPayProvider = StateProvider<bool>((ref) => false);

final physicalGiftCardBalanceProvider =
    StateProvider.autoDispose<Map>((ref) => {});

final selectedWalletProvider = StateProvider.autoDispose<PaymentsModel>(
  (ref) => const PaymentsModel(
    uid: '',
    userId: '',
    brand: '',
    last4: '',
    defaultPayment: false,
    cardNickname: '',
    isWallet: false,
    gan: '',
    balance: 0,
  ),
);

final selectedCreditCardProvider = StateProvider<PaymentsModel>(
  (ref) => const PaymentsModel(
    uid: '',
    userId: '',
    brand: '',
    last4: '',
    defaultPayment: false,
    cardNickname: '',
    isWallet: false,
    gan: '',
    balance: 0,
    cardId: '',
  ),
);

final selectedPaymentMethodProvider =
    StateNotifierProvider<SelectedPaymentMethodNotifier, PaymentsModel>((ref) {
  return SelectedPaymentMethodNotifier(ref);
});

class SelectedPaymentMethodNotifier extends StateNotifier<PaymentsModel> {
  SelectedPaymentMethodNotifier(this._ref)
      : super(const PaymentsModel(
          uid: '',
          userId: '',
          brand: '',
          last4: '',
          defaultPayment: false,
          cardNickname: '',
          isWallet: false,
          gan: '',
          balance: 0,
          cardId: '',
        )) {
    _defaultPaymentCardStreamProvider =
        _ref.watch(defaultPaymentMethodProvider);
    final user = _ref.watch(currentUserProvider).value ?? const UserModel();
    _defaultPaymentCardStreamProvider.whenData((payment) {
      if (_defaultPaymentCardStreamProvider.hasValue) {
        state = PaymentsModel(
          uid: payment.uid,
          userId: user.uid ?? '',
          brand: payment.brand,
          last4: payment.last4,
          defaultPayment: payment.defaultPayment,
          cardNickname: payment.cardNickname,
          isWallet: payment.isWallet,
          balance: payment.balance,
          cardId: payment.cardId,
          gan: payment.gan,
          expirationMonth: payment.expirationMonth,
          expirationYear: payment.expirationYear,
        );
      } else {
        state = PaymentsModel(
          uid: '',
          userId: user.uid ?? '',
          brand: '',
          last4: '',
          defaultPayment: false,
          cardNickname: '',
          isWallet: false,
          gan: '',
          balance: 0,
          cardId: '',
        );
      }
    });
  }

  final StateNotifierProviderRef _ref;
  late AsyncValue<PaymentsModel> _defaultPaymentCardStreamProvider;

  updateSelectedPaymentMethod({
    UserModel? user,
    String? cardNickname,
    String? brand,
    String? last4,
    String? cardId,
    String? gan,
    bool? isWallet,
    int? balance,
  }) {
    state = PaymentsModel(
      uid: '',
      userId: user == null || user.uid == null ? '' : user.uid!,
      brand: brand ?? '',
      last4: last4 ?? '',
      defaultPayment: false,
      cardNickname: cardNickname ?? '',
      isWallet: isWallet ?? false,
      cardId: cardId ?? '',
      gan: gan,
      balance: balance ?? 0,
    );
  }

  removeSelectedPaymentMethod() {
    state = const PaymentsModel(
      uid: '',
      userId: '',
      brand: '',
      last4: '',
      defaultPayment: false,
      cardNickname: '',
      isWallet: false,
      gan: '',
      balance: 0,
    );
  }
}

final selectedLoadAmountIndexProvider = StateProvider<int?>((ref) => null);

final selectedLoadAmountProvider =
    StateProvider.autoDispose<int?>((ref) => null);

final walletLoadAmountsProvider = Provider<List<int>>((ref) {
  List<int> amounts = List.generate(
      19,
      (index) =>
          1000 +
          500 * index); // Generates amounts from 1000 to 10000 in steps of 500
  amounts.addAll([
    12500,
    15000,
    17500,
    20000,
    22500,
    25000,
    27500,
    30000,
    32500,
    35000,
    37500,
    40000,
    42500,
    45000,
    47500,
    50000,
  ]); // Adds the remaining amounts in steps of 2500
  return amounts;
});

void invalidateWalletProviders(WidgetRef ref) {
  ref.read(loadingProvider.notifier).state = false;
  ref.read(applePayLoadingProvider.notifier).state = false;
}
