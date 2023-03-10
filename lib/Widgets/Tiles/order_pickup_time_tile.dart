import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/error.dart';
import 'package:jus_mobile_order_app/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/pickers.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';

import '../../Helpers/time.dart';
import '../../Providers/future_providers.dart';

class OrderPickupTimeTile extends ConsumerWidget {
  const OrderPickupTimeTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        JusDivider().thin(),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.clock),
          title: Text(
              'Pickup time ${ref.watch(scheduledAndNowItemsInCartProvider) ? 'for remaining items' : ''}'),
          subtitle: determineAvailableTimeDisplay(context, ref),
          trailing: const Icon(
            CupertinoIcons.chevron_down,
            size: 18,
          ),
          onTap: () {
            isLocationAcceptingPickupOrders(context, ref);
          },
        ),
      ],
    );
  }

  determineAvailableTimeDisplay(BuildContext context, WidgetRef ref) {
    final selectedLocation = ref.watch(selectedLocationProvider);
    final selectedTime = ref.watch(selectedPickupTimeProvider);

    if (Time().acceptingOrders(context, ref) &&
        LocationHelper().acceptingOrders(ref)) {
      final deviceTimezone = ref.watch(deviceTimezoneProvider);
      return deviceTimezone.when(
        data: (data) {
          return Row(
            children: [
              Text(
                '${Time().formatPickupTime(ref)} @ ${DateFormat('h:mm a').format(selectedTime ?? Time().earliestPickUpTime(ref))}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacing().horizontal(4),
              selectedLocation.timezone != data
                  ? Text(
                      Time().locationTimezoneAbbreviation(
                        deviceTimezone: data,
                        locationTimezone: selectedLocation.timezone,
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const SizedBox(),
            ],
          );
        },
        error: (e, _) => ShowError(error: e.toString()),
        loading: () => const Loading(),
      );
    } else {
      return const Text(
        'This location is not accepting pickup orders right now',
        style: TextStyle(fontSize: 10, color: Colors.red),
      );
    }
  }

  isLocationAcceptingPickupOrders(BuildContext context, WidgetRef ref) {
    if (!Time().acceptingOrders(context, ref)) return;

    final selectedLocation = LocationHelper().selectedLocation(ref);
    if (selectedLocation == null) {
      return LocationHelper().chooseLocation(context, ref);
    } else if (!LocationHelper().acceptingOrders(ref)) {
      return;
    } else {
      HapticFeedback.lightImpact();
      ref.read(originalMinimumTimeProvider.notifier).state =
          Time().nowRounded(ref);
      ref.read(selectedPickupTimeProvider.notifier).state =
          Time().nowRounded(ref);
      return Picker().time(context, ref);
    }
  }
}
