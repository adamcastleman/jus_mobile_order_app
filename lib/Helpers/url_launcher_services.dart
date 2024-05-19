import 'package:flutter/material.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Sheets/invalid_sheet_single_pop.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  /// Launches a URL if it can be launched.
  Future<void> payInvoice(BuildContext context, String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url)); // Correct method call to launch the URL
    } else {
      NavigationHelpers.showDialogWeb(
        context,
        const InvalidSheetSinglePop(
          error:
              'We cannot reactivate your subscription right now. Please try again later',
        ),
      );
    }
  }
}
