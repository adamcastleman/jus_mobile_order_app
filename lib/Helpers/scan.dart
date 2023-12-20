import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/scan_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

import 'encryption.dart';

class ScanHelpers {
  final WidgetRef ref;

  ScanHelpers(this.ref);
  scanAndPayMap() {
    final currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => {},
      data: (user) {
        var message = {
          'type': 'SUB',
          'member': user.isActiveMember,
          'cardId': ref.watch(selectedPaymentMethodProvider)['cardId'],
          'time': ref.watch(qrTimestampProvider),
        }.toString();
        var encrypted = Encryptor.encryptText(message).base64;
        ref.watch(encryptedQrProvider.notifier).state = encrypted;
      },
    );
  }

  scanOnlyMap() {
    final currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => {},
      data: (user) {
        var message = {
          'type': 'SUB',
          'member': user.isActiveMember,
          'time': ref.watch(qrTimestampProvider),
        }.toString();
        var encrypted = Encryptor.encryptText(message).base64;
        ref.watch(encryptedQrProvider.notifier).state = encrypted;
      },
    );
  }
}
