import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
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

final qrTimestampProvider = StateProvider<int>((ref) => 0);

final encryptedScanAndPayProvider = StateProvider<String>((ref) => '');

final encryptedScanOnlyProvider = StateProvider<String>((ref) => '');

final qrTimerProvider =
    StateNotifierProvider<TimerController, bool>((ref) => TimerController());

class TimerController extends StateNotifier<bool> {
  Timer? _timer;

  TimerController() : super(false);

  void returnEpochTimeEveryTenSeconds({required Function(int) onTimerUpdate}) {
    _timer?.cancel(); // Cancel existing timer if any
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      onTimerUpdate(timestamp);
    });
  }

  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void pauseTimer() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
  }

  void resumeTimer({required Function(int) onTimerUpdate}) {
    if (_timer == null || !_timer!.isActive) {
      returnEpochTimeEveryTenSeconds(onTimerUpdate: onTimerUpdate);
    }
  }
}
