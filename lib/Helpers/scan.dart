import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/scan_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

import 'encryption.dart';

class ScanHelpers {
  static scanAndPayMap(WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    var message = {
      'type': 'SUB',
      'member': user.subscriptionStatus == SubscriptionStatus.active,
      'cardId': ref.watch(selectedPaymentMethodProvider).userId.isEmpty
          ? ''
          : ref.watch(selectedPaymentMethodProvider).cardId,
      'time': ref.watch(qrTimestampProvider),
    }.toString();
    var encrypted = Encryptor.encryptText(message).base64;
    ref.watch(encryptedQrProvider.notifier).state = encrypted;
  }

  static scanOnlyMap(WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value!;
    var message = {
      'type': 'SUB',
      'member': user.subscriptionStatus == SubscriptionStatus.active,
      'time': ref.watch(qrTimestampProvider),
    }.toString();
    var encrypted = Encryptor.encryptText(message).base64;
    ref.watch(encryptedQrProvider.notifier).state = encrypted;
  }

  static handleScanPageInitializers(WidgetRef ref) {
    ref.read(pageTypeProvider.notifier).state = PageType.selectPaymentMethod;
    ref.read(qrTimestampProvider.notifier).state = Time().now(ref);
    scanAndPayMap(ref);
    scanOnlyMap(ref);
    ref.read(qrTimerProvider.notifier).startTimer(ref);
  }

  static cancelQrTimer(WidgetRef ref) {
    ref.read(qrTimerProvider.notifier).cancelTimer();
  }
}
