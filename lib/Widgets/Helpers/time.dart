import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/dates.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/locations.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Time {
  initialize() {
    return tz.initializeTimeZones();
  }

  Future<String> currentDevice() async {
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
    final locationTimezone = tz.getLocation(location.timezone);
    var convertTime = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(tz.TZDateTime.from(deviceTime, locationTimezone));
    var parseTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(convertTime);
    return parseTime;
  }

  bool locationOpenStatus({required LocationModel location}) {
    initialize();
    DateTime currentLocationDate = getLocationCurrentTime(location: location);
    var convertedTime = convertLocalTimeToLocationTime(location: location);
    DateFormat format = DateFormat('HH:mm');

    TimeOfDay open = TimeOfDay.fromDateTime(
        format.parse(location.hours[currentLocationDate.weekday - 1]['open']));
    TimeOfDay close = TimeOfDay.fromDateTime(
        format.parse(location.hours[currentLocationDate.weekday - 1]['close']));

    DateTime todayOpen = DateTime(
      currentLocationDate.year,
      currentLocationDate.month,
      currentLocationDate.day,
      open.hour,
      open.minute,
      0,
    );
    DateTime todayClose = DateTime(
      currentLocationDate.year,
      currentLocationDate.month,
      currentLocationDate.day,
      close.hour,
      close.minute,
      0,
    );

    return convertedTime.isAfter(todayOpen) &&
        convertedTime.isBefore(todayClose);
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
        ? DateTime.now().earliestTime
        : Time()
            .convertLocalTimeToLocationTime(location: selectedLocation)
            .earliestTime;
  }

  earliestPickUpTime(WidgetRef ref) {
    final selectedLocation = LocationHelper().selectedLocation(ref);
    return selectedLocation == null
        ? DateTime.now().earliestTime
        : convertLocalTimeToLocationTime(location: selectedLocation)
            .earliestTime;
  }

  openTime(WidgetRef ref) {
    final selectedLocation = LocationHelper().selectedLocation(ref);
    final open = ref.watch(selectedLocationOpenTime);
    final now = selectedLocation == null
        ? DateTime.now()
        : Time().convertLocalTimeToLocationTime(location: selectedLocation);
    return DateTime(
      now.year,
      now.month,
      now.day,
      open.hour,
      open.minute,
    ).add(const Duration(minutes: 15));
  }

  closeTime(WidgetRef ref) {
    final selectedLocation = LocationHelper().selectedLocation(ref);
    final close = ref.watch(selectedLocationCloseTime);
    final now = selectedLocation == null
        ? DateTime.now()
        : Time().convertLocalTimeToLocationTime(location: selectedLocation);
    return DateTime(
      now.year,
      now.month,
      now.day,
      close.hour,
      close.minute,
    ).add(
      const Duration(minutes: 15),
    );
  }

  bool acceptingOrders(BuildContext context, WidgetRef ref) {
    final closeTime = Time().closeTime(ref);
    final openTime = Time().openTime(ref);
    final now = Time().now(ref);

    return now.isAfter(openTime) && now.isBefore(closeTime);
  }
}
