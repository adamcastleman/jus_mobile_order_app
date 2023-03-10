import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Time {
  initialize() {
    return tz.initializeTimeZones();
  }

  Future<String> currentDeviceTimezone() async {
    initialize();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    return currentTimeZone;
  }

  DateTime getLocationCurrentTime({required LocationModel location}) {
    initialize();
    final locationTimezone = tz.getLocation(location.timezone);
    var now = tz.TZDateTime.now(locationTimezone);
    return now;
  }

  DateTime convertLocalTimeToLocationTime({required LocationModel location}) {
    initialize();
    var deviceTime = DateTime.now();
    final locationTimezone = tz.getLocation(
        location.uid.isEmpty ? 'America/Los_Angeles' : location.timezone);
    var convertTime = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(tz.TZDateTime.from(deviceTime, locationTimezone));
    var parseTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(convertTime);
    return parseTime;
  }

  bool isLocationOpen({required LocationModel location}) {
    initialize();
    DateTime locationTime = getLocationCurrentTime(location: location);
    var convertedTime = convertLocalTimeToLocationTime(location: location);
    DateFormat timeFormat = DateFormat('HH:mm');

    TimeOfDay openTime = TimeOfDay.fromDateTime(
        timeFormat.parse(location.hours[locationTime.weekday - 1]['open']));
    TimeOfDay closeTime = TimeOfDay.fromDateTime(
        timeFormat.parse(location.hours[locationTime.weekday - 1]['close']));

    DateTime open = DateTime(
      locationTime.year,
      locationTime.month,
      locationTime.day,
      openTime.hour,
      openTime.minute,
      0,
    );
    DateTime close = DateTime(
      locationTime.year,
      locationTime.month,
      locationTime.day,
      closeTime.hour,
      closeTime.minute,
      0,
    );

    return convertedTime.isAfter(open) && convertedTime.isBefore(close);
  }

  bool isLocationClosingSoon(LocationModel location) {
    initialize();
    DateTime locationTime = getLocationCurrentTime(location: location);
    var convertedTime = convertLocalTimeToLocationTime(location: location);
    DateFormat timeFormat = DateFormat('HH:mm');

    TimeOfDay closeTime = TimeOfDay.fromDateTime(
        timeFormat.parse(location.hours[locationTime.weekday - 1]['close']));

    DateTime beginClose = DateTime(
      locationTime.year,
      locationTime.month,
      locationTime.day,
      closeTime.hour,
      closeTime.minute,
      0,
    ).subtract(const Duration(minutes: 30));

    DateTime close = DateTime(
      locationTime.year,
      locationTime.month,
      locationTime.day,
      closeTime.hour,
      closeTime.minute,
      0,
    );

    return convertedTime.isAfter(beginClose) && convertedTime.isBefore(close);
  }

  String locationTimezoneAbbreviation(
      {required String deviceTimezone, required String locationTimezone}) {
    initialize();
    var zone = tz.getLocation(locationTimezone);
    String abbreviation = zone.currentTimeZone.abbreviation;
    if (locationTimezone == deviceTimezone) {
      return '';
    } else {
      return '($abbreviation)';
    }
  }

  now(WidgetRef ref) {
    final selectedLocation = LocationHelper().selectedLocation(ref);

    return selectedLocation == null
        ? DateTime.now()
        : Time().convertLocalTimeToLocationTime(location: selectedLocation);
  }

  nowRounded(WidgetRef ref) {
    final selectedLocation = LocationHelper().selectedLocation(ref);
    return selectedLocation == null
        ? DateTime.now().earliestRoundedTime
        : Time()
            .convertLocalTimeToLocationTime(location: selectedLocation)
            .earliestRoundedTime;
  }

  earliestPickUpTime(WidgetRef ref) {
    final selectedLocation = LocationHelper().selectedLocation(ref);
    return selectedLocation == null
        ? DateTime.now().earliestRoundedTime
        : convertLocalTimeToLocationTime(location: selectedLocation)
            .earliestRoundedTime;
  }

  openTime(WidgetRef ref) {
    final selectedLocation = LocationHelper().selectedLocation(ref);
    final open = ref.watch(selectedLocationOpenTime);
    final now =
        selectedLocation == null ? DateTime.now() : Time().nowRounded(ref);
    return DateTime(
      now.year,
      now.month,
      now.day,
      open.hour,
      open.minute,
    ).add(
      const Duration(minutes: 10),
    );
  }

  DateTime closeTime(WidgetRef ref) {
    final selectedLocation = LocationHelper().selectedLocation(ref);
    final close = ref.watch(selectedLocationCloseTime);
    final now =
        selectedLocation == null ? DateTime.now() : Time().nowRounded(ref);

    return DateTime(
      now.year,
      now.month,
      now.day,
      close.hour,
      close.minute,
    ).subtract(
      const Duration(minutes: 15),
    );
  }

  bool acceptingOrders(BuildContext context, WidgetRef ref) {
    final close = Time().closeTime(ref);
    final open = Time().openTime(ref);
    final now = Time().nowRounded(ref);

    return now.isAfter(open) && now.isBefore(close);
  }

  String displayPickupDate(WidgetRef ref) {
    final selectedDate = ref.watch(selectedPickupDateProvider);
    if (selectedDate == null) {
      return '';
    } else {
      return DateFormat('EEEE · MMM. d, yyyy').format(selectedDate);
    }
  }

  String formatPickupTime(WidgetRef ref) {
    var earliestTime = earliestPickUpTime(ref);
    final selectedTime = ref.watch(selectedPickupTimeProvider);
    final now = DateTime.now();

    final selectedDate = selectedTime?.toLocal() ?? earliestTime.toLocal();
    final today = now.toLocal().toIso8601String().substring(0, 10);
    final selectedDateIso = selectedDate.toIso8601String().substring(0, 10);
    final tomorrow = now
        .add(
          const Duration(hours: 24),
        )
        .toLocal()
        .toIso8601String()
        .substring(0, 10);

    if (selectedDateIso == today) return 'Today';
    if (selectedDateIso == tomorrow) return 'Tomorrow';

    return DateFormat('EEEE MMM. dd').format(selectedDate);
  }

  String formatDateRange(DateTime startDate, DateTime endDate) {
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      return DateFormat('MM/dd/yy').format(startDate);
    } else {
      return '${DateFormat('MM/dd/yy').format(startDate)} - ${DateFormat('MM/dd/yy').format(endDate)}';
    }
  }
}

extension DateTimeExt on DateTime {
  DateTime get earliestRoundedTime {
    int rounded = minute + 10;
    int remainder = rounded % 5;
    int roundedUp = rounded - remainder;
    return DateTime(year, month, day, hour, roundedUp);
  }
}
