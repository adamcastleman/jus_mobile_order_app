import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Providers/order_providers.dart';

class Launcher {
  launchMaps(
      {required double latitude, required double longitude, required label}) {
    return MapsLauncher.launchCoordinates(latitude, longitude, 'jüs - $label');
  }

  launchPhone({required int number}) async {
    Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not call $url. Please try again.';
    }
  }

  launchCalendar(WidgetRef ref) {
    var time = ref.watch(selectedPickupDateProvider)!;
    var formatStart = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime(time.year, time.month, time.day, 08, 00, 00));
    var formatEnd = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime(time.year, time.month, time.day, 09, 00, 00));
    var start = DateTime.parse(formatStart);
    var end = DateTime.parse(formatEnd);
    return Add2Calendar.addEvent2Cal(
      Event(
        startDate: start,
        endDate: end,
        title: 'Pickup jüs order',
        allDay: false,
        iosParams: const IOSParams(
          reminder: Duration(hours: 0),
        ),
      ),
    );
  }
}
