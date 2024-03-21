import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  Future<PermissionStatus> locationPermission({
    required Future<void> Function() onGranted,
    required Future<void> Function() onDeclined,
  }) async {
    // Request permission if not already granted or permanently denied
    final status = await Permission.location.request();

    if (status.isGranted || status.isLimited) {
      // Await the onGranted callback
      await onGranted();
    } else if (status.isPermanentlyDenied) {
      // Handle permanently denied permission
      await onDeclined();
    } else {
      // Handle other cases such as denied
      await onDeclined();
    }

    return status;
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
