import 'package:flutter/cupertino.dart';

class ScreenshotDialog extends StatelessWidget {
  const ScreenshotDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(
        'Whoops...',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      content: const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
            'It looks like you are attempting to store your Member code. For security and authenticity, only live-generated QR codes are valid. Screenshots will be rejected by the scanner.'),
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          isDestructiveAction: false,
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}
