import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Providers/future_providers.dart';
import 'package:jus_mobile_order_app/Widgets/General/sheet_notch.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/error.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/formulas.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/launchers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/time.dart';

import '../Models/location_model.dart';

class StoreDetailsPage extends ConsumerWidget {
  final LocationModel location;

  const StoreDetailsPage({required this.location, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceTimezone = ref.watch(deviceTimezoneProvider);

    return deviceTimezone.when(
        loading: () => const Loading(),
        error: (e, _) => ShowError(
              error: e.toString(),
            ),
        data: (data) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  const SheetNotch(),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0, left: 32.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            location.name,
                            style: Theme.of(context).textTheme.headline5,
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
                          displayStoreHours(location, deviceTimezone),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  displayStoreHours(LocationModel location, AsyncValue deviceTimezone) {
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
          '${location.hours[index]['dayOfWeek']}: $formatStartTime - $formatEndTime ${Time().locationTimezoneAbbreviation(deviceTimezone: deviceTimezone.value, locationTimezone: location.timezone)}',
          style: TextStyle(fontWeight: boldIfCurrentDay(location.hours[index])),
        );
      },
    );
  }

  boldIfCurrentDay(Map hours) {
    var locationTime =
        Time().convertLocalTimeToLocationTime(location: location);
    var dayOfWeek =
        Formulas().getWeekdayFromName(dayOfWeek: hours['dayOfWeek']);

    if (locationTime.weekday == dayOfWeek) {
      return FontWeight.bold;
    } else {
      return FontWeight.normal;
    }
  }
}
