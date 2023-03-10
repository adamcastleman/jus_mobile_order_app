import 'package:flutter/cupertino.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionAlertDialog extends StatelessWidget {
  const LocationPermissionAlertDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Turn on location permissions'),
      content: Column(
        children: [
          Spacing().vertical(10),
          const Text(
              'We use your location to find stores near you. Turn on location permission in settings to help you search for relevant stores more quickly.'),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text('Settings'),
          onPressed: () async {
            await openAppSettings();
          },
        ),
      ],
    );
  }
}
