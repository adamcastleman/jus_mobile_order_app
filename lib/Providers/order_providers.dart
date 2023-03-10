import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedPickupTimeProvider = StateProvider<DateTime?>((ref) => null);

final originalMinimumDateProvider = StateProvider<DateTime?>((ref) => null);

final originalMinimumTimeProvider = StateProvider<DateTime?>((ref) => null);

final selectedPickupDateProvider =
    StateNotifierProvider<PickupDate, DateTime?>((ref) => PickupDate());

final scheduledProductHoursNoticeProvider = StateProvider<int>((ref) => 0);

final scheduledAndNowItemsInCartProvider = StateProvider<bool>((ref) => false);

final scheduleAllItemsProvider = StateProvider<bool>((ref) => false);

final checkOutPageProvider = StateProvider<bool>((ref) => false);

final selectedTipIndexProvider = StateProvider<int>((ref) => 0);

final selectedTipPercentageProvider = StateProvider<int>((ref) => 0);

class PickupDate extends StateNotifier<DateTime?> {
  PickupDate() : super(null);

  selected(DateTime selectedDate) {
    state = selectedDate;
  }
}
