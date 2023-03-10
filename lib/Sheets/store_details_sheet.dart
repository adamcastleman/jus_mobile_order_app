import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/formulas.dart';
import 'package:jus_mobile_order_app/Helpers/launchers.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Providers/future_providers.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';

class StoreDetailsSheet extends ConsumerWidget {
  const StoreDetailsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceTimezone = ref.watch(deviceTimezoneProvider);
    final location = ref.watch(selectedLocationProvider);

    return deviceTimezone.when(
      loading: () => const Loading(),
      error: (e, _) => ShowError(
        error: e.toString(),
      ),
      data: (data) => Wrap(children: [
        Column(
          children: [
            const SheetNotch(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      location.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Spacing().vertical(20),
                    const Text(
                      'Address:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacing().vertical(5),
                    InkWell(
                      onTap: () {
                        Launcher().launchMaps(
                            latitude: location.latitude,
                            longitude: location.longitude,
                            label: location.name);
                      },
                      child: Text(
                        '${location.address['streetNumber']} ${location.address['streetName']}',
                        style: const TextStyle(
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Launcher().launchMaps(
                            latitude: location.latitude,
                            longitude: location.longitude,
                            label: location.name);
                      },
                      child: Text(
                        '${location.address['city']}, ${location.address['state']} ${location.address['zip']}',
                        style: const TextStyle(
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    Spacing().vertical(20),
                    const Text(
                      'Phone:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacing().vertical(5),
                    InkWell(
                      onTap: () {
                        Launcher().launchPhone(number: location.phone);
                      },
                      child: Text(
                        '${location.phone}',
                        style: const TextStyle(
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    Spacing().vertical(20),
                    const Text(
                      'Store Hours:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacing().vertical(5),
                    displayStoreHours(data, ref),
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  displayStoreHours(String deviceTimezone, WidgetRef ref) {
    final location = ref.watch(selectedLocationProvider);
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: location.hours.length,
      itemBuilder: (context, index) {
        var parseStartTime =
            DateFormat('h:mm').parse('${location.hours[index]['open']}');
        var parseEndTime =
            DateFormat('h:mm').parse('${location.hours[index]['close']}');
        var formatStartTime =
            DateFormat('h:mm a').format(parseStartTime).toLowerCase();
        var formatEndTime =
            DateFormat('h:mm a').format(parseEndTime).toLowerCase();
        return Text(
          '${location.hours[index]['dayOfWeek']}: $formatStartTime - $formatEndTime ${Time().locationTimezoneAbbreviation(deviceTimezone: deviceTimezone, locationTimezone: location.timezone)}',
          style: TextStyle(
            fontWeight: boldIfCurrentDay(ref, index),
          ),
        );
      },
    );
  }

  boldIfCurrentDay(WidgetRef ref, int index) {
    final location = ref.watch(selectedLocationProvider);
    var locationTime =
        Time().convertLocalTimeToLocationTime(location: location);
    var dayOfWeek = Formulas()
        .getWeekdayFromName(dayOfWeek: location.hours[index]['dayOfWeek']);

    if (locationTime.weekday == dayOfWeek) {
      return FontWeight.bold;
    } else {
      return FontWeight.normal;
    }
  }
}
