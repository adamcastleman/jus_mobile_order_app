import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';

final scanCategoryProvider = StateProvider<int>((ref) => 0);

final qrTimestampProvider = StateProvider<DateTime>((ref) => DateTime.now());

final encryptedQrProvider = StateProvider<String>((ref) => '');

final qrTimerProvider =
    StateNotifierProvider<TimerController, bool>((ref) => TimerController());

class TimerController extends StateNotifier<bool> {
  late Timer _timer;

  TimerController() : super(false) {
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {});
  }

  void startTimer(WidgetRef ref) {
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
      ref.watch(qrTimestampProvider.notifier).state = Time().now(ref);
      ScanHelpers(ref).scanAndPayMap();
      ScanHelpers(ref).scanOnlyMap();
    });
  }

  void cancelTimer() {
    _timer.cancel();
  }
}
