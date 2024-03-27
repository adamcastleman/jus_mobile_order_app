import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/navigation_providers.dart';
import 'package:jus_mobile_order_app/Providers/scan_providers.dart';

// In AppLifecycleNotifier, modify the constructor to accept a callback function
final appLifecycleProvider =
    StateNotifierProvider<AppLifecycleNotifier, AppLifecycleState>(
  (ref) => AppLifecycleNotifier(ref),
);

class AppLifecycleNotifier extends StateNotifier<AppLifecycleState>
    with WidgetsBindingObserver {
  final StateNotifierProviderRef ref;
  VoidCallback? onAppResume;

  AppLifecycleNotifier(this.ref) : super(AppLifecycleState.resumed) {
    WidgetsBinding.instance.addObserver(this);
  }

  void setOnAppResumeCallback(VoidCallback callback) {
    onAppResume = callback;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    this.state = state;

    int currentIndex = ref.read(bottomNavigationProvider);
    bool isScanPage = currentIndex == 1; // Assuming index 1 is the scan page

    if (isScanPage) {
      if (state == AppLifecycleState.paused) {
        ref.read(qrTimerProvider.notifier).pauseTimer();
      } else if (state == AppLifecycleState.resumed) {
        onAppResume?.call(); // Assuming this triggers the timer to resume
      }
    }
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
