import 'package:hooks_riverpod/hooks_riverpod.dart';

final loadingProvider = StateProvider.autoDispose<bool>((ref) => false);

final applePayLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
