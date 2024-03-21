import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jus_mobile_order_app/Helpers/divider.dart';
import 'package:jus_mobile_order_app/Helpers/locations.dart';
import 'package:jus_mobile_order_app/Helpers/navigation.dart';
import 'package:jus_mobile_order_app/Helpers/orders.dart';
import 'package:jus_mobile_order_app/Helpers/pickers.dart';
import 'package:jus_mobile_order_app/Helpers/spacing_widgets.dart';
import 'package:jus_mobile_order_app/Helpers/time.dart';
import 'package:jus_mobile_order_app/Providers/ProviderWidgets/timezone_provider_widget.dart';
import 'package:jus_mobile_order_app/Providers/order_providers.dart';
import 'package:jus_mobile_order_app/Providers/product_providers.dart';

class OrderPickupDateTile extends ConsumerWidget {
  const OrderPickupDateTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(allProductsProvider);
    return TimezoneProviderWidget(
      builder: (deviceTimezone) => Column(
        children: [
          JusDivider.thin(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.calendar),
            title: const Text('Schedule your pickup date'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your cart contains items that must be scheduled in advance.',
                  style: TextStyle(fontSize: 12),
                ),
                Spacing.vertical(
                    ref.watch(selectedPickupDateProvider) == null ? 0 : 10),
                Row(
                  children: [
                    Text(
                      Time().displayPickupDate(ref),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacing.horizontal(5),
                    determineTimezoneAbbreviation(ref, deviceTimezone),
                  ],
                ),
              ],
            ),
            trailing: const Icon(
              CupertinoIcons.chevron_down,
              size: 18,
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              openScheduleOrLocationPicker(
                context,
                ref,
                OrderHelpers.listOfScheduledItems(
                    scheduledItems: OrderHelpers.scheduledItems(ref),
                    products: products),
              );
            },
          ),
        ],
      ),
    );
  }

  determineTimezoneAbbreviation(WidgetRef ref, dynamic deviceTimezone) {
    if (ref.watch(selectedPickupDateProvider) == null ||
        LocationHelper().selectedLocation(ref) == null ||
        deviceTimezone == LocationHelper().selectedLocation(ref).timezone) {
      return const SizedBox();
    } else {
      return Text(
        Time().locationTimezoneAbbreviation(
          deviceTimezone: deviceTimezone,
          locationTimezone: LocationHelper().selectedLocation(ref).timezone,
        ),
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    }
  }

  openScheduleOrLocationPicker(BuildContext context, WidgetRef ref,
      List<Map<String, dynamic>> scheduledList) {
    if (LocationHelper().selectedLocation(ref) == null) {
      NavigationHelpers().navigateToLocationPage(context, ref);
    } else {
      OrderHelpers.setMinimumScheduleDate(ref);
      return Picker().date(context, scheduledList);
    }
  }
}
