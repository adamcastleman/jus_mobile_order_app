import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/open_app_settings_calendar.dart';
import 'package:jus_mobile_order_app/Widgets/Dialogs/open_app_settings_location.dart';
import 'package:permission_handler/permission_handler.dart';

class HandlePermissions {
  BuildContext context;
  WidgetRef ref;
  HandlePermissions(this.context, this.ref);
  Future<PermissionStatus> locationPermission() async {
    if (await Permission.location.isDenied) {
      return Permission.location.request();
    } else if (await Permission.location.isPermanentlyDenied) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => const LocationPermissionAlertDialog(),
        );
      }
      return await Permission.location.status;
    } else if (await Permission.location.status.isGranted ||
        await Permission.location.status.isLimited) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      ref.read(currentLocationLatLongProvider.notifier).state =
          LatLng(position.latitude, position.longitude);
      ref.read(currentLocationLatLongProvider.notifier).state =
          LatLng(position.latitude, position.longitude);
      return await Permission.location.status;
    } else {
      return await Permission.location.status;
    }
  }

  calendarPermission() async {
    if (await Permission.calendarFullAccess.isDenied) {
      return Permission.calendarFullAccess.request();
    } else if (await Permission.calendarFullAccess.isDenied) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => const CalendarPermissionAlertDialog(),
        );
      }
    } else if (await Permission.calendarFullAccess.isGranted) {
      return;
    }
  }
}
