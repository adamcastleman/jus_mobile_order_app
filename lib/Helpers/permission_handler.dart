import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  Future<PermissionStatus> locationPermission(
      {required VoidCallback onGranted,
      required VoidCallback onDeclined}) async {
    // Request permission if not already granted or permanently denied
    if (await Permission.location.isDenied) {
      final status = await Permission.location.request();

      if (status.isGranted || status.isLimited) {
        onGranted();
      } else {
        onDeclined();
      }
      return status;
    } else if (await Permission.location.isPermanentlyDenied) {
      onDeclined();
      return await Permission.location.status;
    } else {
      onGranted();
      return await Permission.location.status;
    }
  }

  calendarPermission({required isDenied}) async {
    if (await Permission.calendarFullAccess.isDenied) {
      return Permission.calendarFullAccess.request();
    } else if (await Permission.calendarFullAccess.isDenied) {
      isDenied();
      return;
    } else if (await Permission.calendarFullAccess.isGranted) {
      return;
    }
  }
}
