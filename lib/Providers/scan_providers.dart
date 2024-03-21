import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/scan.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:screenshot_callback/screenshot_callback.dart';

// Provider for managing the lifecycle of ScreenshotCallback
final screenshotCallbackProvider = Provider<ScreenshotCallback>((ref) {
  final callback = ScreenshotCallback();

  // Setup listener
  callback.addListener(() {
    // Update the state to indicate a screenshot has been detected
    ref.read(screenshotDetectedProvider.notifier).state = true;

    // Reset the state after a brief delay, if desired
    Future.delayed(const Duration(seconds: 2), () {
      ref.read(screenshotDetectedProvider.notifier).state = false;
    });
  });

  // Cleanup
  ref.onDispose(() {
    callback.dispose();
  });

  return callback;
});

// Provider for tracking the screenshot detection state
final screenshotDetectedProvider = StateProvider<bool>((ref) => false);

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
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      ref.watch(qrTimestampProvider.notifier).state = Time().now(ref);
      ScanHelpers.scanAndPayMap(ref);
      ScanHelpers.scanOnlyMap(ref);
    });
  }

  void cancelTimer() {
    _timer.cancel();
  }
}
