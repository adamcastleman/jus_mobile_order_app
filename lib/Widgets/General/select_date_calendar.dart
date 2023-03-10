import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/modal_bottom_sheets.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_order_sheet.dart';

import '../../Providers/stream_providers.dart';

class SelectDateCalendar extends ConsumerWidget {
  const SelectDateCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationsProvider);
    final selectedLocation = ref.watch(selectedLocationProvider);
    return locations.when(
      error: (e, _) => ShowError(error: e.toString()),
      loading: () => const Loading(),
      data: (location) => CalendarCarousel(
        isScrollable: false,
        firstDayOfWeek: 1,
        minSelectedDate: ref.watch(originalMinimumDateProvider),
        todayButtonColor: Colors.transparent,
        selectedDateTime: ref.watch(selectedPickupDateProvider),
        selectedDayButtonColor: Colors.black,
        selectedDayTextStyle: const TextStyle(color: Colors.white),
        headerTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
        weekdayTextStyle: const TextStyle(color: Colors.black),
        weekendTextStyle: const TextStyle(color: Colors.black),
        showHeaderButton: true,
        showOnlyCurrentMonthDate: true,
        rightButtonIcon: const Icon(CupertinoIcons.arrow_right),
        leftButtonIcon: const Icon(CupertinoIcons.arrow_left),
        onDayPressed: (value, list) {
          List dates = location
              .firstWhere((element) =>
                  element.locationID == selectedLocation.locationID)
              .blackoutDates;

          for (var date in dates) {
            var formattedDate = DateFormat('MM/dd').parse(date);
            if (value.month == formattedDate.month &&
                value.day == formattedDate.day) {
              ModalBottomSheet().partScreen(
                  isScrollControlled: true,
                  enableDrag: true,
                  isDismissible: true,
                  context: context,
                  builder: (context) => const InvalidOrderSheet(
                      error:
                          'This date is unavailable for pickup at this location. Please select another date.'));
              return;
            }
          }

          ref
              .read(selectedPickupDateProvider.notifier)
              .selected(DateTime(value.year, value.month, value.day));
        },
      ),
    );
  }
}
