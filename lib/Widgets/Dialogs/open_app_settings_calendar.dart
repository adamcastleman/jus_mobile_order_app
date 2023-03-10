import 'package:flutter/cupertino.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class CalendarPermissionAlertDialog extends StatelessWidget {
  const CalendarPermissionAlertDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Turn on calendar permissions'),
      content: Column(
        children: [
          Spacing().vertical(10),
          const Text(
              'By allowing us access to your calendar, we can add a reminder for you to pick up this order on your selected date'),
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
