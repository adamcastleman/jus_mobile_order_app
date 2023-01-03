import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Models/location_model.dart';
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
        00);

    DateTime todayClose = DateTime(
        currentLocationDate.year,
        currentLocationDate.month,
        currentLocationDate.day,
        close.hour,
        close.minute,
        00);

    if (convertedTime.isAfter(todayOpen) &&
        convertedTime.isBefore(todayClose)) {
      return true;
    } else {
      return false;
    }
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
}
