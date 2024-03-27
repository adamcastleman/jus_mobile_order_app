import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final loadingProvider = StateProvider.autoDispose<bool>((ref) => false);

final giftCardLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

final buttonKeyProvider = StateProvider.autoDispose<UniqueKey?>((ref) => null);

final tileKeyProvider = StateProvider.autoDispose<UniqueKey?>((ref) => null);

final squarePaymentSkdLoadingProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final qrLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

final locationLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

final applePayLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

void invalidateLoadingProviders(WidgetRef ref) {
  ref.read(loadingProvider.notifier).state = false;
  ref.read(applePayLoadingProvider.notifier).state = false;
}
