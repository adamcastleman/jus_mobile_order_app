import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';

class DateHelper {
  String displayPickupDate(WidgetRef ref) {
    final selectedDate = ref.watch(selectedPickupDateProvider);
    if (selectedDate == null) {
      return '';
    } else {
      return DateFormat('EEEE · MMM. d, yyyy').format(selectedDate);
    }
  }

  String displayPickupTime(WidgetRef ref) {
    final earliestTime = ref
        .watch(earliestPickupTimeProvider(ref.watch(selectedLocationProvider)));
    final selectedTime = ref.watch(selectedPickupTimeProvider);
    final now = DateTime.now();

    final selectedDate = selectedTime?.toLocal() ?? earliestTime.toLocal();
    final today = now.toLocal().toIso8601String().substring(0, 10);
    final selectedDateIso = selectedDate.toIso8601String().substring(0, 10);
    final tomorrow = now
        .add(const Duration(hours: 24))
        .toLocal()
        .toIso8601String()
        .substring(0, 10);
    if (selectedDateIso == today) {
      return 'Today';
    } else if (selectedDateIso == tomorrow) {
      return 'Tomorrow';
    } else {
      return DateFormat('EEEE MMM. dd').format(selectedDate);
    }
  }
}

extension DateTimeExt on DateTime {
  DateTime get earliestTime => DateTime(year, month, day, hour, () {
        var rounded = minute + 10;
        var remainder = rounded % 5;
        var roundedUp = rounded - remainder;
        return roundedUp;
      }());
}
