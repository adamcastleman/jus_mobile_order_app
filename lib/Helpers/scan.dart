import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/enums.dart';
import 'package:jus_mobile_order_app/Models/payments_model.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Providers/loading_providers.dart';
import 'package:jus_mobile_order_app/Providers/payments_providers.dart';
import 'package:jus_mobile_order_app/Providers/scan_providers.dart';
import 'package:jus_mobile_order_app/Providers/stream_providers.dart';

import 'encryption.dart';

class ScanHelpers {
  static Future<void> scanAndPayMap(
      WidgetRef ref, UserModel user, PaymentsModel selectedPayment) async {
    var message = {
      'type': 'SUBSCRIPTION',
      'member': user.subscriptionStatus,
      'cardId': selectedPayment.cardId,
    }.toString();

    var encrypted = await Encryption().encryptText(message);
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    ref.read(encryptedScanAndPayProvider.notifier).state =
        '$encrypted,$timestamp';
  }

  static Future<void> scanOnlyMap(WidgetRef ref, UserModel user) async {
    var message = {
      'type': 'SUBSCRIPTION',
      'member': user.subscriptionStatus!.isActive,
    }.toString();
    var encrypted = await Encryption().encryptText(message);
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    ref.read(encryptedScanOnlyProvider.notifier).state =
        '$encrypted,$timestamp';
  }

  static Future<void> handleScanAndPayPageInitializers(WidgetRef ref) async {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);
    ref.read(qrLoadingProvider.notifier).state = true;
    ref.read(pageTypeProvider.notifier).state = PageType.selectPaymentMethod;
    ref.read(qrTimestampProvider.notifier).state =
        DateTime.now().millisecondsSinceEpoch;

    // Encrypts static data and stores it
    await scanAndPayMap(ref, user, selectedPayment);

    ref.read(qrTimerProvider.notifier).returnEpochTimeEveryTenSeconds(
        onTimerUpdate: (time) {
      final encryptedScanAndPay = ref.watch(encryptedScanAndPayProvider);
      var parts = encryptedScanAndPay.split(',');
      var encryptedData = parts.sublist(0, parts.length - 1).join(',');
      String newCode = '$encryptedData,$time';
      ref.read(encryptedScanAndPayProvider.notifier).state = newCode;
    }); // Start updating timestamp separately
    ref.read(qrLoadingProvider.notifier).state = false;
  }

  static Future<void> handleScanOnlyPageInitializers(WidgetRef ref) async {
    final user = ref.watch(currentUserProvider).value ?? const UserModel();
    ref.read(qrLoadingProvider.notifier).state = true;
    ref.read(qrTimestampProvider.notifier).state =
        DateTime.now().millisecondsSinceEpoch;

    // Encrypts static data and stores it
    await scanOnlyMap(ref, user);

    ref.read(qrTimerProvider.notifier).returnEpochTimeEveryTenSeconds(
        onTimerUpdate: (time) {
      final encryptedScanOnly = ref.watch(encryptedScanOnlyProvider);
      var parts = encryptedScanOnly.split(',');
      var encryptedData = parts.sublist(0, parts.length - 1).join(',');
      String newCode = '$encryptedData,$time';
      ref.read(encryptedScanOnlyProvider.notifier).state = newCode;
    }); // Start updating timestamp separately
    ref.read(qrLoadingProvider.notifier).state = false;
  }

  static cancelQrTimer(WidgetRef ref) {
    ref.read(qrTimerProvider.notifier).cancelTimer();
  }
}
