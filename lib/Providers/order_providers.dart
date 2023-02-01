import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/dates.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/time.dart';

final earliestPickupTimeProvider = StateProvider.family<DateTime, dynamic>(
    (ref, location) =>
        Time().convertLocalTimeToLocationTime(location: location).earliestTime);

final selectedPickupTimeProvider = StateProvider<DateTime?>((ref) => null);

final selectedPickupDateProvider = StateProvider<DateTime?>((ref) => null);

final scheduledAndNowItemsInCartProvider = StateProvider<bool>((ref) => false);

final scheduleAllItemsProvider = StateProvider<bool>((ref) => false);
