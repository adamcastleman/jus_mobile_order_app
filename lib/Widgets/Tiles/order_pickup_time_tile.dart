import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jus_mobile_order_app/Providers/location_providers.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/dates.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/loading.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/pickers.dart';
import 'package:jus_mobile_order_app/Widgets/Helpers/spacing_widgets.dart';

import '../../Providers/future_providers.dart';
import '../Helpers/error.dart';
import '../Helpers/time.dart';

class OrderPickupTimeTile extends ConsumerWidget {
  const OrderPickupTimeTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.clock),
          title: const Text('Pickup time'),
          subtitle: determineAvailableTimeDisplay(ref),
          trailing: const Icon(
            CupertinoIcons.chevron_down,
            size: 18,
          ),
          onTap: () {
            determineIfAcceptingOrders(context, ref);
          },
        ),
        JusDivider().thin(),
      ],
    );
  }

  determineAvailableTimeDisplay(WidgetRef ref) {
    final selectedLocation = ref.watch(selectedLocationProvider);
    final selectedTime = ref.watch(selectedPickupTimeProvider);
    final earliestTime = ref
        .watch(earliestPickupTimeProvider(ref.watch(selectedLocationProvider)));

    final closeTime = ref.watch(selectedLocationCloseTime);
    final openTime = ref.watch(selectedLocationOpenTime);

    final now =
        Time().convertLocalTimeToLocationTime(location: selectedLocation);

    final close =
        DateTime(now.year, now.month, now.day, closeTime.hour, closeTime.minute)
            .subtract(const Duration(minutes: 15));
    final open =
        DateTime(now.year, now.month, now.day, openTime.hour, openTime.minute)
            .subtract(const Duration(minutes: 15));

    final isOpen = now.isAfter(open) && now.isBefore(close);

    if (isOpen) {
      final deviceTimezone = ref.watch(deviceTimezoneProvider);
      return deviceTimezone.when(
        data: (data) {
          return Row(
            children: [
              Text(
                '${DateHelper().displayPickupTime(ref)} @ ${DateFormat('h:mm a').format(selectedTime ?? earliestTime)}',
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
        'This location is not accepting pickup order right now',
        style: TextStyle(fontSize: 10, color: Colors.red),
      );
    }
  }

  bool determineIfAcceptingOrders(BuildContext context, WidgetRef ref) {
    if (Time().acceptingOrders(context, ref)) {
      ref
          .read(earliestPickupTimeProvider(ref.watch(selectedLocationProvider))
              .notifier)
          .state = Time().now(ref);
      Picker().time(context, ref);
      return true;
    } else {
      return false;
    }
  }
}
